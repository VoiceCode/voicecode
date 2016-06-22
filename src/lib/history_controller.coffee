class HistoryController
  constructor: ->
    _this = @
    @history = {}
    @context = null
    @amnesia = false
    @activeChains = 0
    @maintenanceInterval = setInterval @doMaintenance.bind(@), 300000 # 5 minutes
    Events.on 'chainWillExecute', =>
      @activeChains++
      previous = @history[@context]
      # console.log 'previous exists: ' + previous?
      # console.log 'not empty: ' + _.isEmpty previous[0]
      if @activeChains is 1 and not (previous? and _.isEmpty previous[0])
        @startNewChain()
    Events.on ['chainFailedExecute', 'chainDidExecute'], =>
      @activeChains--

    Events.on 'commandDidExecute', ({link}) =>
      console.log 'active chains: ' + @activeChains
      command = Commands.get link.command
      unless command.bypassHistory?(link.context)
        delete arguments[0].link.context
        unless @amnesia
          command =  _.pick link
          , ['command', 'arguments']
          @history[@context][0].unshift command
          emit 'historicChainLinkCreated',
            command: command
            context: @context


    @createHistoryWindow()
    # Events.on ['microphoneSleep', 'microphoneOff'], ->
    #   windowController.get('microphoneState').show()
    # Events.on 'microphoneWakeUp', ->
    #   windowController.get('microphoneState').hide()

    # @createWindow()

  forgetChain: (offset) ->
    delete @history[@context][offset]
    @history[@context] = _.values _.compact @history[@context]

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
    chain.reverse() # TODO: do this in between chains for performance?

  hasAmnesia: (yesNo) ->
    @amnesia = yesNo

  startNewChain: (context = null) ->
    context ?= @getCurrentContext true
    @history[context] ?= []
    @history[context].unshift []
    emit 'historicChainCreated', {context}

  doMaintenance: ->
    _.each @history, (v, k) => Array::splice.call @history[k], 10
    # dump to disk?

  getCurrentContext: (update = false)->
    if update
      @context = Actions.currentApplication().name
    @context

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
