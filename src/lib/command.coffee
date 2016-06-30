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

  # https://gist.github.com/dimatter/0206268704609de07119
  @property 'grammar',
    get: ->
      Commands.mapping[@id].grammar = new CustomGrammar(@spoken, @rule, @variables)

  package: ->
    if @packageId?
      Packages.get @packageId

  execute: ->
    input = @input
    id = @id
    context = @generateContext()

    Actions.executionStack.unshift true
    unless _.isEmpty @befores
      _.each @befores, ({action: e, info}) =>
        if Scope.active(_.extend {},
        info, {id, input, context}) and _.isFunction(e)
          emit 'beforeWillExecute', {@id, e, info}
          e.call(Actions, input, context)
        Actions.executionStack[0]
        true

    return unless Actions.executionStack[0]

    sorted = @sortedImplementations()
    if _.isEmpty sorted
      warning null, null, "#{@id} has no implementations"

    _.each sorted, ({action: e, info}) =>
      if Scope.active(_.extend {},
      info, {id, input, context}) and _.isFunction(e)
        emit 'implementationWillExecute', {@id, e, info}
        e.call(Actions, input, context)
        # stop execution, only one (the most 'specific') action should execute
        return false
      return true

    # after
    unless _.isEmpty @afters
      _.each @afters, ({action: e, info}) =>
        if Scope.active(_.extend {},
        info, {id, input, context}) and _.isFunction(e)
          emit 'afterWillExecute', {@id, e, info}
          e.call(Actions, input, context)
        Actions.executionStack[0]
        true

    Actions.executionStack.shift()

  # here we are sorting the implementations by specificity -
  # this implementation is crude
  # but it should work for now
  # also, caching?
  sortedImplementations: ->
    _.sortBy @implementations, ({action: e, info}) ->
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
    _.some @implementations, ({action: e, info}) ->
      Scope.active info

  getApplications: ->
    if @scope?
      _.reduce @implementations, (result, value, key) ->
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
