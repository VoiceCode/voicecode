class EnabledCommandsManager extends require('./settings_manager')
  # singleton
  instance = null
  constructor: ->
    if instance
      return instance
    else
      instance = super("generated/enabled_commands")
      # @watchForInvalidCommands()
      @processSettings()
      @subscribeToEvents()
  watchForInvalidCommands: ->
    # If you get a syntax error in a package,
    # it disables all those commands if they are referenced anywhere else
    # need a more sophisticated check - maybe the first time, it sets a timestamp
    # and then later, if that timestamp is more than a day or 2 old it deletes the setting
    Events.on 'commandNotFound', (commandName) =>
      delete @settings[commandName]
      @save()
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
