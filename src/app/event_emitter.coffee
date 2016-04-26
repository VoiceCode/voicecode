path = require 'path'
class EventEmitter extends require('events').EventEmitter
  instance = null
  constructor: ->
    return instance if instance?
    @setMaxListeners 100
    instance = @
    @debug = true
    @frontendSubscriptions = {}
    @suppressedDebugEntries = [
      # 'deprecation'
      # 'implementationWillExecute'
      'enableCommand'
      'commandCreated'
      'commandEnabled'
      'windowCreated'
      'implementationCreated'
      # 'commandOverwritten'
      'commandAfterAdded'
      'commandBeforeAdded'
      'commandMisspellingsAdded'
      'commandSpokenChanged'
      # 'assetEvent'
      # 'assetEvaluated'
      # 'assetsLoaded'
      # 'userAssetEvent'
      # 'userAssetsLoading'
      # 'userAssetsLoaded'
      # 'userAssetEvaluated'
      'packageReady'
      'userAssetEvaluated'
      'userAssetEvent'
      'packageAssetEvaluated'
      'packageAssetEvent'
      # 'commandEditsPerformed'
      'userCodeCommandEditsPerformed'
      'enabledCommandsCommandEditsPerformed'
      'slaveModeEnableAllCommandsCommandEditsPerformed'
      'packageCreated'
      'assetEvent'
      # 'commandValidationFailed'
      # 'commandValidationError'
      # 'chainParsed'
      # 'chainPreprocessed'
      # 'chainWillExecute'
      # 'commandDidExecute'
      # 'chainDidExecute'
      # 'commandNotFound'
      'eventMonitorStarted'
      'dragonStarted'
      # 'packageAssetEvent'
    ]
    @suppressedDebugEntries = []
  frontendOn: (event, callback) ->
    # this is needed because only enumerable properties are accessible
    # via remote module i.e every object needs to be flattened
    switch event
      when 'implementationCreated'
        _callback = ->
          implementations = _.keys arguments[0].implementations
          commandId = arguments[0].id
          callback.call null, {implementations, commandId}
    @frontendSubscriptions[event] ?= []
    @frontendSubscriptions[event].push _callback or callback
    @on event, (_callback or callback)


  frontendClearSubscriptions: ->
    _.each @frontendSubscriptions, (callbacks, event) =>
      @unsubscribe event, callbacks
    @frontendSubscriptions = {}

  # frontendEmit: (event) ->
  #   debug arguments
  #   debug @frontendSubscriptions
  #   @emit.apply @, arguments
  #   return unless @frontendSubscriptions[event]?
  #   _.each @frontendSubscriptions[event], (callback) =>
  #     callback.apply @, arguments[1...]

  unsubscribe: (event, callback) ->
    if _.isArray callback
      _.each callback, (c) => @unsubscribe event, c
    @removeListener event, callback

  on: (event, callback) ->
    if _.isArray event
      _.map event, (e) =>
        @on e, callback
      return
    super

  once: (event, callback) ->
    if _.isArray event
      _.map event, (e) =>
        @once e, callback
      return
    super

  removeListener: (event, callback) ->
    if _.isArray event
      _.map event, (e) =>
        @removeListener e, callback
      return
    super

  _output: ->
    args = arguments
    # process.nextTick ->
    do args[0]

  error: (event) ->
    unless @debug
      namespace = event || 'VoiceCode'
      @_output ->
        console.log chalk.white.bold.bgRed('  ERROR  '),
        chalk.white.bgBlack(" #{namespace}:"),
        chalk.white.bgBlack(_.toArray(arguments)[2] || _.toArray(arguments)[1])
    @emit.apply @, arguments

  log: (event) ->
    unless @debug
      namespace = event || 'VoiceCode'
      @_output ->
        console.log chalk.white.bold.bgBlue('   LOG   '),
        chalk.white.bgBlack(" #{namespace}:"),
        chalk.white.bgBlack(_.toArray(arguments)[2] || _.toArray(arguments)[1])
    @emit.apply @, arguments

  warning: (event) ->
    unless @debug
      namespace = event || 'VoiceCode'
      @_output ->
        console.log chalk.white.bold.bgYellow(' WARNING '),
        chalk.white.bgBlack(" #{namespace}:"),
        chalk.white.bgBlack(_.toArray(arguments)[2] || _.toArray(arguments)[1])
    @emit.apply @, arguments

  notify: (event) ->
    unless @debug
      @log.apply @, arguments
    @emit.apply @, arguments

  emit: (event) ->
    return unless event?
    if @debug
      unless event in @suppressedDebugEntries
        args = _.toArray(arguments)[1..]
        @_output ->
          console.log "%s %s \n",
          chalk.white.bold.bgRed('   EVENT   '),
          chalk.black.bgWhite(" #{event} "),
          util.inspect(args, {depth: 6, colors: true})
    super

  mutate: (event, container={}) ->
    return container unless events = @_events[event]
    container.continue = true
    if _.isFunction events
      events = [events]
    _.reduce events, (container={}, event) ->
      return container unless container.continue
      container = event container
      debug container
      container
    , container

Events = new EventEmitter
global.emit = _.bind Events.emit, Events
global.error = _.bind Events.error, Events
global.log = _.bind Events.log, Events
global.warning = _.bind Events.warning, Events
global.notify = _.bind Events.notify, Events
global.mutate = _.bind Events.mutate, Events
global.unsubscribe = _.bind Events.unsubscribe, Events
module.exports = Events
