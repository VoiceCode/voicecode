class EnabledCommandsManager extends require('./settings_manager')
  # singleton
  instance = null
  constructor: ->
    if instance
      return instance
    else
      instance = super("generated/enabled_commands")
      @processSettings()
      # Events.once 'userAssetsLoading', =>
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

module.exports = new EnabledCommandsManager()
