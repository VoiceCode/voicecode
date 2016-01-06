class Command
  constructor: (name, @input = null, @context = {}) ->
    _.extend @, Commands.get name
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

  package: ->
    if @packageId?
      Packages.get @packageId

  execute: ->
    input = @input
    context = @generateContext()

    Actions.executionStack.unshift true
    unless _.isEmpty @before
      _.each @before, ({action: e, info}) ->
        if Scope.active(info) and _.isFunction(e)
          emit 'beforeActionWillExecute', info
          e.call(Actions, input, context)
        Actions.executionStack[0]

    return unless Actions.executionStack[0]

    debug 'sorted', @sortedActions()
    _.each @sortedActions(), ({action: e, info}) ->
      if Scope.active(info) and _.isFunction(e)
        e.call(Actions, input, context)
        # stop execution, only one (the most 'specific') action should execute
        return false
      return true

    # after actions
    unless _.isEmpty @after?
      _.each @after, ({action: e, info}) ->
        if Scope.active(info) and _.isFunction(e)
          emit 'afterActionWillExecute', info
          e.call(Actions, input, context)
        Actions.executionStack[0]

    Actions.executionStack.shift()

  sortedActions: ->
    _.sortBy @actions, ({action: e, info}) ->
      result = 0
      result += 1 if info.applications?.length > 0
      result += 1 if info.condition?
      result

  active: ->
    _.any @actions, ({action: e, info}) ->
      Scope.active info

  getApplications: ->
    results = []
    _.each @actions, (value, key) ->
      results = _.union results, Scope.applications(value.info.scope)

  isConditional: ->
    (@scope? and @scope != 'global') or (not _.isEmpty @applications) or @condition?

  generateContext: ->
    @context

  normalizeNumberRange: (input) ->
    if typeof input is "object"
      input
    else
      if input?
        {first: parseInt(input)}
      else
        {first: null, last: null}

  getTriggerPhrase: ->
    if @triggerPhrase?
      @triggerPhrase
    else
      @spoken

module.exports = Command
