class GrammarState
  constructor: ->
    @index = 0
    @chain = []

  found: (info) ->
    # return true if command should be accepted, false if rejected, and keep state for next command in chain
    @index++
    command = new Command(info.c, info.a)

    if command.continuous is false
      return false if @index > 1

    if command.isConditional()
      return Scope.active command

    @chain.push command

    true

  sen: (id) ->
    # return false if sentinel should be ignored - and free-text should prevail
    command = new Command(id)

    if command.continuous is false
      # return false if @index > 0
      # if it gets here it must be nested inside a phrase
      return false

    if command.isConditional()
      return Scope.active command

    true


module.exports = GrammarState
