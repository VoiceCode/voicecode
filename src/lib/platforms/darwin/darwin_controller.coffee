net = require 'net'
fs = require 'fs'

class DarwinController
  instance = null
  constructor: ->
    return instance if instance?
    instance = @

    @loadFrameworks()
    @setDragonInfo()

    @listeningOnMainSocket = true

    @historyGrowl = []
    @historyDragon = []
    @historyStatusWindow = []

    @methodCallTimes = {}

    Events.once 'startupFlowComplete', =>
      @listenOnSocket "/tmp/voicecode_events.sock", @systemEventHandler
      if Settings.slaveMode
        @listenAsSlave()
      else
        @listen()

  loadFrameworks: ->
    $.framework 'Foundation'
    $.framework 'Quartz'
    $.framework 'AppKit'

  applicationChanged: ({event, bundleId, name}) ->
    Actions.setCurrentApplication {name, bundleId}

    if Commands.monitoringMouseToCancelSpacing
      Commands.lastCommandOfPreviousPhrase = null

    if name in Settings.dragonIncompatibleApplications
      log 'mainSocketListening', false,  "Disabling main command socket for compatibility with: #{name}: #{bundleId}"
      @listeningOnMainSocket = false
    else unless @listeningOnMainSocket
      setTimeout =>
        @listeningOnMainSocket = true
        log 'mainSocketListening', true, "Re-enabling main command socket"
      , Settings.dragonIncompatibleApplicationDelay or 5000

  mouseHandler: (event) ->
    if Commands.monitoringMouseToCancelSpacing
      log 'autoSpacing', false, "Canceling auto spacing"
      Commands.lastCommandOfPreviousPhrase = null

  listen: ->
    global.slaveController = new SlaveController()
    slaveController.connect()

    @listenOnSocket "/tmp/voicecode.sock", @dragonHandler
    @listenOnSocket "/tmp/voicecode2.sock", @growlHandler

  listenOnSocket: (socketPath, callback) ->
    fs.stat socketPath, (error) =>
      unless error
        fs.unlinkSync socketPath
      unixServer = net.createServer (connection) =>
        connection.on 'data', callback.bind(@)
      unixServer.listen socketPath

  systemEventHandler: (buffer) ->
    event = JSON.parse buffer.toString('utf8')
    debug event
    switch event.event
      when 'applicationChanged'
        @applicationChanged event
      when 'leftClick'
        @mouseHandler event
      when 'recognizedText'
        @statusWindowTextHandler event

  normalizePhraseComparison: (phrase) ->
    if ParserController.isInitialized()
      JSON.stringify ParserController.parse(phrase.toLowerCase() + " ")
    else
      error 'chainMissingParser', null, "The parser is not initialized -
      probably a problem with the license code, email, or internet connection"
      null
      # phrase.toLowerCase()

  dragonHandler: (data) ->
    phrase = data.toString('utf8').replace("\n", "")
    debug 'dragonPhrase', phrase
    normalized = @normalizePhraseComparison(phrase)

    oldGrowl = @historyGrowl.indexOf normalized
    oldStatusWindow = @historyStatusWindow.indexOf normalized
    proceed = true

    if oldGrowl != -1
      #ignore
      @historyGrowl.splice oldGrowl, 1
      proceed = false

    if oldStatusWindow != -1
      #ignore
      @historyStatusWindow.splice oldStatusWindow, 1
      proceed = false

    if proceed
      @historyDragon.push normalized
      if slaveController.isActive()
        slaveController.process phrase
      else
        @executeChain(phrase)

    @historyDragon.splice(10) # don't accrue too much history

  growlHandler: (data) ->
    phrase = data.toString('utf8').replace("\n", "")
    debug 'growlPhrase', phrase
    normalized = @normalizePhraseComparison(phrase)

    oldDragon = @historyDragon.indexOf normalized
    oldStatusWindow = @historyStatusWindow.indexOf normalized
    proceed = true

    if oldDragon != -1
      #ignore
      @historyDragon.splice oldDragon, 1
      proceed = false

    if oldStatusWindow != -1
      #ignore
      @historyStatusWindow.splice oldStatusWindow, 1
      proceed = false

    if proceed
      @historyGrowl.push normalized

      if slaveController.isActive()
        slaveController.process phrase
      else
        @executeChain(phrase)

    @historyGrowl.splice(10) # don't accrue too much history

  statusWindowTextHandler: (event) ->
    lastCalled = @methodCallTimes.statusWindowTextHandler
    if (not lastCalled?) or (lastCalled? and (Date.now() - lastCalled) > 800)
      @methodCallTimes.statusWindowTextHandler = Date.now()
      phrase = event.phrase
      # sometimes it soundssometimes it sends empty commands
      return unless phrase?.length
      debug 'statusWindowPhrase', phrase
      normalized = @normalizePhraseComparison(phrase)

      oldDragon = @historyDragon.indexOf normalized
      oldGrowl = @historyGrowl.indexOf normalized
      proceed = true
      if oldDragon != -1
        #ignore
        @historyDragon.splice oldDragon, 1
        proceed = false

      if oldGrowl != -1
        #ignore
        @historyGrowl.splice oldGrowl, 1
        proceed = false

      if proceed
        @historyStatusWindow.push normalized

        if slaveController.isActive()
          slaveController.process phrase
        else
          @executeChain(phrase)

      @historyStatusWindow.splice(10) # don't accrue too much history
    else
      # skip

  executeChain: (phrase) ->
    Fiber(->
      new Chain(phrase).execute()
    ).run()

  setDragonInfo: ->
    Settings.dragonVersion = SystemInfo.applicationMajorVersionFromBundle('com.dragon.dictate')
    switch Settings.dragonVersion
      when 5
        Settings.dragonApplicationName =
          Settings.localeSettings[Settings.locale].dragonApplicationName or "Dragon"
      else
        Settings.dragonApplicationName =
          Settings.localeSettings[Settings.locale].dragonApplicationName or "Dragon Dictate"
    Settings.applications.dragon = Settings.dragonApplicationName

  listenAsSlave: ->
    socketServer = net.createServer (socket) =>
      notify 'masterConnected', null, "Master connected!"
      socket.on 'data', @slaveDataHandler.bind(@)
      socket.on 'end', (socket) ->
        notify 'masterDisconnected', null, "Master disconnected..."

    socketServer.listen Settings.slaveModePort, ->
      log null, null, "Awaiting connection from master on port #{Settings.slaveModePort}"

  slaveDataHandler: (phrase) ->
    log 'slaveCommandReceived', phrase, "Master said: #{phrase}"
    @executeChain(phrase)

module.exports = new DarwinController
