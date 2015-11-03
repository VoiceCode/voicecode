class DarwinController
  instance = null
  constructor: ->
    return instance if instance?
    instance = @

    @loadFrameworks()
    # @initialize()
    @setDragonInfo()

    @listeningOnMainSocket = true
    @historyGrowl = []
    @historyDragon = []

    # @tock()

    if Settings.slaveMode
      @listenAsSlave()
    else
      @listen()

  tock: ->
    event = undefined
    while event = @app('nextEventMatchingMask', $.NSAnyEventMask.toString(),
    'untilDate', null, 'inMode', $('kCFRunLoopDefaultMode'), 'dequeue', 1)
      @app 'sendEvent', event
    # app 'updateWindows'
    setTimeout @tock.bind(@), 100

  loadFrameworks: ->
    $.framework 'Foundation'
    $.framework 'Quartz'
    $.framework 'AppKit'
    # TODO: de-globalize
    global.net = require 'net'
    global.fs = require 'fs'

  initialize: ->
    @sharedWorkspace = $.NSWorkspace('sharedWorkspace')
    @notificationCenter = @sharedWorkspace('notificationCenter')
    @mainQueue = $.NSOperationQueue('mainQueue')
    @app = $.NSApplication('sharedApplication')

    @delegate = $.NSObject.extend('AppDelegate')
    @delegate.addMethod 'applicationChanged:', 'v@:@', @applicationChanged
    @delegate.register()

    @delegateInstance = @delegate('alloc')('init')
    @app 'setDelegate', @delegateInstance

    @notificationCenter('addObserver', @delegateInstance, 'selector',
    'applicationChanged:', 'name', $('NSWorkspaceDidActivateApplicationNotification'), 'object', null )
    @notificationCenter('addObserver', @delegateInstance, 'selector',
    'windowChanged:', 'name', $('NSWindowDidBecomeMainNotification'), 'object', null )

    $.NSEvent 'addGlobalMonitorForEventsMatchingMask', $.NSLeftMouseDownMask, 'handler', $(@mouseHandler, ['v', ['@', '@']])

    # @app 'finishLaunching'

  applicationChanged: (self, _cmd, notification) ->
    current = notification('object')('frontmostApplication')('localizedName').toString()
    Actions.setCurrentApplication current

    if Commands.monitoringMouseToCancelSpacing
      Commands.lastCommandOfPreviousPhrase = null

    if current in Settings.dragonIncompatibleApplications
      console.log "disabling main command socket for compatibility with: #{current}"
      @listeningOnMainSocket = false
    else unless @listeningOnMainSocket
      setTimeout =>
        @listeningOnMainSocket = true
        console.log "re-enabling main command socket"
      , Settings.dragonIncompatibleApplicationDelay or 5000

  mouseHandler: (self, event) ->
    # console.log "mousedown", event
    if Commands.monitoringMouseToCancelSpacing
      console.log "canceling auto spacing"
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

  normalizePhraseComparison: (phrase) ->
    if typeof Parser is 'undefined'
      error null, null, "The parser is not initialized -
      probably a problem with the license code, email, or internet connection"
      null
    else
      JSON.stringify Parser.parse(phrase.toLowerCase() + " ")

  dragonHandler: (data) ->
    phrase = data.toString('utf8').replace("\n", "")
    log 'dragonPhrase', phrase, "Dragon: '#{phrase}'"
    normalized = @normalizePhraseComparison(phrase)

    old = @historyGrowl.indexOf normalized
    if old != -1
      #ignore
      @historyGrowl.splice old, 1
    else
      if @listeningOnMainSocket
        @historyDragon.push normalized
        if slaveController.isActive()
          slaveController.process phrase
        else
          chain = new Chain(phrase + " ")
          results = chain.execute(true)


  growlHandler: (data) ->
    phrase = data.toString('utf8').replace("\n", "")
    log 'growlPhrase', phrase, "Growl: '#{phrase}'"
    normalized = @normalizePhraseComparison(phrase)

    old = @historyDragon.indexOf normalized
    if old != -1
      #ignore
      @historyDragon.splice old, 1
    else
      if @listeningOnMainSocket
        @historyGrowl.push normalized

      if slaveController.isActive()
        slaveController.process phrase
      else
        chain = new Chain(phrase + " ")
        results = chain.execute(true)

  setDragonInfo: ->
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
    Fiber(->
      chain = new Chain(phrase + " ")
      results = chain.execute(true)
    ).run()

module.exports = new DarwinController
