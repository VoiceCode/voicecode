if process.platform is "darwin"
  @$ = Meteor.npmRequire('nodobjc')
  # uvcf = Meteor.npmRequire('uvcf')
  $.framework 'Foundation'
  $.framework 'Quartz'
  $.framework 'AppKit'
  # $.framework 'PFAssistive'

  # [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver:self selector:@selector(foremostAppActivated:) name:NSWorkspaceDidActivateApplicationNotification object:nil];

  w = $.NSWorkspace('sharedWorkspace')
  n = w('notificationCenter')
  q = $.NSOperationQueue('mainQueue')

  app = $.NSApplication('sharedApplication')

  # s = $.NSSelectorFromString($())

  # callback = ->
  #   console.log "yoyoyoyo"

  # wrapped = $(callback, $.NSObject)

  # obj = $.NSObject('alloc')('init')


  AppDelegate = $.NSObject.extend('AppDelegate')

  listeningOnMainSocket = true
  currentApplicationIsIncompatible = false

  AppDelegate.addMethod 'applicationChanged:', 'v@:@', (self, _cmd, notification) ->

    current = notification('object')('frontmostApplication')('localizedName').toString()
    Actions.setCurrentApplication current

    if Commands.monitoringMouseToCancelSpacing
      console.log "canceling auto spacing"
      Commands.lastCommandOfPreviousPhrase = null

    if current in Settings.dragonIncompatibleApplications
      console.log "disabling main command socket for compatibility with: #{current}"
      listeningOnMainSocket = false
      currentApplicationIsIncompatible = true
    else       
      if currentApplicationIsIncompatible is true
        Meteor.setTimeout ->
          listeningOnMainSocket = true
          currentApplicationIsIncompatible = false
          console.log "re-enabling main command socket"
        , Settings.dragonIncompatibleApplicationDelay or 5000
      else
        # just a regular application switch. We disable the main socket because right after an application switch
        # dragon sometimes does weird things and the growl notification comes before the primary command - 
        # causing double execution
        listeningOnMainSocket = false
        Meteor.setTimeout ->
          listeningOnMainSocket = true
          currentApplicationIsIncompatible = false
        ,  6000


  AppDelegate.addMethod 'windowChanged:', 'v@:@', (self, _cmd, notification) ->
    console.log notification('object')

  # AppDelegate.addMethod 'applicationDidFinishLaunching:', 'v@:@', (self, _cmd, notification) ->
  #   console.log('got applicationDidFinishLauching')
  #   console.log(notification)

  AppDelegate.addMethod 'applicationWillTerminate:', 'v@:@', (self, _cmd, notification) ->
    console.log('got applicationWillTerminate')
    console.log(notification)

  # AppDelegate.addMethod 'textRecognized:', 'v@:@', (self, _cmd, notification) ->
  #   console.log('got textRecognized')
  #   console.log(notification)

  # n('addObserverForName', $.NSWorkspaceDidActivateApplicationNotification, 'object', AppDelegate, 'queue', q, 'usingBlock', wrapped)


  AppDelegate.register()

  delegate = AppDelegate('alloc')('init')
  app('setDelegate', delegate)

  n('addObserver', delegate, 'selector', 'applicationChanged:', 'name', $('NSWorkspaceDidActivateApplicationNotification'), 'object', null )
  n('addObserver', delegate, 'selector', 'windowChanged:', 'name', $('NSWindowDidBecomeMainNotification'), 'object', null )

  mouseHandler = (self, event) ->
    # console.log "mousedown", event
    if Commands.monitoringMouseToCancelSpacing
      console.log "canceling auto spacing"
      Commands.lastCommandOfPreviousPhrase = null
  
  mouseHandlerPointer = $(mouseHandler, ['v', ['@', '@']])

  $.NSEvent 'addGlobalMonitorForEventsMatchingMask', $.NSLeftMouseDownMask, 'handler', mouseHandlerPointer

  # app('activateIgnoringOtherApps', true)
  # shared('run')
  # $.NSRunLoop('mainRunLoop')('run')

  # console.log "i got here"

  # Setup the recommended NSAutoreleasePool instance
  # pool = $.NSAutoreleasePool('alloc')('init')
  # NSStrings and JavaScript Strings are distinct objects, you must create an
  # NSString from a JS String when an Objective-C class method requires one.
  # string = $.NSString('stringWithUTF8String', 'Hello Objective-C World!')

  # class @DragonObserver
  #   constructor: ->
  #     @location = $("/Applications/Dragon Dictate.app")
  #     @dragon = $.PFApplicationUIElement("alloc")("initWithPath", @location, "delegate", null)
  #   findStatusWindow: ->
  #     children = @dragon('AXChildren')
  #     size = children('count')
  #     for i in [0..(size - 1)]
  #       item = children('objectAtIndex', i)
  #       # console.log item: item
  #       if item('AXTitle')?.toString() is "Dictate Status Window"
  #         return item
  #   findRecognizedTextElement: ->
  #     statusWindow = @findStatusWindow()
  #     if statusWindow?
  #       children = statusWindow('AXChildren')
  #       size = children('count')
  #       for i in [0..(size - 1)]
  #         item = children('objectAtIndex', i)
  #         console.log item: item
  #         if item('AXDescription')?.toString() is "Recognized speech"
  #           return item
  #   getCurrentTextValue: ->
  #     textElement = @findRecognizedTextElement()
  #     if textElement?
  #       textElement('AXValue')
  #   getObserver: ->
  #     $.PFObserver("observerWithPath", @location, 'notificationDelegate', delegate, 'callbackSelector', 'textRecognized:')
  #   observe: ->
  #     observer = @getObserver()
  #     element = @findRecognizedTextElement()
  #     observer('registerForNotification', $.kAXValueChangedNotification, 'fromElement', element, 'contextInfo', $.NSDictionary('dictionary'))



  # @dragonObserver = new DragonObserver()
  # dragonObserver.observe()


  # Print out the contents (toString() ends up calling [string description])
  mask = $.NSAnyEventMask.toString()
  mode = $('kCFRunLoopDefaultMode')

  tock = ->
    ev = undefined
    while ev = app('nextEventMatchingMask', mask, 'untilDate', null, 'inMode', mode, 'dequeue', 1)
      app 'sendEvent', ev
    # app 'updateWindows'
    if true
      Meteor.setTimeout tock, 100
    # return

  app 'finishLaunching'
  # userInfo = $.NSDictionary('dictionaryWithObject', $(1), 'forKey', $('NSApplicationLaunchIsDefaultLaunchKey'))
  # notifCenter = $.NSNotificationCenter('defaultCenter')
  # notifCenter 'postNotificationName', $.NSApplicationDidFinishLaunchingNotification, 'object', app, 'userInfo', userInfo
  @Actions = new Platforms.osx.actions()

  tock()

  # Meteor.setTimeout ->
  #   scrollUp()
  # , 2000


  # pool 'drain'

  # eventHandler = $.NSEvent('addGlobalMonitorForEventsMatchingMask', $.NSMouseMovedMask, 'handler', )

  # eventHandler = [NSEvent addGlobalMonitorForEventsMatchingMask:NSMouseMovedMask handler:^(NSEvent * mouseEvent) {
  #   NSLog(@"Mouse moved: %@", NSStringFromPoint([mouseEvent locationInWindow]));
  # }];

  # $.framework('Cocoa')

  # app = $.NSApplication('sharedApplication')


  # AppDelegate = $.NSObject.extend('AppDelegate')

  # AppDelegate.addMethod 'applicationDidFinishLaunching:', 'v@:@', (self, _cmd, notif) ->
  #   systemStatusBar = $.NSStatusBar('systemStatusBar')
  #   statusMenu = systemStatusBar('statusItemWithLength', $.NSVariableStatusItemLength)
  #   statusMenu('retain')
  #   title = $.NSString('stringWithUTF8String', "Hello World")
  #   statusMenu('setTitle', title)

  # AppDelegate.register()

  # delegate = AppDelegate('alloc')('init')
  # app('setDelegate', delegate)

  # app('activateIgnoringOtherApps', true)
  # app('run')

  # pool('release')


  # server = http.createServer()
  # server.listen '/var/tmp/voicecode.sock'

  # server.on "request", ->
  #   console.log "booom"
  #   console.log


  net = Meteor.npmRequire("net")
  fs = Meteor.npmRequire("fs")
  socketPath = "/tmp/voicecode.sock"
  socketPath2 = "/tmp/voicecode2.sock"

  serverHandler = Meteor.bindEnvironment (localSerialConnection) ->
    localSerialConnection.on 'data', commandHandler

  serverHandler2 = Meteor.bindEnvironment (localSerialConnection) ->
    localSerialConnection.on 'data', commandHandler2

  previousPhrase = null
  previousPhraseGrowl = null
  previousPhraseTime = Date.now()
  previousPhraseGrowlTime = Date.now()
  threshold = 400
  threshold2 = 400


  normalizePhraseComparison = (phrase) ->
    phrase.toLowerCase().replace(/[\W]+/g, "")

  commandHandler = Meteor.bindEnvironment (data) ->
    if listeningOnMainSocket
      phrase = data.toString('utf8').replace("\n", "")
      normal = normalizePhraseComparison(phrase)
      # console.log
      #   handler: 1
      #   difference: (Date.now() - previousPhraseTime)
      #   differenceGrowl: (Date.now() - previousPhraseGrowlTime)
      #   phrase: phrase
      #   previous: previousPhrase
      #   previousGrowl: previousPhraseGrowl
      #   normalized: normal
      previousPhraseTime = Date.now()
      if normal is previousPhraseGrowl # and normal isnt previousPhrase and (Date.now() - previousPhraseGrowlTime) < 700
        # probably a duplicate
        previousPhrase = normalizePhraseComparison(phrase)
        previousPhraseGrowl = null
      else
        previousPhrase = normalizePhraseComparison(phrase)
        previousPhraseGrowl = null
        chain = new Commands.Chain(phrase + " ")
        results = chain.execute(true)

  # comes from growl
  commandHandler2 = Meteor.bindEnvironment (data) ->
    phrase = data.toString('utf8').replace("\n", "")
    # console.log
    #   handler: 2
    #   differenceGrowl: (Date.now() - previousPhraseGrowlTime)
    #   difference: (Date.now() - previousPhraseTime)
    #   phrase: phrase
    #   previous: previousPhrase
    #   previousGrowl: previousPhraseGrowl
    #   normalized: normalizePhraseComparison(phrase)
    normalized = normalizePhraseComparison(phrase)
    previousPhraseGrowl = normalized
    previousPhraseGrowlTime = Date.now()
    if normalized != previousPhrase # and ((normalized != previousPhraseGrowl) or ((Date.now() - previousPhraseGrowlTime) > threshold2))
      chain = new Commands.Chain(phrase + " ")
      results = chain.execute(true)
    else
      previousPhraseGrowl = null

  fs.stat socketPath, (err) ->
    if !err
      fs.unlinkSync socketPath
    unixServer = net.createServer serverHandler
    unixServer.listen socketPath

  fs.stat socketPath2, (err) ->
    if !err
      fs.unlinkSync socketPath2
    unixServer2 = net.createServer serverHandler2
    unixServer2.listen socketPath2

  # client = net.createConnection("/tmp/voicecode")

  # client.on "connect", ->
  #   console.log "connected"

  # client.on "data", (data) ->
  #   console.log "dataaaaaa"
  #   console.log data

else if process.platform is "win32"
  @Actions = new Platforms.windows.actions()

else if process.platform is "linux"
  @Actions = new Platforms.linux.actions()

# Determine Dragon application name
switch Settings.dragonVersion
  when 5
    Settings.dragonApplicationName = Settings.localeSettings[Settings.locale].dragonApplicationName or "Dragon"
  else
    Settings.dragonApplicationName = Settings.localeSettings[Settings.locale].dragonApplicationName or "Dragon Dictate"
Settings.applications.dragon = Settings.dragonApplicationName
