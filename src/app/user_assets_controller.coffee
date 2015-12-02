fs = require 'fs'
os = require 'os'
path = require 'path'
chokidar = require 'chokidar'
coffeeScript = require 'coffee-script'
asyncblock = require 'asyncblock'

class UserAssetsController
  instance = null
  constructor: ->
    return instance if instance?
    instance = @
    @assetsPath = Settings.userAssetsPath.replace /^~/, os.homedir()
    log 'assetPath', @assetsPath, "Assets path: #{@assetsPath}"
    @init()
    @watchers = {}
    @debouncedFinish = null

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
    emit 'userAssetsLoading', assetsMask
    @watchers[assetsMask] = chokidar.watch "#{@assetsPath}/#{assetsMask}",
      persistent: true
      ignored: ignoreMask
    @watchers[assetsMask].on('add', (path) =>
      @handleFile 'added', path
    ).on('change', (path) =>
      @handleFile 'changed', path
    ).on('error', (err) ->
      error 'userAssetEventError', err, err
    ).on 'ready', ->

  handleFile: (event, fileName) ->
    if fileName.match(/.coffee$/)?
      cleanFileName = fileName.split('/')[-1..].pop().replace /\.coffee$/, ''
      log 'userAssetEvent', {event, fileName},
      "User asset #{event}: #{fileName}"
      asyncblock (flow) =>
        flow.firstArgIsError = false
        data = flow.sync @readFile fileName, flow.callback()
        try
          data = flow.sync @compileCoffeeScript data, flow.callback()
          pack = Packages.get("user:#{cleanFileName}") or
          Packages.register
            name: "user:#{cleanFileName}"
            description: "User commands and stuff in #{fileName}"
            tags: ['user', "#{cleanFileName}.coffee"]

          Commands = {}
          # _.extend Commands, global.Commands <- does not work, prototypes or whatnot
          Commands.addMisspellings = global.Commands.addMisspellings.bind global.Commands
          Commands.changeSpoken = global.Commands.changeSpoken.bind global.Commands
          Commands.edit = global.Commands.edit.bind global.Commands
          Commands.create = (name, options) ->
            if _.isObject name
              pack.commands.call pack, name
            else
              pack.commands.call pack, {"#{name}": options}
          Commands.before = (name, options) ->
            if _.isObject name
              pack.before.call pack, name
            else
              pack.before.call pack, {"#{name}": options}
          Commands.after = (name, options) ->
            if _.isObject name
              pack.after.call pack, name
            else
              pack.after.call pack, {"#{name}": options}

          eval data
        catch err
          warning 'userAssetEvaluationError', {err, fileName}, "#{fileName}:\n#{err}"
        log 'userAssetEvaluated', {event, fileName},
        "User asset evaluated: #{fileName}"
        @debouncedFinish ?= _.debounce =>
          emit 'userAssetsLoaded'
          @debouncedFinish = null
        , 500
        @debouncedFinish()


module.exports = new UserAssetsController
