class EnabledCommandsManager extends FileManager
  constructor: ->
    super("generated/enabled_commands")
    Events.on 'commandNotFound', (commandName) =>
      delete @settings[commandName]
      @save()
    @processSettings()
    @subscribeToEvents()
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

    Events.on 'commandDisabled', (success, commandName) =>
      if success
        @disable [commandName]

  enable: (names) ->
    for name in names
      @settings[name] = true
    @save()

  disable: (names) ->
    for name in names
      delete @settings[name]
    @save()

module.exports = new EnabledCommandsManager()
