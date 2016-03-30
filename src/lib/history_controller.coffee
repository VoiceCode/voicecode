class HistoryController
  previousContext = null
  amnesia = false
  activeChains = 0

  constructor: ->
    @history = {}
    maintenanceInterval = setInterval @doMaintenance.bind(@), 900000 # 15 minutes
    Events.on 'chainWillExecute', =>
      activeChains++
      if activeChains is 1
        @startNewChain()
    Events.on 'chainDidExecute', =>
      activeChains--
      @history[previousContext][0] = _.compact @history[previousContext][0]
      if _.isEmpty @history[previousContext][0]
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
          @history[currentContext][0].unshift _.pick link, ['command', 'arguments']
    Events.on ['microphoneSleep', 'microphoneOff'], ->
      windowController.get('microphoneState').show()
    Events.on 'microphoneWakeUp', ->
      windowController.get('microphoneState').hide()

    @createWindow()

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

  doMaintenance: ->
    _.all @history, (v, k) => Array::splice.call @history[k], 10
    # dump to disk?

  getCurrentContext: ->
    Actions.currentApplication().name

  getChainLength: (offset = 0) ->
    try
      return @history[@getCurrentContext()][offset].length
    catch
      return 0

  createWindow: ->
    screen = require 'screen'
    screenSize = screen.getPrimaryDisplay().workAreaSize
    microphoneStateWindow = windowController.new 'microphoneState',
      x: screenSize.width - 90
      y: screenSize.height - 90
      width: 90
      height: 90
      'always-on-top': true
      type: "notification"
      transparent: true
      frame: false
      toolbar: false
      resizable: false
      show: false
    microphoneStateWindow.loadUrl("file://#{projectRoot}/dist/frontend/microphone_indicator.html")

module.exports = new HistoryController
