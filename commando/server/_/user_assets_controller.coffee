class UserAssetsController
  instance = null
  constructor: ->
    return instance if instance?
    @fs = Meteor.npmRequire 'fs'
    @path = Meteor.npmRequire 'path'
    @coffeeScript = Meteor.npmRequire 'coffee-script'
    @assetsPath = Settings.userAssetsPath.replace /^~/, @getUserHome()
    console.log "Assets path: #{@assetsPath}"
    @init()
    instance = @

  getUserHome: ->
    process.env[if process.platform == 'win32' then 'USERPROFILE' else 'HOME']

  walk: (currentDirPath, filenameMask = null, callback) ->
    filenameMask = new RegExp filenameMask if filenameMask?
    @fs.readdirSync(currentDirPath).forEach (name) =>
      filePath = @path.join(currentDirPath, name)
      stat = @fs.statSync(filePath)
      if (stat.isDirectory() and not filenameMask?) or (stat.isFile() and filePath.match filenameMask)
        callback filePath, stat
      else if stat.isDirectory()
        @walk filePath, filenameMask, callback

  readFile: (filePath, callback) ->
    callback (@fs.readFileSync filePath, {encoding: 'utf8'})

  compileCoffeeScript: (data, callback) ->
    callback @coffeeScript.compile data

  init: ->
    try
      @fs.mkdirSync @assetsPath
      # @fs.statSync @assetsPath
    catch error
      if error.code is 'EEXIST'
        # this is good
      else
        console.error "could not create user assets directory: #{@assetsPath}"
        @state = "error"

    @watchForChanges()

  runUserCode: ->
    return if @state is "error"
    @walk @assetsPath, '.+\.coffee$', (filePath) =>
      @readFile filePath, (data) =>
        @compileCoffeeScript data, (data)->
          console.log "Loading user asset: #{filePath}"
          try
            eval data
          catch error
            console.error filePath
            console.error error

  watchForChanges: ->
    return if @state is "error"
    @watcher = @fs.watch @assetsPath, {persistent: true, recursive: false},
    Meteor.bindEnvironment @handleFileChange @assetsPath

    @walk @assetsPath, null, (directoryPath) =>
      @fs.watch directoryPath, {persistent: true, recursive: false},
      Meteor.bindEnvironment @handleFileChange directoryPath

  handleFileChange: (directoryPath) ->
    (event, fileName) =>
      return unless event is 'change'
      if fileName.indexOf(".coffee", fileName.length - ".coffee".length) >= 0
        console.log "User asset changed: #{directoryPath}/#{fileName}, reacting...."
        @readFile "#{directoryPath}/#{fileName}", Meteor.bindEnvironment (data) =>
          @compileCoffeeScript data, eval
          # What actions to perform here?
          Commands.performCommandEdits()
          Commands.reloadGrammar()

@UserAssetsController = UserAssetsController
