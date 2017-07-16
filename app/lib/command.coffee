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
      grammar = Commands.mapping[@id].grammar
      unless grammar
        grammar = Commands.mapping[@id].grammar =
        new CustomGrammar(@spoken, @rule, @variables)
        emit 'customGrammarCreated', {command: Commands.mapping[@id]}
      grammar

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
          emit 'beforeWillExecute', {@id, info, action: e, input}
          result = e.call(Actions, input, context)
          emit 'beforeDidExecute', {@id, info, action: e, input, result}
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
        emit 'implementationWillExecute', {@id, info, action: e, input}
        result = e.call(Actions, input, context)
        emit 'implementationDidExecute', {@id, info, action: e, input, result}
        # stop execution, only one (the most 'specific') action should execute
        return false
      return true

    # after
    unless _.isEmpty @afters
      _.each @afters, ({action: e, info}) =>
        options = _.extend {}, info, {input, context}
        if Scope.active(options) and _.isFunction(e)
          emit 'afterWillExecute', {@id, info, action: e, input}
          _result = e.call(Actions, input, context)
          emit 'afterDidExecute', {@id, info, action: e, input, result: _result}
        true

    Actions.executionStack.shift()
    return result

  # here we are sorting the implementations by specificity
  # also, caching?
  sortedImplementations: ->
    _.reverse _.sortBy @implementations, ({info}) ->
      specificity = Scope.specificity(info.scope) or 0
      if info.weight
        specificity += info.weight
      specificity

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
