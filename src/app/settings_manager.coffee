fs = require 'fs'
path = require 'path'

class SettingsManager
  debouncedSave = null
  constructor: (@name) ->
    @file = path.resolve(UserAssetsController.assetsPath, "#{@name}.json")
    if @needsMigration()
      @migrate()
    else
      @loadSettings()
  needsMigration: ->
    not @fileExists()
  migrate: ->
    @settings = {}
    @save()
  fileExists: ->
    fs.existsSync(@file)
  loadSettings: ->
    @settings = JSON.parse(fs.readFileSync(@file, 'utf8'))
  update: (object) ->
    @settings = object
    @save()
  _save: ->
    emit 'writingFile', @constructor.name
    fs.writeFileSync @file, JSON.stringify(@settings, null, 4), 'utf8'
    debouncedSave = null
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
      instance = super("enabled_commands")
      @processSettings()

  processSettings: ->
    _.each @settings, (isEnabled, commandName) ->
      if isEnabled
        Commands.enable commandName
      else
        Commands.disable commandName

  subscribeToEvents: ->
    Events.on 'commandEnabled', (success, commandName) =>
      if success
        @enable [commandName]
    Events.on 'commandDisabled', (success, commandName) =>
      if success
        @disable [commandName]
    Events.on 'commandNotFound', (commandName) =>
      delete @settings[commandName]
      @save()

  enable: (names) ->
    for name in names
      @settings[name] = true
    @save()

  disable: (names) ->
    for name in names
      @settings[name] = false
    @save()

module.exports = {SettingsManager, EnabledCommandsManager: new EnabledCommandsManager}
