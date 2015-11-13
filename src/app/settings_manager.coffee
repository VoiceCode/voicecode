fs = require 'fs'
path = require 'path'

class SettingsManager
  debouncedSave = null
  constructor: (@name) ->
    @file = path.resolve(UserAssetsController.assetsPath, "#{@name}.json")
    if @needsCreating()
      @create()
    @loadSettings()
  needsCreating: ->
    not @fileExists()
  create: ->
    try
      fs.mkdirSync path.dirname(@file),
    catch error
      if error.code is 'EEXIST'
        # this is good
      else
        error 'assetDirectoryError', @file,
         "Could not create user assets directory: #{@file}"
        @state = "error"
    fs.writeFileSync @file, '{}', 'utf8'
  fileExists: ->
    fs.existsSync(@file)
  loadSettings: ->
    @settings = JSON.parse(fs.readFileSync(@file, 'utf8'))
    emit "#{@constructor.name}SettingsLoaded", {@file}
  update: (object) ->
    @settings = object
    @save()
  _save: ->
    fs.writeFile @file, JSON.stringify(@settings, null, 4), 'utf8'
    debouncedSave = null
    emit "#{@constructor.name}SettingsSaved", {@file}
  save: ->
    unless debouncedSave?
      debouncedSave = _.debounce _.bind(@_save, @), 1000
    debouncedSave()

class EnabledCommandsManager extends SettingsManager
  # singleton
  instance = null
  constructor: ->
    if instance
      return instance
    else
      instance = super("generated/enabled_commands")
      Events.once 'userAssetsLoading', =>
        @subscribeToEvents()
      @processSettings()

  processSettings: ->
    _.each @settings, (isEnabled, commandName) ->
      if isEnabled
        emit 'enableCommand', commandName
      else
        emit 'disableCommand', commandName
    emit 'EnabledCommandsManagerSettingsProcessed'

  subscribeToEvents: ->
    Events.on 'commandEnabled', (success, commandName) =>
      if success
        @enable [commandName]
        @save()
    Events.on 'commandDisabled', (success, commandName) =>
      if success
        @disable [commandName]
        @save()
    Events.on 'commandNotFound', (commandName) =>
      delete @settings[commandName]
      @save()

  enable: (names) ->
    for name in names
      @settings[name] = true
    @save()

  disable: (names) ->
    for name in names
      delete @settings[name]
    @save()

module.exports = {SettingsManager, EnabledCommandsManager: new EnabledCommandsManager}
