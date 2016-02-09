class PackageSettingsManager extends require('./settings_manager')
  # singleton
  instance = null
  constructor: ->
    if instance
      return instance
    else
      instance = super("generated/packages")
      @processSettings()
      @subscribeToEvents()

  # happens once on startup
  processSettings: ->
    for packageId, packageInfo of @settings
      if packageInfo.enabled
        @installPackage packageInfo
        @enablePackage packageInfo
      else
        @disablePackage packageInfo

    emit 'packages:loaded'

  subscribeToEvents: ->
    Events.on 'packageEnabled', (packageId) =>
      @enable [packageId]

    Events.on 'packageDisabled', (packageId) =>
      @disable [packageId]

    Events.on 'packageNotFound', (packageId) =>
      delete @settings[packageId]
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
