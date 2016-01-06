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

    unless _.isEmpty @before
      @extensionStack.unshift true
      _.each _.reverse(@before), ({action: e, info}) ->
        if Scope.active(info) and _.isFunction(e)
          if @extensionStack[0] is true
            @extensionStack[0] = false
            e.call(Actions, input, context)
          @extensionStack.shift()

    debug 'sorted', @sortedActions()
    _.each @sortedActions(), ({action: e, info}) ->
      if Scope.active(info) and _.isFunction(e)
        e.call(Actions, input, context)
        # stop execution, only one (the most 'specific') action should execute
        return false

    # after actions
    unless _.isEmpty @after?
      _.each _.reverse(@after), ({action: e, info}) ->
        if Scope.active(info) and _.isFunction(e)
          e.call(Actions, input, context)

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
