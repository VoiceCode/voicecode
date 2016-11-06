http = require 'http'
git = require 'gitty'
fs = require 'fs-extra'
npm = require 'npm'
semver = require 'semver'

class PackagesManager
  constructor: ->
    @packagePath = AssetsController.assetsPath + "/packages/"
    @subscribe()
    if Network.online
      @getPackageRegistry (err, registry) =>
        if err
          error 'packagesManagerRegistryError'
          , err, "Failed retrieving package registry: #{err.message}"
          @prepareOffline()
          emit 'packagesManagerReady'
        else
          @registry = registry
          @populateInitialPackages ->
            emit 'packagesManagerReady'
    else
      @prepareOffline()
      if AssetsController.firstRun
        notify 'Offline mode, no packages installed'
        # TODO wait for online status and
        # retry populate packages
      else
        notify 'Offline mode'
      emit 'packagesManagerReady'
    

  subscribe: ->
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
    Events.once 'userAssetsLoaded', =>
      if Network.online
        @fetchAll.bind(@)

  prepareOffline: ->
    @registry = {all: {}}

  populateInitialPackages: (callback) ->
    # always make sure base packages get loaded,
    # in case there was a previous failure
    @downloadBasePackages =>
      # only the first time, install all the recommended packages
      if AssetsController.firstRun
        Events.once 'EnabledCommandsManagerSettingsProcessed', ->
          Commands.enableAllByTag 'recommended'
        @downloadRecommendedPackages callback
      else
        callback()

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
    destination = AssetsController.assetsPath + "/packages/#{safeName}"
    temporary = "/tmp/voicecode/packages/#{Date.now()}/#{safeName}"
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
      if err
        return callback err
      repository = git(temporary)
      repository.checkout version, (err) ->
        if err
          return callback err
        npmCommand = '/usr/local/bin/node ' + projectRoot + '/node_modules/npm/bin/npm-cli.js'
        npmSettings = [
          "npm_config_target=#{process.versions.electron}"
          'npm_config_arch=x64'
          'npm_config_disturl=https://atom.io/download/atom-shell'
          'npm_config_runtime=electron'
          'npm_config_build_from_source=true'
          'HOME=~/.electron-gyp'
        ].join ' '
        Execute "#{npmSettings} mkdir -p #{temporary}/node_modules && #{npmCommand} install --silent --prefix " +
        temporary + " && mv #{temporary} #{destination}"
        , (err) ->
          if err
            return callback err
          callback null, true

  getPackageRegistry: (callback) ->
    unless Network.online
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
    unless Network.online
      return callback new Error 'Offline: Cant download base packages'
    @downloadPackageGroup 'base', callback

  downloadRecommendedPackages: (callback) ->
    unless Network.online
      return callback new Error 'Offline: Cant download recommended packages'
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
    version = @determineVersion(repoName) or 'master'
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
