path = require 'path'
notifier = require 'node-notifier'
class EventEmitter extends require('events').EventEmitter
  instance = null
  constructor: ->
    return instance if instance?
    @setMaxListeners 1000
    instance = @
    @debug = true
    @frontendSubscriptions = {}
    @suppressedDebugEntries = [
      'commandEnabled'
      'commandDisabled'
      # 'commandNameChanged'
      'commandNotFound'
      'commandAfterAdded'
      'commandBeforeAdded'
      'commandMisspellingsAdded'
      'commandOverwritten'
      'dragonSynchronizingStarted'
      'dragonSynchronizingEnded'
      'writingFile'
      'chainParsed'
      'chainPreprocessed'
      'slaveCommandReceived'
      'masterConnected'
      'masterDisconnected'
      'assetEvaluation'
      'assetEvaluationError'
      'assetPath'
      'growlPhrase'
      'dragonPhrase'
      'slaveDisconnected'
      'slaveConnected'
    ]
    @suppressedDebugEntries = [
      # 'deprecation'
      'actionWillExecute'
      'enableCommand'
      'commandCreated'
      'commandEnabled'
      'commandImplementationAdded'
      # 'commandOverwritten'
      'commandAfterAdded'
      'commandBeforeAdded'
      'commandMisspellingsAdded'
      'commandSpokenChanged'
      'assetEvent'
      'assetEvaluated'
      'assetsLoaded'
      'userAssetEvent'
      'userAssetsLoading'
      'userAssetsLoaded'
      'userAssetEvaluated'
      'commandEditsPerformed'
      'userCodeCommandEditsPerformed'
      'enabledCommandsCommandEditsPerformed'
      'slaveModeEnableAllCommandsCommandEditsPerformed'
      # 'commandValidationFailed'
      # 'commandValidationError'
      'chainParsed'
      'chainPreprocessed'
      'chainWillExecute'
      'commandDidExecute'
      'chainDidExecute'
      # 'commandNotFound'
      'packageAssetEvent'
    ]

  frontendOn: (event, callback) ->
    @frontendSubscriptions[event] ?= []
    @frontendSubscriptions[event].push callback
    @on event, callback

  frontendClearSubscriptions: ->
    _.all @frontendSubscriptions, (callbacks, event) =>
      @unsubscribe event, callbacks
    @frontendSubscriptions = {}

  unsubscribe: (event, callback) ->
    if _.isArray callback
      _.every callback, (c) => @unsubscribe event, c
    @removeListener event, callback

  on: (event, callback) ->
    super

  _output: ->
    args = arguments
    process.nextTick ->
      do args[0]
      # console.log.apply console, args

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
          util.inspect(args, {depth: 3})
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
