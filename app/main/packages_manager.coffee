os = require 'os'
http = require 'http'
git = require 'gitty'
fs = require 'fs-extra'
npm = require 'npm'
semver = require 'semver'
path = require 'path'
class PackagesManager
  constructor: ->
    @packagePath = AssetsController.assetsPath + "/packages/"
    @getPackageRegistry (err, registry) =>
      if err
        error 'packagesManagerRegistryError'
        , err, "Failed retrieving package registry: #{err.message}"
      else
        @registry = registry
      emit 'packagesManagerReady'

    Events.on 'installPackage', @installPackage.bind(@)
    Events.on 'updatePackage', @updatePackage.bind(@)
    Events.on 'removePackage', @removePackage.bind(@)
    Events.on 'packageRepoUpdated', ({pack}) => @fetch pack
    Events.once 'packageAssetsLoaded', =>
      # register all non-installed packages
      _.each @registry.all, ({repo, description}, name) ->
        pack = Packages.get name
        pack ?= Packages.register {
          name,
          description,
          installed: false,
          repo
        }
        pack.options.repo = repo
        emit 'packageUpdated', {pack}
        true
    Events.once 'userAssetsLoaded', @fetchAll.bind(@)

  installPackage: (name, callback) ->
    callback ?= ->
    repo = @registry.all[name].repo
    version = @determineVersion name
    if version is false
      notify "incompatible package: #{name}"
      return callback 'incompatiblePackage', name
      , "Package: #{name} - no compatible version available"
    version ?= 'master'
    safeName = _.snakeCase name
    destination = path.join AssetsController.assetsPath, 'packages', safeName
    temporary = path.join os.tmpdir(), '/voicecode/packages/', String(Date.now()), safeName
    # skip it if it exists
    if fs.existsSync(destination)
      emit 'packageDestinationFolderExists', destination
      return callback null, true
    emit 'installingPackageFolder', name, destination, version
    Packages.remove name
    callback = _.wrap callback, (callback, err) ->
      callback.apply @, _.toArray(arguments)[1..]
      if err
        return error 'packageRepoInstallError', err, err.message
      emit 'packageRepoInstalled', {repo: destination, pack: name}
    git.clone temporary, repo, (err) ->
      console.log  'git clone'
      if err
        return callback err
      repository = git(temporary)
      repository.checkout version, (err) ->
        console.log 'git checkout'
        if err
          return callback err
        optional = ''
        moveDirCmd = 'mv'
        makeDirCmd = 'mkdir -p'
        nodePath = '/usr/local/bin/node '
        npmSettings = {
          npm_config_target: "#{process.versions.electron}"
          npm_config_arch: 'x64'
          npm_config_disturl: 'https://atom.io/download/atom-shell'
          npm_config_runtime: 'electron'
          npm_config_build_from_source: true
          HOME: path.join os.homedir(), '.electron-gyp'
        }
        if platform is 'windows'
          moveDirCmd = 'move'
          makeDirCmd = 'mkdir'
          nodePath = path.join 'C:', 'Program Files', 'nodejs', 'node'
          nodePath = '"' + nodePath + '"'
          # optional = ' > nul 2> nul'
        env = _.assign process.env, npmSettings
        npmCommand = path.join projectRoot, '/node_modules/npm/bin/npm-cli.js'
        # all of this will most likely fail when user has a space in his name
        commandString = "#{makeDirCmd} " +
        path.join(temporary, 'node_modules') +
        " && #{nodePath} #{npmCommand} install --silent --prefix " +
        temporary + ' ' + temporary ' ' +
        optional + " && #{moveDirCmd} #{temporary} #{destination}"
        Execute commandString, {env}, (err) ->
          if err
            return callback err
          callback null, true

  getPackageRegistry: (callback) ->
    if not Network.online
      return callback new Error 'Not online'
    http.get(
      host: 'updates.voicecode.io'
      path: '/packages/registry/raw/master/packages.json'
      timeout: 3000
    , (response) ->
      data = ''
      response.setEncoding 'utf8'
      response.on 'data', (chunk) ->
        data += chunk
      response.on 'end', ->
        registry = JSON.parse data
        if _.isObject registry
          callback null, registry
        else
          callback new TypeError 'Malformed registry response', data
      response.resume()
    ).on('error', (e) ->
      callback e
    )

  determineVersion: (name) ->
    versions = @registry?.all?[name]?.versions
    if versions
      for version, index in versions
        if semver.satisfies global.appVersion, version[0]
          return version[1]
    return null

  downloadBasePackages: (callback) ->
    if not Network.online
      return callback new Error 'Cant download base packages'
    @downloadPackageGroup 'base', callback

  downloadRecommendedPackages: (callback) ->
    return callback new Error 'Cant download recommended packages'
    @downloadPackageGroup 'recommended', callback

  downloadPackageGroup: (group, callback) ->
    funk = asyncblock.nostack
    if developmentMode
      funk = asyncblock
    funk (cloneFlow) =>
      try
        _.every @registry[group], (name) =>
          @installPackage name, cloneFlow.add()
          true
        cloneFlow.wait()
        callback null, true
      catch err
        callback err

  installAllPackages: ->
    _.every @registry.all, (info, name) ->
      emit 'installPackage', name
      true

  getInstalled: ->
    return @installed if @installed?
    @installed = fs.readdirSync @packagePath
    @installed = _.reject @installed, (repo) -> repo.match /\..*/

  updatePackage: (name) ->
    git("#{@packagePath}#{name}").pull 'origin', 'master', (err) =>
      if err
        error 'packageRepoUpdateError'
        , {repo: "#{@packagePath}#{name}", pack: name, err}
        , "Failed to update package: #{name}"
      else
        emit 'packageRepoUpdated'
        , {repo: "#{@packagePath}#{name}", pack: name}

  removePackage: (name) ->
    if name in @registry.base
      return emit 'packageRequired', {name}
    fs.remove AssetsController.assetsPath + "/packages/#{name}/"
    , (err) ->
      if err
        return error 'removePackageFailed', err, err.message
      else
        log 'packageRemoved', name, "Package removed: #{name}"

  fetch: (repoName) ->
    repo = git("#{@packagePath}#{repoName}")
    repo.fetch 'origin'
    , (err, result) =>
      if err
        return error 'packagesManagerFetchError'
        , repo, "Failed to fetch #{repoName} repository"
      repo.status (err, status) =>
        emit 'packageRepoStatusUpdated'
        , {repoName, status}
        if status.behind
          @log repoName
    if version = @determineVersion repoName
      # only if it is not master
      if version
        repo.checkout version, (err) ->
          if err
            error 'packagesManagerCheckoutError', repo, "Failed to check out #{repoName}/#{version}"

  log: (repoName) ->
    repo = git("#{@packagePath}#{repoName}")
    repo.log 'origin/master...'
    , (err, log) ->
      if err
        return error 'packagesManagerLogError'
        , repo, "Failed to Log #{repoName} repository"
      emit 'packageRepoLogUpdated'
      , {repoName, log}

  fetchAll: ->
    installed = @getInstalled()
    _.each installed, (repoName) =>
      @fetch repoName


Events.on 'packageRepoStatusUpdated', ({repoName, status}) ->
  if status.behind
    BadgeCounter.add repoName
  else
    BadgeCounter.remove repoName

module.exports = new PackagesManager
