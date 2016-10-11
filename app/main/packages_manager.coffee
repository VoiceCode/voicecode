http = require 'http'
git = require 'gitty'
fs = require 'fs-extra'

npm = require 'npm'

class PackagesManager
  constructor: ->
    Events.on 'installPackage', @installPackage.bind(@)
    Events.on 'removePackage', @removePackage.bind(@) 
    Events.once 'packageAssetsLoaded', =>
     # register all non-installed packages
      @getPackageRegistry (err, registry) ->
        unless err
          _.each registry.all, ({repo, description}, name) ->
            pack = Packages.get name
            pack ?= Packages.register {
              name,
              description,
              installed: false,
              repo
            }
            true
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
    callback ?= ->
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
  updateAll: (flow) ->
    packagePath = AssetsController.assetsPath + "/packages/"
    installed = fs.readdirSync packagePath
    _.each installed, (repo) ->
      return true if repo[0] is '.' # TODO any other weird files to ignore?
      adder = flow.add()
      git("#{packagePath}#{repo}").pull 'origin', 'master', (err) ->
        if err
          error 'packagesManagerUpdateError', {repo, err}
          , "Failed to update package: #{repo}"
        else
          emit 'packageUpdated', repo
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


module.exports = new PackagesManager
