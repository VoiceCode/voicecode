class ChromeBrowserPipe
  # singleton
  instance = null
  constructor: (@browserController) ->
    return instance if instance?
    @_debug = true
    ws = require 'ws'
    @_isConnected = false
    @webSocketServer = new ws.Server(port: 4445)
    @webSocketServer.on 'connection', (socket) =>
      @_isConnected = true
      @webSocket = socket
      @browserController.emit 'browserConnected'
      @webSocket.on 'message', (message) =>
        @receive message
      @webSocket.on 'close', =>
        @close
    instance = @

  isConnected: ->
    @_isConnected

  close: ->
    @_isConnected = false
    @browserController.emit 'browserDisconnected'

  send: (payload) ->
    return unless @isConnected()
    @webSocket.send JSON.stringify payload

  receive: (payload) ->
    {type, parameters} = JSON.parse payload
    switch type
      when 'heartbeat'
        return
      when 'domEvent'
        eventName = parameters.event.charAt(0).toUpperCase() + parameters.event.slice(1)
        console.error "Emitting domEvent#{eventName}", parameters.tabId, parameters.frameId if @_debug
        @browserController.emit "domEvent" + eventName, parameters
      else
        if parameters.callbackName?
          console.error "Emitting #{parameters.callbackName}", parameters.callbackArguments.tabId, parameters.callbackArguments.frameId if @_debug
          @browserController.emit parameters.callbackName, parameters.callbackArguments
        else
          console.error "Don't know how to handle '#{type}'", parameters

###
    event list:
      browserConnected
      browserDisconnected
      setState
      browserError
      eventTabsOnCreated
      eventTabsOnUpdated
      eventTabsOnActivated
      eventTabsOnRemoved
      eventWindowsOnCreated
      eventWindowsOnRemoved
      eventWindowsOnFocusChanged
      eventBookmarksOnCreated
      eventBookmarksOnRemoved
      eventBookmarksOnChanged
###
class ChromeBrowserController extends require('events').EventEmitter
  # singleton
  instance = null
  constructor: ->
    return instance if instance?
    @_debug = true
    @state = {}
    @subscribedToChromeApiEvents = false
    @subscribedToDomEvents = false
    @on 'browserConnected', @eventBrowserConnected
    @on 'browserDisconnected', @eventBrowserDisconnected
    @on 'browserError', @browserError
    @browserPipe = new ChromeBrowserPipe @
    # @freeTextBrowsing = new FreeTextBrowsing @
    instance = @

  send: (payload) ->
    return if not @isConnected()
    @browserPipe.send payload

  isConnected: ->
    @browserPipe.isConnected()

  eventBrowserDisconnected: ->
    # @browserPipe = null

  eventBrowserConnected: ->
    log null, null, "Got browser connection!" if @_debug
    @subscribeToChromeApiEvents()
    @subscribeToDomEvents()
    @updateState()

  subscribeToDomEvents: ->
    @state.inputFocused = false
    unless @subscribedToDomEvents
      @on 'domEventBlur', @domEventBlur
      @on 'domEventFocus', @domEventFocus
      @subscribedToDomEvents = true

  domEventFocus: ({event, target, frameId, tabId, windowId}) ->
    return unless frameId is 0 # TODO: handle?
    # when the windows focused doesn't mean that
    # an input field is focused
    return if target is 'window'

    currentWindow = @getFocusedWindow()
    activeTab = @getActiveTab currentWindow
    return if currentWindow.id isnt windowId
    return if activeTab.id isnt tabId
    debug 'Input focused' if @_debug
    @state.inputFocused = true

  domEventBlur: ({event, target, frameId, tabId, windowId}) ->
    return unless frameId is 0 # TODO: handle?
    currentWindow = @getFocusedWindow()
    console.log '0'
    activeTab = @getActiveTab currentWindow
    console.log '1'
    return if currentWindow.id isnt windowId
    console.log '2'
    return if activeTab.id isnt tabId
    console.log 'Input not focused' if @_debug
    @state.inputFocused = false

  executeScript: (tabId, code) ->
    @send
      request: 'chromeApi'
      parameters:
        namespace: 'tabs'
        method: 'executeScript'
        argumentList: [
          tabId
          {code}
        ]
        callbackName: 'executeScriptCallback'
        callbackArguments: []


  getTabsByUrl: (url, expression = null) ->
    tabs = _.pluck @state.windows, 'tabs'
    tabs = _.flatten tabs, true
    results = _.filter tabs, (tab) ->
      if expression?
        tab.url.match expression
      else
        tab.url.indexOf(url) >= 0
    results

  browserError: (error) ->
    error 'browserPipe', error, 'Got browser error: ' + error

  getFocusedWindow: ->
    return undefined unless @getState()?
    focusedWindow = _.findWhere @state.windows, {focused: true}
    # console.log focusedWindow if @_debug
    focusedWindow

  getActiveTab: (window = null) ->
    unless window?
      window = @getFocusedWindow()
    activeTab = _.findWhere window.tabs, {active: true}
    # console.log activeTab if @_debug
    activeTab

  getUrl: (tab) ->
    url = tab.url
    # console.log url if @_debug
    url

  getCurrentUrl: ->
    focusedWindow = @getFocusedWindow()
    return undefined unless focusedWindow?
    activeTab = @getActiveTab focusedWindow
    return undefined unless activeTab?
    url = @getUrl activeTab
    # console.log url if @_debug
    url

  activateTab: (tabId) ->
    @send
      request: 'chromeApi'
      parameters:
        namespace: 'tabs'
        method: 'update'
        argumentList: [
          tabId
          {active: true}
        ]
        callbackName: 'executeScriptCallback'
        callbackArguments: []

  focusWindow: (windowId) ->
    @send
      request: 'chromeApi'
      parameters:
        namespace: 'windows'
        method: 'update'
        argumentList: [
          windowId
          {focused: true}
        ]
        callbackName: 'executeScriptCallback'
        callbackArguments: []

  getState: ->
    @state ?= {}
    @state

  updateState: ->
    @once 'setState', @setState
    @send
      request: 'chromeApi'
      parameters:
        namespace: 'windows'
        method: 'getAll'
        argumentList: [
          {
            populate: true
          }
        ]
        callbackName: 'setState'
        callbackArguments: [
          'windows'
        ]

  setState: ({windows}) ->
    @state ?= {}
    @state.windows = windows
    console.log "Window state updated" if @_debug
    # console.log("State is: ", windows) if @_debug

  eventTabsOnCreated: ({tab}) ->
    console.log 'Tab created' if @_debug
    @updateState()
  eventTabsOnUpdated: ({tabId, changeInfo, tab}) ->
    console.log 'Tab updated' if @_debug
    console.error changeInfo
    @updateState()
  eventTabsOnActivated: ({tabId, windowId}) ->
    console.log 'Tab activated' if @_debug
    @updateState()
  eventTabsOnRemoved: ({tabId, removeInfo}) ->
    console.log 'Tab removed' if @_debug
    @updateState()
  eventWindowsOnCreated: ({window}) ->
    console.log 'Window created' if @_debug
    @updateState()
  eventWindowsOnRemoved: ({windowId}) ->
    console.log 'Window removed' if @_debug
    @updateState()
  eventWindowsOnFocusChanged: ({windowId}) ->
    console.log 'Window focus changed' if @_debug
    @updateState()

  eventBookmarksOnCreated: ({id, bookmark}) ->
    console.log 'Bookmark created' if @_debug
  eventBookmarksOnRemoved: ({id, removeInfo}) ->
    console.log 'Bookmark removed' if @_debug
  eventBookmarkOnChanged: ({id, changeInfo}) ->
    console.log 'Bookmark changed' if @_debug

  subscribeToChromeApiEvents: ->
    eventsOfInterest =
      'tabs':
        'onCreated': ['tab']
        'onUpdated': ['tabId', 'changeInfo', 'tab']
        'onActivated': ['tabId', 'windowId']
        'onRemoved': ['tabId', 'removeInfo']
      'windows':
        'onCreated': ['window']
        'onRemoved': ['windowId']
        'onFocusChanged': ['windowId']
      # 'bookmarks':
      #   'onCreated': ['id', 'bookmark']
      #   'onRemoved': ['id', 'removeInfo']
      #   'onChanged': ['id', 'changeInfo']
    _.each eventsOfInterest, (events, namespace) =>
      _.each events, (callbackArguments, event) =>
        Namespace = namespace.charAt(0).toUpperCase() + namespace.slice(1)
        Event = event.charAt(0).toUpperCase() + event.slice(1)

        @send
          request: 'eventListener'
          parameters:
            namespace: namespace
            method: event
            callbackName: "event#{Namespace}#{Event}"
            callbackArguments: callbackArguments
        unless @subscribedToChromeApiEvents
          @on "event#{Namespace}#{Event}", (callbackArguments) =>
            @["event#{Namespace}#{Event}"]?.call @, callbackArguments
          log 'browserPipeSubscribed', {namespace: Namespace, event: Event},
          "Subscribed to 'event#{Namespace}#{Event}'"
    @subscribedToChromeApiEvents = true

if Settings.chromeExtension
  module.exports = ChromeBrowserController: new ChromeBrowserController


pack = Packages.get 'chrome'
pack.implement
  'selection:next.word-occurrence': (input, context) ->
    {id} = ChromeBrowserController.getActiveTab()
    return false unless id?
    ChromeBrowserController.send
      request: 'tabMessage'
      parameters:
        tabId: id
        message:
          argumentsObject:
            target: input.value
          namespace: 'SelectionController'
          method: 'select'
          type: 'invokeBound'
  'selection:previous.word-occurrence': (input, context) ->
    {id} = ChromeBrowserController.getActiveTab()
    return false unless id?
    ChromeBrowserController.send
      request: 'tabMessage'
      parameters:
        tabId: id
        message:
          argumentsObject:
            target: input.value
            direction: 'backward'
          namespace: 'SelectionController'
          method: 'select'
          type: 'invokeBound'
  'selection:extend.next.word-occurrence': (input, context) ->
    {id} = ChromeBrowserController.getActiveTab()
    return false unless id?
    ChromeBrowserController.send
      request: 'tabMessage'
      parameters:
        tabId: id
        message:
          argumentsObject:
            target: input.value
            direction: 'forward'
          namespace: 'SelectionController'
          method: 'extend'
          type: 'invokeBound'
  'selection:extend.previous.word-occurrence': (input, context) ->
    {id} = ChromeBrowserController.getActiveTab()
    return false unless id?
    ChromeBrowserController.send
      request: 'tabMessage'
      parameters:
        tabId: id
        message:
          argumentsObject:
            target: input.value
            direction: 'backward'
          namespace: 'SelectionController'
          method: 'extend'
          type: 'invokeBound'

pack.commands
  "browser_pipe:webneck":
    spoken: 'web neck'
    description: ""
    continuous: false
    aliases: []
    tags: ["Google Chrome"]
    action: (input) ->
      urlParser = require 'url'
      state = ChromeBrowserController.getState().windows
      url = ChromeBrowserController.getCurrentUrl()
      return unless url?
      url = urlParser.parse url, true, true
      tabs = _.flatten _.pluck state, 'tabs'
      currentTab = null
      tabs = _.filter tabs, (tab) ->
        comparison = tab.url.indexOf(url.hostname) >= 0
        if tab.active and comparison and _.findWhere(state, {id: tab.windowId}).focused
          currentTab = tab
          return false
        comparison
      return if tabs.length is 0
      # reverse the next 2 in order to go backwards
      nextTab = _.find tabs, (tab) ->
        tab.id > currentTab.id
      if not nextTab?
        nextTab = _.find tabs, (tab) ->
          tab.id < currentTab.id
      # console.log "Switching tab #{currentTab.id}:#{currentTab.windowId} => #{nextTab.id}:#{nextTab.windowId}"
      if currentTab.windowId isnt nextTab.windowId
        ChromeBrowserController.focusWindow nextTab.windowId
      ChromeBrowserController.activateTab nextTab.id
