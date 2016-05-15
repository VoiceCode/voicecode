class HistoryController
  previousContext = null
  amnesia = false
  activeChains = 0

  constructor: ->
    _this = @
    @history = {}
    # @history = new Proxy {},
    #   set: (target, property, value) ->
    #     Reflect.set target, property, new Proxy value,
    #       set: (target, property, value) ->
    #         debug property, value
    #         if property is '0' and not _.isEmpty value
    #           emit 'historicChainCreated',
    #             commands: value
    #             context: _this.getCurrentContext()
    #         Reflect.set target, property, value
    maintenanceInterval = setInterval @doMaintenance.bind(@), 900000 # 15 minutes
    Events.on 'chainWillExecute', =>
      activeChains++
      if activeChains is 1
        @startNewChain()
    Events.on ['chainDidExecute', 'chainFailedExecute'], =>
      activeChains--
      # @history[previousContext][0] = _.compact @history[previousContext][0]
      if _.isEmpty _.compact @history[previousContext][0]
        @forgetChain 0
    Events.on 'commandDidExecute', ({link}) =>
      command = Commands.get link.command
      unless command.bypassHistory?(link.context)
        currentContext = @getCurrentContext()
        if previousContext isnt currentContext
          @startNewChain currentContext
        # coffee script is stupid, why make the extra 'arg' variable?
        delete arguments[0].link.context
        unless amnesia
          command =  _.pick link
          , ['command', 'arguments']
          @history[currentContext][0].unshift command
          emit 'historicChainLinkCreated',
            command: command
            context: currentContext


    @createHistoryWindow()
    # Events.on ['microphoneSleep', 'microphoneOff'], ->
    #   windowController.get('microphoneState').show()
    # Events.on 'microphoneWakeUp', ->
    #   windowController.get('microphoneState').hide()

    # @createWindow()

  forgetChain: (offset) ->
    delete @history[previousContext][offset]
    @history[previousContext] = _.values _.compact @history[previousContext]

  getCommands: (chainOffset = 0, offset = 0, count = 1, context = null) ->
    context ?= @getCurrentContext()
    if chainOffset is 0 and @getChainLength() is 0
      chainOffset++
    try
      return @history[context][chainOffset][offset...count]
    catch
      return []

  getChain: (offset = 0, context = null) ->
    context ?= @getCurrentContext()
    chain = @history[context][offset]
    chain = _.cloneDeep @history[context][offset]
    chain.reverse()

  hasAmnesia: (yesNo) ->
    amnesia = yesNo

  startNewChain: (context = null) ->
    context ?= @getCurrentContext()
    @history[context] ?= []
    @history[context].unshift []
    previousContext = context
    emit 'historicChainCreated', {context}

  doMaintenance: ->
    _.each @history, (v, k) => Array::splice.call @history[k], 10
    # dump to disk?

  getCurrentContext: ->
    Actions.currentApplication().name

  getChainLength: (offset = 0) ->
    try
      return @history[@getCurrentContext()][offset].length
    catch
      return 0

  cancelAutoSpacing: ->
    context = @getCurrentContext()
    previousChain = @history[context]?[0]
    if previousChain?.length
      command = previousChain[0]
      if command?
        command.cancelAutoSpacing = true

  createHistoryWindow: ->
    historyWindow = windowController.new 'history',
      x: 0
      y: 0
      width: 350
      height: 600
      # width: 900
      # height: 1200
      hasShadow: false
      # type: "desktop"
      alwaysOnTop: true
      transparent: true
      frame: false
      toolbar: false
      resizable: false
      show: true
    historyWindow.once 'show', ->
      historyWindow.hide()
      # historyWindow.openDevTools()
    historyWindow.loadURL("file://#{projectRoot}/src/frontend/history.html")

  createMicrophoneStateWindow: ->
    screen = require 'screen'
    screenSize = screen.getPrimaryDisplay().workAreaSize
    microphoneStateWindow = windowController.new 'microphoneState',
      x: screenSize.width - 90
      y: screenSize.height - 90
      width: 90
      height: 90
      alwaysOnTop: true
      type: "notification"
      transparent: true
      frame: false
      toolbar: false
      resizable: false
      show: false
    microphoneStateWindow.loadURL("file://#{projectRoot}/dist/frontend/microphone_indicator.html")

module.exports = new HistoryController
