CustomGrammar = require './parser/customGrammar'
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

  @property 'grammar',
    get: ->
      Commands.mapping[@id].grammar = new CustomGrammar(@rule, @variables)

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

  # here we are sorting the actions by specificity - this implementation is crude
  # but it should work for now
  sortedActions: ->
    _.sortBy @actions, ({action: e, info}) ->
      result = {}
      if info.scope?
        unless info.scope is 'global' or info.scope is 'abstract'
          scope = Scope.get info.scope
          result.applications = true if scope.applications().length
          result.condition = true if scope.condition?
          result.platform = true if scope.platform?

      result.applications = true if info.applications?.length > 0
      result.condition = true if info.condition?
      result.platform = true if info.platform?

      _.size(result) * -1

  active: ->
    _.any @actions, ({action: e, info}) ->
      Scope.active info

  getApplications: ->
    if @scope?
      _.reduce @actions, (result, value, key) ->
        _.union result, Scope.applications(value.info.scope)
      , []
    else
      # it's global
      []

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
