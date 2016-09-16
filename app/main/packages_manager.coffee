http = require 'http'
git = require 'gitty'
fs = require 'fs-extra'

npm = require 'npm'

class PackagesManager
  constructor: ->
    Events.on 'installPackage', @installPackage.bind(@)

    Events.on 'removePackage', (name) ->
      fs.remove AssetsController.assetsPath + "/packages/#{name}/"
      , (err) ->
        if err then return error 'removePackageFailed', err, err.message
        else log 'packageRemoved', name, "Package removed: #{name}"
    Events.once 'packageAssetsLoaded', =>
     # register all non-installed packages
      @getPackageRegistry (err, registry) ->
        unless err
          _.each registry.all, ({repo, description}, name) ->
            pack = Packages.get name
            pack ?= Packages.register {name, description, installed: false}
            pack.repo = repo
            true
  installPackage: (name, callback) ->
    Packages.remove name
    repo = @registry.all[name].repo
    destination = AssetsController.assetsPath + "/packages/#{name}"
    temporary = "/tmp/voicecode/packages/#{Date.now()}/#{name}"
    git.clone temporary, repo, (err) ->
      if err
        error 'installPackageFailed', err, err.message
        return callback? err
      npmPath = projectRoot + '/node_modules/npm/bin/npm-cli.js'
      npmSettings = [
        'npm_config_target=0.37.8'
        'npm_config_arch=x64'
        'npm_config_disturl=https://atom.io/download/atom-shell'
        'npm_config_runtime=electron'
        'npm_config_build_from_source=true'
        'HOME=~/.electron-gyp'
      ].join ' '
      Execute "#{npmSettings} mkdir -p #{temporary}/node_modules && #{npmPath} install --silent --prefix " +
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


# class PackageSettingsManager extends require('./settings_manager')
#   # singleton
#   instance = null
#   constructor: ->
#     if instance
#       return instance
#     else
#       instance = super("generated/packages")
#       @processSettings()
#       @subscribeToEvents()
#
#   # happens once on startup
#   processSettings: ->
#     for packageId, packageInfo of @settings
#       if packageInfo.enabled
#         @installPackage packageInfo
#         @enablePackage packageInfo
#       else
#         @disablePackage packageInfo
#
#     emit 'packages:loaded'
#
#   subscribeToEvents: ->
#     Events.on 'packageEnabled', (packageId) =>
#       @enable [packageId]
#
#     Events.on 'packageDisabled', (packageId) =>
#       @disable [packageId]
#
#     Events.on 'packageNotFound', (packageId) =>
#       delete @settings[packageId]
#       @save()
#
#   enable: (names) ->
#     for name in names
#       @settings[name] = true
#     @save()
#
#   disable: (names) ->
#     for name in names
#       delete @settings[name]
#     @save()

module.exports = new PackagesManager
  # PackageSettingsManager: new PackageSettingsManager()
