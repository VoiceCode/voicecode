# console.log = require 'nslog'

class EventEmitter extends require('events').EventEmitter
  instance = null
  constructor: ->
    return instance if instance?
    @debug = true
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
      'assetEvaluation'
      'assetEvaluationError'
      'assetPath'
      'growlPhrase'
      'dragonPhrase'
      'slaveDisconnected'
      'slaveConnected'
    ]
    # @suppressedDebugEntries = []
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

module.exports = EventEmitter
