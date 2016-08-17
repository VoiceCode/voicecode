http = require 'http'
git = require 'gitty'
fs = require 'fs-extra'

class PackagesManager
  constructor: ->
    Events.on 'installPackage', (name) =>
      Packages.remove name
      repo = @registry.all[name].repo
      git.clone AssetsController.assetsPath + "/packages/#{name}", repo, (err) ->
        if err then return error 'installPackageFailed', err, err.message
    Events.on 'removePackage', (name) ->
      fs.remove AssetsController.assetsPath + "/packages/#{name}/", (err) ->
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
    @getPackageRegistry (err, registry) ->
      if err?
        error 'getPackageRegistry', e
        , 'Failed getting list of packages: ' + e.message
        return
      funk = asyncblock.nostack
      if developmentMode
        funk = asyncblock
      funk (cloneFlow) ->
        _.every registry.base, (basePackageName) ->
          git.clone path + basePackageName
          , registry.all[basePackageName].repo, cloneFlow.add()
          true
        cloneFlow.wait()
        callback null, true


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
