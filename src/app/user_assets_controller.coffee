fs = require 'fs'
path = require 'path'
chokidar = require 'chokidar'
coffeeScript = require 'coffee-script'

class UserAssetsController
  instance = null
  constructor: ->
    return instance if instance?
    @assetsPath = Settings.userAssetsPath.replace /^~/, @getUserHome()
    log 'assetPath', @assetsPath, "Assets path: #{@assetsPath}"
    @init()
    instance = @

  getUserHome: ->
    process.env[if process.platform == 'win32' then 'USERPROFILE' else 'HOME']

  walk: (currentDirPath, filenameMask = null, callback) ->
    filenameMask = new RegExp filenameMask if filenameMask?
    fs.readdirSync(currentDirPath).forEach (name) =>
      filePath = path.join(currentDirPath, name)
      stat = fs.statSync(filePath)
      if (stat.isDirectory() and not filenameMask?) or (stat.isFile() and filePath.match filenameMask)
        callback filePath, stat
      else if stat.isDirectory()
        @walk filePath, filenameMask, callback

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


  runUserCode: ->
    return if @state is "error"
    @watcher = chokidar.watch "#{@assetsPath}**/*.coffee", persistent: true
    @watcher.on('add', (path) =>
      @handleFile 'added', path
    ).on('change', (path) =>
      @handleFile 'changed', path
    ).on('error', (err) ->
      error 'userAssetEventError', err, err
    ).on('ready', ->)


  handleFile: (event, fileName) ->
    if fileName.indexOf(".coffee", fileName.length - ".coffee".length) >= 0
      log 'userAssetEvent', {event, fileName},
      "User asset #{event}: #{fileName}, evaluating...."

      @readFile fileName, (data) =>
        @compileCoffeeScript data, (data)->
          try
            eval data
          catch err
            error 'assetEvaluationError', fileName, "fileName: #{fileName}"
            error 'assetEvaluationError', err, err
        # What actions to perform here?
        ParserController.generateParser()

module.exports = new UserAssetsController
