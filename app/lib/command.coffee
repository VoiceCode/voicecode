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
    context = @context

    Actions.executionStack.unshift true

    unless _.isEmpty @befores
      _.each @befores, ({action: e, info}) =>
        options = _.extend {}, info, {input, context}
        if Scope.active(options) and _.isFunction(e)
          emit 'beforeWillExecute', {@id, e, info}
          e.call(Actions, input, context)
        true

    # one of the befores called @stop()
    return unless Actions.executionStack[0]

    sorted = @sortedImplementations()
    if _.isEmpty sorted
      warning null, null, "#{@id} has no implementations"

    result = null
    _.each sorted, ({action: e, info}) =>
      options = _.extend {}, info, {input, context}
      if Scope.active(options) and _.isFunction(e)
        emit 'implementationWillExecute', {@id, e, info}
        result = e.call(Actions, input, context)
        # stop execution, only one (the most 'specific') action should execute
        return false
      return true

    # after
    unless _.isEmpty @afters
      _.each @afters, ({action: e, info}) =>
        options = _.extend {}, info, {input, context}
        if Scope.active(options) and _.isFunction(e)
          emit 'afterWillExecute', {@id, e, info}
          e.call(Actions, input, context)
        true

    Actions.executionStack.shift()
    return result

  # here we are sorting the implementations by specificity -
  # this implementation is crude
  # but it should work for now
  # also, caching?
  sortedImplementations: ->
    _.sortBy @implementations, ({info}) ->
      result = 0
      weight = info.weight or 0
      if info.scope?
        unless info.scope is 'global' or info.scope is 'abstract'
          scope = Scope.get info.scope

          if scope.applications().length
            result += 1
          if scope.conditions().length
            result += 1
            # tiebreaker if multiple conditions
            result += (scope.conditions().length - 1) / 10
          if scope.platform?
            result += 0.5

      (result - weight) * -1

  active: ->
    _.some @implementations, ({info}) ->
      Scope.active info

  scopes: ->
    _.compact _.uniq _.map @implementations, ({info}) =>
      info.scope

  applications: ->
    _.compact _.uniq _.flattenDeep _.map @scopes(), (scope) =>
      Scope.get(scope)?.applications()

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
