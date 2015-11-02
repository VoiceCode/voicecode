fs = require 'fs'
path = require 'path'
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
      # fs.statSync @assetsPath
    catch error
      if error.code is 'EEXIST'
        # this is good
      else
        error 'assetDirectoryError', @assetsPath,
         "Could not create user assets directory: #{@assetsPath}"
        @state = "error"

    @watchForChanges()

  runUserCode: ->
    return if @state is "error"
    @walk @assetsPath, '.+\.coffee$', (filePath) =>
      @readFile filePath, (data) =>
        @compileCoffeeScript data, (data)->
          log 'assetEvaluation', filePath, "Loading user asset: #{filePath}"
          try
            eval data
          catch err
            error 'assetEvaluationError', filePath, "filePath: #{filePath}"
            error 'assetEvaluationError', err, err

  watchForChanges: ->
    return if @state is "error"
    @watcher = fs.watch @assetsPath, {persistent: true, recursive: false},
    @handleFileChange @assetsPath

    @walk @assetsPath, null, (directoryPath) =>
      fs.watch directoryPath, {persistent: true, recursive: false},
      @handleFileChange directoryPath

  handleFileChange: (directoryPath) ->
    (event, fileName) =>
      return unless event is 'change'
      if fileName.indexOf(".coffee", fileName.length - ".coffee".length) >= 0
        @readFile "#{directoryPath}/#{fileName}", (data) =>
          @compileCoffeeScript data, eval
          # What actions to perform here?
          log 'assetChanged', {directoryPath, filename},
          "User asset changed: #{directoryPath}/#{fileName}, reacting...."
          Commands.reloadGrammar()

module.exports = new UserAssetsController
