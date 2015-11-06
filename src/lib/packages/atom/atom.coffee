# TODO: distance parameter must react to repetition command
# TODO: implement synchronicity. We need to wait for success/failure call back.
#       The chain must break if something like core.search.next.wordOccurrence fails
#       Actions.breakChain: -> emit 'chainLinkBroken', ...
packageInfo = {
  name: 'atom'
  description: 'Atom IDE integration'
  triggerScopes: ['Atom']
}

# thank you very much, I tried it while rewriting this.../facepalm
Commands.before 'core.object.refresh', packageInfo, (index, context) ->
  @key 'L', 'control option command'
  @stop()

Commands.before 'core.object.duplicate', packageInfo, ({first, last} = {}) ->
  # TODO: steal implementation from package
  # @runAtomCommand "trigger", "duplicate-line-or-selection:duplicate"
  @key 'D', 'shift command'
  @stop()

Commands.before 'core.delete.all.line', packageInfo, ({first, last} = {}) ->
  if last?
    @runAtomCommand 'selectLineRange',
      from: first
      to: last
  else if first?
    @runAtomCommand 'goToLine', first
  @delay 40
  @key 'k', 'control shift'
  @stop()

Commands.before 'core.search.previous.wordOccurrence', packageInfo, (input, context) ->
  term = input?.value or @storage.previousSearchTerm
  if term?.length
    @storage.previousSearchTerm = term
    @runAtomCommand "selectPreviousOccurrence",
      value: term
      distance: input.distance or 1
    @stop()

Commands.before 'core.search.next.wordOccurrence', packageInfo, (input, context) ->
  term = input?.value or @storage.nextTrapSearchTerm
  if term?.length
    @storage.previousTrapSearchTerm = term
    @runAtomCommand "selectNextOccurrence",
      value: term
      distance: input.distance or 1
    @stop()

Commands.before 'core.search.extendSelection.next.wordOccurrence', packageInfo, (input, context) ->
  term = input?.value or @storage.previousSearchTerm
  if term?.length
    @storage.previousSearchTerm = term
    @runAtomCommand "selectToNextOccurrence",
      value: term
      distance: input.distance or 1
    @stop()

Commands.before 'core.search.extendSelection.previous.wordOccurrence', packageInfo, (input, context) ->
  term = input?.value or @storage.previousSearchTerm
  if term?.length
    @storage.previousSearchTerm = term
    @runAtomCommand "selectToPreviousOccurrence",
      value: term
      distance: input.distance or 1
    @stop()

Commands.before 'core.search.previous.selectionOccurrence', packageInfo, (input, context) ->
  @runAtomCommand "selectPreviousOccurrence",
    value: null
    distance: 1
  @stop()

Commands.before 'core.search.next.selectionOccurrence', packageInfo, (input, context) ->
  @runAtomCommand "selectNextOccurrence",
    value: null
    distance: 1
  @stop()

Commands.before 'core.search.previous.wordBySurroundingCharacters', packageInfo, (input, context) ->
  term = input?.value or @storage.previousTrapSearchTerm
  if term?.length
    @storage.previousTrapSearchTerm = term
    @runAtomCommand "selectSurroundedOccurrence",
      expression: term
      distance: input.distance or 1
      direction: -1
    @stop()

Commands.before 'core.search.next.wordBySurroundingCharacters', packageInfo, (input, context) ->
  term = input?.value or @storage.previousTrapSearchTerm
  if term?.length
    @storage.previousTrapSearchTerm = term
    @runAtomCommand "selectSurroundedOccurrence",
      expression: term
      distance: input.distance or 1
      direction: 1
    @stop()
