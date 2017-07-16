BaseController = require '../base/main_controller'

module.exports = new class DarwinMainController
  constructor: ->
    super
    $.framework 'Foundation'# TODO: move?
    $.framework 'Quartz'
    $.framework 'AppKit'

    Events.once 'startupComplete', =>
      if developmentMode
        @listenOnSocket "/tmp/voicecode_events_dev.sock"
        , @systemEventHandler
      else
        runnable = "#{projectRoot}/bin/DarwinEventMonitor.app/Contents/MacOS/DarwinEventMonitor"
        @startEventMonitor rentable

      if Settings.core.slaveMode
        @listenAsSlave()
      else
        @listenOnSocket "/tmp/voicecode_devices.sock"
        , @deviceHandler
