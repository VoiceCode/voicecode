class EventEmitter extends Meteor.npmRequire('events').EventEmitter
  instance = null
  constructor: ->
    return instance if instance?
    @debug = true
    @suppressedDebugEntries = []
    @suppressedDebugEntries = [
      'commandEnabled',
      'commandDisabled',
      'commandNameChanged',
      'commandNotFound',
      'commandExtended',
      'commandAfterAdded',
      'commandBeforeAdded',
      'commandMisspellingsAdded',
      'commandOverwritten',
      'dragonSynchronizingStarted',
      'dragonSynchronizingEnded',
      'writingFile',
      'grammarLoading',
      'grammarLoaded',
      'grammarLoadFailed'
    ]
    instance = @

  error: (event) ->
    console.error "ERROR: #{event}", _.toArray(arguments)[1..]
    @emit.apply @, _.toArray arguments

  log: (event) ->
    console.log "LOG: #{event}", _.toArray(arguments)[1..]
    @emit.apply @, _.toArray arguments

  warning: (event) ->
    console.log "WARNING: #{event}", _.toArray(arguments)[1..]
    @emit.apply @, _.toArray arguments

  emit: (event) ->
    if @debug
      unless event in @suppressedDebugEntries
        console.error "emitting: #{event}", _.toArray(arguments)[1..]
    super

@Events = new EventEmitter
@emit = _.bind Events.emit, Events
@error = _.bind Events.error, Events
@log = _.bind Events.log, Events
@warning = _.bind Events.warning, Events
