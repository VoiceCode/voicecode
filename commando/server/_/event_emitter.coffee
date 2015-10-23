class EventEmitter extends Meteor.npmRequire('events').EventEmitter
  instance = null
  constructor: ->
    return instance if instance?
    @debug = true
    # @suppressedLogEntries = []
    @suppressedLogEntries = ['commandEnabled']
    console.error "event emitter"
    instance = @
  emit: (event)->
    if @debug
      unless event in @suppressedLogEntries
        console.error "emitting: #{event}", _.toArray(arguments)[1..]
    super

@Events = new EventEmitter
