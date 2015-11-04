fs = require 'fs'
path = require 'path'
chokidar = require 'chokidar'
coffeeScript = require 'coffee-script'
asyncblock = require 'asyncblock'

class UserAssetsController
  instance = null
  constructor: ->
    return instance if instance?
    @assetsPath = Settings.userAssetsPath.replace /^~/, @getUserHome()
    log 'assetPath', @assetsPath, "Assets path: #{@assetsPath}"
    @init()
    @watchers = {}
    instance = @


  getUserHome: ->
    process.env[if process.platform == 'win32' then 'USERPROFILE' else 'HOME']

  readFile: (filePath, callback) ->
    callback (fs.readFileSync filePath, {encoding: 'utf8'})

  compileCoffeeScript: (data, callback) ->
    callback coffeeScript.compile data

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

    path =  "#{@assetsPath}/user_settings.coffee"
    data = """
_.extend Settings,
  license: ''
  email: ''
  dragonVersion: 5
    """
    fs.writeFile path, data, {flag: 'wx'}, (err) =>
      if err
        if err.code isnt 'EEXIST'
          # need to explicitly call global.error,
          # there is an error variable in a closure /sad feelsk
          global.error 'assetSettingsFileError', err, err
          @state = "error"
        else
          # this is good, file exists
          return
      log 'assetSettingsFileCreated', "#{@assetsPath}/user_settings.coffee",
      "User settings file created #{@assetsPath}/user_settings.coffee"


  getAssets: (assetsMask, ignoreMask = false) ->
    return if @state is "error"
    @watchers[assetsMask] = chokidar.watch "#{@assetsPath}/#{assetsMask}",
      persistent: true
      ignored: ignoreMask
    @watchers[assetsMask].on('add', (path) =>
      @handleFile 'added', path
    ).on('change', (path) =>
      @handleFile 'changed', path
    ).on('error', (err) ->
      error 'userAssetEventError', err, err
    ).on('ready', ->)


  handleFile: (event, fileName) ->
    if fileName.indexOf(".coffee", fileName.length - ".coffee".length) >= 0
      log 'userAssetEvent', {event, fileName},
      "User asset #{event}: #{fileName}"
      @readFile fileName, (data) =>
        @compileCoffeeScript data, (data) ->
          try
            eval data
          catch err
            error 'userAssetEvaluationError', fileName, "fileName: #{fileName}"
            error 'userAssetEvaluationError', err, err
          log 'userAssetEvaluation', {event, fileName},
          "User asset evaluated: #{fileName}"



module.exports = new UserAssetsController
