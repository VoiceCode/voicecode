# console.log = require 'nslog'
path = require 'path'
notifier = require 'node-notifier'
class EventEmitter extends require('events').EventEmitter
  instance = null
  constructor: ->
    return instance if instance?
    @debug = false
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
    # @suppressedDebugEntries = [
    #   'commandEnabled'
    #   'commandOverwritten'
    # ]
    instance = @

  error: (event) ->
    namespace = event || 'VoiceCode'
    console.error "ERROR: [#{namespace}]", _.toArray(arguments)[2]
    @emit.apply @, _.toArray arguments

  log: (event) ->
    namespace = event || 'VoiceCode'
    unless @debug
      console.log "LOG: [#{namespace}]", _.toArray(arguments)[2]
    @emit.apply @, _.toArray arguments

  warning: (event) ->
    namespace = event || 'VoiceCode'
    unless @debug
      console.log "WARNING: [#{namespace}]", _.toArray(arguments)[2]
    @emit.apply @, _.toArray arguments

  notify: (event) ->
    if Settings.notificationProvider is "log"
      @log.apply @, _.toArray arguments
    else
      namespace = event || 'VoiceCode'
      # TODO: take user settings into consideration
      # https://github.com/mikaelbr/node-notifier
      notifier.Growl().notify
        title: 'VoiceCode'
        message: _.toArray(arguments)[2]
        icon: path.join(projectRoot, 'assets', 'vc.png')
    @emit.apply @, _.toArray arguments

  emit: (event) ->
    return unless event?
    if @debug
      unless event in @suppressedDebugEntries
        console.error "EMITTING: [#{event}]", _.toArray(arguments)[1..]
    super

module.exports = new EventEmitter
