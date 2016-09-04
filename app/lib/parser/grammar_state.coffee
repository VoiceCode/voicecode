class GrammarState
  constructor: ->
    @index = 0
    @chain = []

  found: (info) ->
    # return true if command should be accepted, false if rejected, and keep state for next command in chain
    command = new Command(info.c, info.a)

    if command.continuous is false
      return false if @index > 0

    if command.isConditional()
      return command.active()

    if command.nested?
      if command.nested is true
        return false
      # if _.isString(command.nested)
      #   return !Scope.active(command.nested)
      # if _.isFunction(command.nested)
      #   return !command.nested.call(Actions)

    @index++
    @chain.push command

    true

  nested: (info) ->
    # return true if command should be accepted as a nested command, false if it should break out
    command = new Command(info.c, info.a)
    if !command.nested?
      return false

    if command.nested is true
      return true
    # if _.isString(command.nested)
    #   return Scope.active(command.nested)
    # if _.isFunction(command.nested)
    #   return command.nested.call(Actions)

    return false

  getNest: (info) ->
    # return true if command should be accepted as a nested command, false if it should break out
    command = new Command(info.c, info.a)
    if !command.text?
      return false

    if _.isString(command.text)
      return [command.text]
    if _.isFunction(command.text)
      return [command.text.call(Actions)]

    return []


  sen: (id) ->
    # return false if sentinel should be ignored - and free-text should prevail
    command = new Command(id)

    if command.continuous is false
      # return false if @index > 0
      # if it gets here it must be nested inside a phrase
      return false

    if command.isConditional()
      return command.active()

    true

module.exports = GrammarState
