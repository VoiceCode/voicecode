net = require 'net'
fs = require 'fs'
forever = require 'forever'

module.exports = new class MainController
  constructor: ->
    @loadFrameworks()

    Events.once 'startupComplete', =>
      if developmentMode
        @listenOnSocket "/tmp/voicecode_events_dev.sock", @systemEventHandler
      else
        @startEventMonitor()

      if Settings.core.slaveMode
        @listenAsSlave()
      else
        @listenOnSocket "/tmp/voicecode_devices.sock", @deviceHandler


  loadFrameworks: ->
    $.framework 'Foundation'
    $.framework 'Quartz'
    $.framework 'AppKit'

  startEventMonitor: ->
    @listenOnSocket "/tmp/voicecode_events.sock", @systemEventHandler

    @eventMonitor = forever.start '',
      command: "#{projectRoot}/bin/DarwinEventMonitor.app/Contents/MacOS/DarwinEventMonitor"
      silent: true
    @eventMonitor.on 'start', =>
      emit 'eventMonitorStarted', @eventMonitor, "Monitoring system events"
      process.on 'exit', => @eventMonitor.stop()
    @eventMonitor.on 'exit:code', (code) ->
      warning 'eventMonitorStopped', code
      , "Event monitor stopped with code: #{code}"
      # @eventMonitor.restart()

  applicationChanged: ({event, bundleId, name}) ->
    Actions.setCurrentApplication {name, bundleId}

  mouseLeftClickHandler: (event) ->
    emit 'mouse.leftClick', event

  keyUpHandler: (event) ->
    emit 'keyboard.keyUp', event

  darwinEventHandler: (event) ->
    emit event.event, event

  listenOnSocket: (socketPath, callback) ->
    fs.stat socketPath, (error) =>
      unless error
        fs.unlinkSync socketPath
      unixServer = net.createServer (connection) =>
        connection.on 'data', callback.bind(@)
      unixServer.listen socketPath

  systemEventHandler: (buffer) ->
    try
      event = JSON.parse buffer.toString('utf8')
      switch event.event
        when 'applicationChanged'
          @applicationChanged event
        when 'leftClick'
          @mouseLeftClickHandler event
        when 'keyUp'
          @keyUpHandler event
        else
          @darwinEventHandler event
    catch
      error 'systemEventHandler', buffer.toString('utf8'), 'Unable to parse JSON'

  deviceHandler: (data) ->
    phrase = data.toString('utf8').replace("\n", "")
    debug 'devicePhrase', phrase
    @executeChain(phrase)

  executeChain: (phrase, chain) ->
    if chain?
      emit 'commandsShouldExecute', chain
    else
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
    if phrase[0] is '{'
      try
        chain = JSON.parse phrase
      catch
        return error 'slaveCommandError', phrase, 'Unable to parse JSON'
    @executeChain phrase, chain
