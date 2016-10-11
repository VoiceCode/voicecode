http = require 'http'
git = require 'gitty'
fs = require 'fs-extra'

npm = require 'npm'

class PackagesManager
  constructor: ->
    @packagePath = AssetsController.assetsPath + "/packages/"
    @getPackageRegistry()
    Events.on 'installPackage', @installPackage.bind(@)
    Events.on 'removePackage', @removePackage.bind(@)
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
        true
        @fetchAll()

  installPackage: (name, callback) ->
    Packages.remove name
    repo = @registry.all[name].repo
    destination = AssetsController.assetsPath + "/packages/#{name}"
    temporary = "/tmp/voicecode/packages/#{Date.now()}/#{name}"
    # skip it if it exists
    try if fs.lstatSync(destination).isDirectory()
        return callback? null, true
    git.clone temporary, repo, (err) ->
      if err
        error 'installPackageFailed', err, err.message
        return callback? err
      npmCommand = '/usr/local/bin/node ' + projectRoot + '/node_modules/npm/bin/npm-cli.js'
      npmSettings = [
        'npm_config_target=1.4.3'
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
          error 'installPackageFailed', err, err.message
          return callback? err
        callback? null, true

  getPackageRegistry: (callback) ->
    callback ?= (err) ->
      if err
        return error 'packagesManagerRegistryError'
        , err, "Failed retrieving package registry: #{err.message}"
    http.get(
      host: 'updates.voicecode.io'
      path: '/packages/registry/raw/master/packages.json'
    , (response) =>
      data = ''
      response.setEncoding 'utf8'
      response.on 'data', (chunk) ->
        data += chunk
      response.on 'end', =>
        registry = JSON.parse data
        if _.isObject registry
          @registry = registry
          callback null, @registry
        else
          callback
            message: 'malformed response'
            data: data
      response.resume()
    ).on('error', (e) ->
      callback e
    )

  downloadBasePackages: (path, callback) ->
    @getPackageRegistry (err, registry) =>
      if err?
        error 'getPackageRegistry', e
        , 'Failed getting list of packages: ' + e.message
        return
      funk = asyncblock.nostack
      if developmentMode
        funk = asyncblock
      funk (cloneFlow) =>
        _.every registry.base, (name) =>
          @installPackage name, cloneFlow.add()
          true
        cloneFlow.wait()
        callback null, true

  installAllPackages: ->
    _.every @registry.all, (info, name) ->
      emit 'installPackage', name
      true

  getInstalled: (noCache = false) ->
    return @installed if @installed and not noCache
    @installed = fs.readdirSync @packagePath
    @installed = _.reject @installed, (repo) -> repo.match /\..*/

  updateAllSync: (flow) ->
    installed = @getInstalled()
    _.each installed, (repo) =>
      adder = flow.add()
      git("#{@packagePath}#{repo}").pull 'origin', 'master', (err) ->
        if err
          error 'packagesManagerUpdateError'
          , {repo: "#{@packagePath}#{repo}", err}
          , "Failed to update package: #{repo}"
        else
          emit 'packageRepoUpdated'
          , {repo: "#{@packagePath}#{repo}"}
        adder(true)
      true
    flow.wait()

  removePackage: (name) ->
    if name in @registry.base
      return notify
        title: "#{name} is a base package"
        options:
          body: "It should not be removed"
    fs.remove AssetsController.assetsPath + "/packages/#{name}/"
    , (err) ->
      if err
        return error 'removePackageFailed', err, err.message
      else
        log 'packageRemoved', name, "Package removed: #{name}"

  fetchAll: ->
    installed = @getInstalled()
    _.each installed, (repoName) =>
      repo = git("#{@packagePath}#{repoName}")
      repo.fetch 'origin'
      , (err, result) ->
        if err
          return error 'packagesManagerFetchError'
          , repo, "Failed to fetch #{repoName} repository8"
        repo.status (err, status) ->
          emit 'packageRepoStatusUpdate'
          , {repoName, status}

module.exports = new PackagesManager
