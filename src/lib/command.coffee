class Command
  constructor: (name, @input = null, @context={}) ->
    _.extend @, Commands.get name
    # if @input?
    @normalizeInput()

  normalizeInput: ->
    if @rule?
      @input = @grammar.normalizeInput(@input)
    else
      switch @grammarType
        when "textCapture"
          @input = Actions.normalizeTextArray @input
        when "numberRange"
          @input = @normalizeNumberRange(@input)

  transform: ->
    Transforms[@transform]

  generate: ->
    input = @input
    context = @generateContext()
    funk = switch @kind
      when "action"
        action = @action
        -> action.call(@, input, context)
      else
        -> null

    core = if @extensions?
      extensions = []
      extensions.push funk
      _.each @extensions, (e) ->
        extensions.push ->
          e.call(@, input, context)
      ->
        @extensionsStopped = false
        for callback in extensions.reverse()
          unless @extensionsStopped
            callback.call(@, input, context)
    else
      funk
    segments = []

    # before actions
    if @before?
      beforeList = []
      _.each @before, (e) ->
        beforeList.push ->
          e.call(@, input, context)
      segments.push ->
        for callback in beforeList.reverse()
          callback.call(@)

    # core actions
    segments.push core

    # after actions
    if @after?
      afterList = []
      _.each @after, (e) ->
        afterList.push ->
          e.call(@, input, context)
      segments.push ->
        for callback in afterList.reverse()
          callback.call(@)

    # needs to return an executable function that can be called later.
    # context should be explicitly set to an 'Actions' instance when called
    ->
      for segment in segments
        segment?.call(@)

  generateContext: ->
    context = {}
    _.extend context, @context
    context.subcommandIndex = Commands.subcommandIndex
    context.chain = Commands.lastParsing
    if @historic
      _.extend context,
        lastFullCommand: Commands.lastFullCommand
        lastIndividualCommand: Commands.lastIndividualCommand
        repetitionIndex: Commands.repetitionIndex
    context

  normalizeNumberRange: (input) ->
    if typeof input is "object"
      input
    else
      if input?
        {first: parseInt(input)}
      else
        {first: null, last: null}

  getTriggerPhrase: ->
    triggerPhrase = @namespace or @namespace
    if @triggerPhrase?
      triggerPhrase = @triggerPhrase
    triggerPhrase

module.exports = Command
