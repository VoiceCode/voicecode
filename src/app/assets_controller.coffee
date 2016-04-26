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
    catch error
      if error.code is 'EEXIST'
        # this is good
      else
        error 'assetDirectoryError', @assetsPath,
         "Could not create user assets directory: #{@assetsPath}"
        @state = "error"

    path =  "#{@assetsPath}/settings.coffee"
    data = """
_.extend Settings,
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


  # getJavascriptCode: (fullPath) ->
  #   directory = path.dirname fullPath
  #   code = fs.readFileSync fullPath, {encoding: 'utf8'}
  #   code = @compileCoffeeScript code, directory
  #   code
  #
  # compileCoffeeScript: (coffeeScriptsSource, directory) ->
  #   compiled = coffeeScript.compile coffeeScriptsSource
  #   compiled.replace /require\(["']\.\/(.*)["']\)/g,
  #   (match, fileName) =>
  #     @getJavascriptCode "#{directory}/#{fileName}.coffee"
  #
  handleFile: (type, event, fullPath) ->
    if fullPath.match(/.coffee$/)?
      fileName = path.basename fullPath, '.coffee' # TODO: handle .js
      emit 'assetEvent', {event, fullPath}
      log "#{type}AssetEvent", {event, fullPath},
      "Asset type '#{type}'#{event}: #{fullPath}"
      try
        # code = @getJavascriptCode fullPath
        unless type is 'package'
          global.Package = Packages.get("user:#{fileName}") or
          Packages.register
            name: "user:#{fileName}"
            description: "User code in #{fileName}.coffee"
            tags: ['user', "#{fileName}.coffee"]
        if event is 'changed'
          delete require.cache[fullPath]
        require fullPath
      catch err
        emit 'assetEvaluationError', {err, fullPath}, "#{fullPath}:\n#{err}"
        warning "#{type}AssetEvaluationError", {error: err.stack, fullPath}, "#{fullPath}:\n#{err}"
      emit 'assetEvaluated', {event, fullPath}
      log "#{type}AssetEvaluated", {event, fullPath},
      "Asset type '#{type}' evaluated: #{fullPath}"
      # @debouncedFinish ?= _.debounce =>
      #   emit "#{type}AssetsLoaded"
      #   emit 'assetsLoaded'
      #   @debouncedFinish = null
      # , 500
      # @debouncedFinish()


module.exports = new AssetsController
