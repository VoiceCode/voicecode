net = require 'net'
fs = require 'fs'
forever = require 'forever'

module.exports = new class MainController
  constructor: ->
    Events.once 'startupComplete', =>
      if developmentMode
        @monitorEvents()
        # @listenOnSocket "/tmp/voicecode_events_dev.sock", @systemEventHandler
      else
        @startEventMonitor()

      if Settings.core.slaveMode
        @listenAsSlave()
      else
        null

  startEventMonitor: ->
    @monitorEvents()
    @eventMonitor = forever.start '',
      command: "#{projectRoot}\\bin\\WEM.exe"
      silent: true
    @eventMonitor.on 'start', =>
      emit 'eventMonitorStarted', @eventMonitor, "Monitoring system events"
      process.on 'exit', => @eventMonitor.stop()
    @eventMonitor.on 'exit:code', (code) ->
      warning 'eventMonitorStopped', code
      , "Event monitor stopped with code: #{code}"
      # @eventMonitor.restart()

  monitorEvents: () ->
    dgram = require 'dgram'
    server = dgram.createSocket 'udp4'
    server.on 'error', (err) ->
      error 'eventMonitoringError', err, err.message
    server.on 'message', (message) =>
      console.log message
      @systemEventHandler message
    server.on 'listening', ->
      console.log "Listening for system events"
    server.bind 31337, '127.0.0.255'

  systemEventHandler: (message) ->
    try
      {title, path} = JSON.parse message
      path = path.split '\\'
      name = _.last path
      Actions.setCurrentApplication {name, path, title}
    catch
      error 'systemEventHandler', message, "Unable to parse system event"

  executeChain: (phrase) ->
    emit 'chainShouldExecute', phrase

  listenAsSlave: ->
    socketServer = net.createServer (socket) =>
      notify 'masterConnected', null, "Master connected!"
      socket.on 'data', @slaveDataHandler.bind(@)
      socket.on 'end', (socket) ->
        notify 'masterDisconnected', null, "Master disconnected..."

    socketServer.listen Settings.core.slaveModePort, ->
      notify 'slaveListening', {port: Settings.core.slaveModePort},
      "Awaiting connection from master on port #{Settings.core.slaveModePort}"

  slaveDataHandler: (phrase) ->
    phrase = phrase.toString()
    log 'slaveCommandReceived', phrase, "Master said: #{phrase}"
    @executeChain(phrase)
