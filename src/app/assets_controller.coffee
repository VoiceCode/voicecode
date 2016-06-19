fs = require 'fs'
os = require 'os'
chokidar = require 'chokidar'

class AssetsController
  instance = null
  constructor: ->
    return instance if instance?
    instance = @
    @assetsPath = Settings.userAssetsPath.replace /^~/, os.homedir()
    log 'assetPath', @assetsPath, "Assets path: #{@assetsPath}"
    @init()
    @watchers = {}
    @debouncedFinish = null


  init: ->
    try
      fs.mkdirSync @assetsPath
    catch err
      if err.code is 'EEXIST'
        # this is good
      else
        error 'assetDirectoryError', @assetsPath,
         "Could not create user assets directory: #{@assetsPath}"
        @state = "error"

    path =  "#{@assetsPath}/settings.coffee"
    data = """
_.merge Settings,
  license: ''
  email: ''
    """
    fs.writeFile path, data, {flag: 'wx'}, (err) =>
      if err
        if err.code isnt 'EEXIST'
          # need to explicitly call global.error,
          # there is an error variable in a closure /sad feels
          global.error 'assetSettingsFileError', err, err.stacktrace
          @state = "error"
        else
          # this is good, file exists
          return
      log 'userSettingsFileCreated', "#{@assetsPath}/settings.coffee",
      "User settings file created #{@assetsPath}/settings.coffee"

  getAssets: (type, assetsMask, ignoreMask = false) ->
    return if @state is "error"
    emit 'assetsLoading', {type, assetsMask, ignoreMask}
    emit "#{type}AssetsLoading"
    @watchers[assetsMask] = chokidar.watch "#{@assetsPath}/#{assetsMask}",
      persistent: true
      ignored: ignoreMask
    @watchers[assetsMask].on('add', (path) =>
      @handleFile type, 'added', path
    ).on('change', (path) =>
      @handleFile type, 'changed', path
    ).on('error', (err) ->
      error 'assetEventError', err, err
      error "#{type}AssetsEventError", err, err
    ).on 'ready', ->
      emit "#{type}AssetsLoaded"
      emit 'assetsLoaded'


  handleFile: (type, event, fullPath) ->
    if coffee = fullPath.match(/.coffee$/) or js = fullPath.match(/.js$/)
      extension = if coffee then '.coffee' else '.js'
      fileName = path.basename fullPath, extension
      emit 'assetEvent', {event, fullPath}
      emit "#{type}AssetEvent", {event, fullPath}
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
        emit 'assetEvaluationError', {err, fullPath}, "#{fullPath}:\n#{err}"
        error "#{type}AssetEvaluationError",
        {error: err.stack, fullPath}, "#{fullPath}:\n#{err}"
      emit 'assetEvaluated', {event, type, fullPath, fileName}
      log "#{type}AssetEvaluated", {event, type, fullPath, fileName},
      "Asset type '#{type}' #{event} & evaluated:\n#{fullPath}"
      # @debouncedFinish ?= _.debounce =>
      #   emit "#{type}AssetsLoaded"
      #   emit 'assetsLoaded'
      #   @debouncedFinish = null
      # , 500
      # @debouncedFinish()


module.exports = new AssetsController
