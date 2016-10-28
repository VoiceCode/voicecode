fs = require 'fs'
os = require 'os'
chokidar = require 'chokidar'

class AssetsController
  instance = null
  constructor: ->
    return instance if instance?
    instance = @
    @assetsPath = Settings.userAssetsPath.replace /^~/, os.homedir()
    emit 'assetPath', @assetsPath, "Assets path: #{@assetsPath}"
    @watchers = {}
    Events.once 'packagesManagerReady', @init.bind @

  init: ->
    @createDirectory @assetsPath
    @createSettingsFile()
    @createDirectory @assetsPath + '/packages', (err, created) ->
      return if err
      # always make sure base packages get loaded,
      # in case there was a previous failure
      PackagesManager.downloadBasePackages ->
        # only the first time, install all the recommended packages
        if created
          Events.once 'EnabledCommandsManagerSettingsProcessed', ->
            Commands.enableAllByTag 'recommended'
          PackagesManager.downloadRecommendedPackages ->
            emit 'assetsControllerReady'
        else
          emit 'assetsControllerReady'

  createDirectory: (path, callback) ->
    callback ?= ->
    try
      fs.mkdirSync path
      if callback?
        callback null, true
    catch err
      if err.code is 'EEXIST'
        # this is good
        callback null, false
      else
        error 'assetDirectoryError', path
        , "Could not create user assets directory: #{err.message}"
        callback err
  createSettingsFile: ->
    path =  "#{@assetsPath}/settings.coffee"
    data = """
    _.merge Settings,
      license: ''
      email: ''
    """
    fs.writeFile path, data, {flag: 'wx'}, (err) =>
      if err
        if err.code isnt 'EEXIST'
          global.error 'assetSettingsFileError', err, err.stacktrace
        else
          # this is good, file exists
          return
      log 'userSettingsFileCreated', "#{@assetsPath}/settings.coffee",
      "User settings file created #{@assetsPath}/settings.coffee"

  getAssets: (type, assetsMask, ignoreMask = false) ->
    return if @state is "error"
    emit 'assetsLoading', {type, assetsMask, ignoreMask}
    emit "#{type}AssetsLoading"
    watcherSettings =
      persistent: true
      ignored: ignoreMask
    if type is 'package' # I don't like this, just testing
      _.assign watcherSettings,
        useFsEvents: false
        usePolling: true
        interval: 10000
    unless _.isArray assetsMask
      assetsMask = [assetsMask]
    assetsMask = _.map assetsMask, (mask) => "#{@assetsPath}/#{mask}"
    @watchers[assetsMask.join('|')] = chokidar.watch assetsMask, watcherSettings
    @watchers[assetsMask.join('|')].on('add', (path) =>
      @handleFile type, 'added', path
    ).on('change', (path) =>
      @handleFile type, 'changed', path
    ).on('error', (err) ->
      error 'assetEventError', {type, err}, err
      error "#{type}AssetsEventError", {type, err}, err
    ).on 'ready', ->
      emit "#{type}AssetsLoaded"
      emit 'assetsLoaded', type


  handleFile: (type, event, fullPath) ->
    if coffee = fullPath.match(/.coffee$/) or js = fullPath.match(/.js$/)
      extension = if coffee then '.coffee' else '.js'
      fileName = path.basename fullPath, extension
      emit 'assetEvent', {event, fullPath, type}
      emit "#{type}AssetEvent", {event, fullPath, type}
      try
        unless type is 'package'
          global.Package = Packages.get("user:#{fileName}") or
          Packages.register
            name: "user:#{fileName}"
            description: "User code in #{fileName}#{extension}"
            tags: ['user', "#{fileName}#{extension}"]
        if event is 'changed'
          delete require.cache[fullPath]
        require fullPath
      catch err
        emit 'assetEvaluationError', {event, type, err, fullPath, fileName}
        error "#{type}AssetEvaluationError",
        {error: err.stack, fullPath}
        , "#{fullPath.replace(@assetsPath, '')}:\n#{err}"
      emit 'assetEvaluated', {event, type, fullPath, fileName}
      emit "#{type}AssetEvaluated", {event, type, fullPath, fileName},
      "Asset type '#{type}' #{event} & evaluated:\n#{fullPath}"


module.exports = new AssetsController
