class EventEmitter extends Meteor.npmRequire('events').EventEmitter
  instance = null
  constructor: ->
    return instance if instance?
    @debug = true
    @suppressedDebugEntries = [
    ]
    @suppressedDebugEntries = [
      'commandEnabled'
      'commandDisabled'
      'commandNameChanged'
      'commandNotFound'
      'commandExtended'
      'commandAfterAdded'
      'commandBeforeAdded'
      'commandMisspellingsAdded'
      'commandOverwritten'
      'dragonSynchronizingStarted'
      'dragonSynchronizingEnded'
      'writingFile'
      'grammarLoading'
      'grammarLoaded'
      'grammarLoadFailed'
      'chainParsed'
      'chainPreprocessed'
      'slaveCommandReceived'
      'masterConnected'
      'masterDisconnected'
      'assetEvaluationError'
      'assetEvaluation'
      'assetPath'
      'growlPhrase'
      'dragonPhrase'
    ]
    instance = @

  error: (event) ->
    namespace = event || 'VoiceCode'
    console.error "ERROR: [#{namespace}]", _.toArray(arguments)[2]
    @emit.apply @, _.toArray arguments

  log: (event) ->
    namespace = event || 'VoiceCode'
    console.log "LOG: [#{namespace}]", _.toArray(arguments)[2]
    @emit.apply @, _.toArray arguments

  warning: (event) ->
    namespace = event || 'VoiceCode'
    console.log "WARNING: [#{namespace}]", _.toArray(arguments)[2]
    @emit.apply @, _.toArray arguments

  notify: (event) ->
    if Settings.notificationProvider is "log"
      @log.apply @, _.toArray arguments
    else
      Notify _.toArray(arguments)[2]
    @emit.apply @, _.toArray arguments

  emit: (event) ->
    return unless event?
    if @debug
      unless event in @suppressedDebugEntries
        console.error "EMITTING: [#{event}]", _.toArray(arguments)[1..]
    super

@Events = new EventEmitter
@emit = _.bind Events.emit, Events
@error = _.bind Events.error, Events
@log = _.bind Events.log, Events
@warning = _.bind Events.warning, Events
@notify = _.bind Events.notify, Events
