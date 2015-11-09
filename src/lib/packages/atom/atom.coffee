# TODO: distance parameter must react to repetition command
# TODO: implement synchronicity. We need to wait for success/failure call back.
#       The chain must break if something like core.search.next.wordOccurrence fails
#       Actions.breakChain: -> emit 'chainLinkBroken', ...
packageInfo =
  name: 'atom'
  description: 'Atom IDE integration'
  triggerScopes: ['Atom']
  tags: ['atom']

Commands.before 'line.move.up', packageInfo, (input, context) ->
  @key 'up', 'control command'
  @stop()

Commands.before 'line.move.down', packageInfo, (input, context) ->
  @key 'down', 'control command'
  @stop()

Commands.before 'select.word.next', packageInfo, (input, context) ->
  @runAtomCommand 'selectNextWord', input or 1
  @stop()

Commands.before 'select.word.previous', packageInfo, (input, context) ->
  @runAtomCommand 'selectPreviousWord', input or 1
  @stop()

Commands.before 'cursor.move.lineNumber', packageInfo, (input, context) ->
  if input
    @runAtomCommand 'goToLine', input
  else
    @key 'g', 'control'
  @stop()

# thank you very much, I tried it while rewriting this.../facepalm
Commands.before 'object.refresh', packageInfo, (input, context) ->
  @key 'L', 'control option command'
  @stop()

Commands.before 'object.duplicate', packageInfo, ({first, last} = {}) ->
  # TODO: steal implementation from package
  # @runAtomCommand "trigger", "duplicate-line-or-selection:duplicate"
  @key 'D', 'shift command'
  @stop()

Commands.before 'delete.all.line', packageInfo, ({first, last} = {}) ->
  if last?
    @runAtomCommand 'selectLineRange',
      from: first
      to: last
  else if first?
    @runAtomCommand 'goToLine', first
  @delay 40
  @key 'k', 'control shift'
  @stop()

Commands.before 'search.previous.wordOccurrence', packageInfo, (input, context) ->
  term = input?.value or @storage.previousSearchTerm
  if term?.length
    @storage.previousSearchTerm = term
    @runAtomCommand "selectPreviousOccurrence",
      value: term
      distance: input.distance or 1
    @stop()

Commands.before 'search.next.wordOccurrence', packageInfo, (input, context) ->
  term = input?.value or @storage.nextTrapSearchTerm
  if term?.length
    @storage.previousTrapSearchTerm = term
    @runAtomCommand "selectNextOccurrence",
      value: term
      distance: input.distance or 1
    @stop()

Commands.before 'search.extendSelection.next.wordOccurrence', packageInfo, (input, context) ->
  term = input?.value or @storage.previousSearchTerm
  if term?.length
    @storage.previousSearchTerm = term
    @runAtomCommand "selectToNextOccurrence",
      value: term
      distance: input.distance or 1
    @stop()

Commands.before 'search.extendSelection.previous.wordOccurrence', packageInfo, (input, context) ->
  term = input?.value or @storage.previousSearchTerm
  if term?.length
    @storage.previousSearchTerm = term
    @runAtomCommand "selectToPreviousOccurrence",
      value: term
      distance: input.distance or 1
    @stop()

Commands.before 'search.previous.selectionOccurrence', packageInfo, (input, context) ->
  @runAtomCommand "selectPreviousOccurrence",
    value: null
    distance: 1
  @stop()

Commands.before 'search.next.selectionOccurrence', packageInfo, (input, context) ->
  @runAtomCommand "selectNextOccurrence",
    value: null
    distance: 1
  @stop()

Commands.before 'search.previous.wordBySurroundingCharacters', packageInfo, (input, context) ->
  term = input?.value or @storage.previousTrapSearchTerm
  if term?.length
    @storage.previousTrapSearchTerm = term
    @runAtomCommand "selectSurroundedOccurrence",
      expression: term
      distance: input.distance or 1
      direction: -1
    @stop()

Commands.before 'search.next.wordBySurroundingCharacters', packageInfo, (input, context) ->
  term = input?.value or @storage.previousTrapSearchTerm
  if term?.length
    @storage.previousTrapSearchTerm = term
    @runAtomCommand "selectSurroundedOccurrence",
      expression: term
      distance: input.distance or 1
      direction: 1
    @stop()


Commands.createDisabledWithDefaults packageInfo,
  'atom.connect': # TODO: deprecated?
    spoken: 'connector'
    description: 'connect voicecode to atom'
    action: (input) ->
      # can't use runAtomCommand here because it isn't connected yet :)
      @openMenuBarPath(['Packages', 'VoiceCode', 'Connect'])
  'atom.projects.list':
    spoken: 'projector'
    description: 'Switch projects in Atom'
    action: (input) ->
      @runAtomCommand 'trigger', 'project-manager:list-projects'
  'atom.jump-to-symbol.dialogue':
    spoken: 'jumpy'
    description: 'Open jump-to-symbol dialogue'
    action: (input) ->
      @runAtomCommand 'trigger', 'symbols-view:toggle-file-symbols'
  'atom.search-selection':
    spoken: 'marthis'
    description: 'Use the currently selected text as a search term'
    action: ->
      @key 'e', 'command'

Commands.createDisabled 'application.open.atom',
    spoken: 'tradam' # TODO: deprecated?
    description: 'Open Atom. (this is needed because the regular "fox Atom" always opens a new window)'
    tags: ['atom']
    action: -> @openApplication "Atom"

customDescription = ((_.clone packageInfo).description = 'Requires "expand-selection" package')
Commands.before 'combo.expandSelectionToScope', customDescription,
  (input, context) ->
    @runAtomCommand "trigger", "expand-selection:expand"
    @stop()

Commands.before 'ide.toggleComment', packageInfo, ({first, last} = {}) ->
  if last?
    @runAtomCommand 'selectLineRange',
      from: first
      to: last
  else if first?
    @runAtomCommand 'goToLine', first
  @delay 50
  @key '/', 'command'
  @stop()

Commands.before 'select.untilLineNumber', packageInfo, (input, context) ->
  @runAtomCommand 'extendSelectionToLine', input
  @stop()

Commands.before 'combo.insertContentFromLine', packageInfo, (input, context) ->
  if input?
    @runAtomCommand 'insertContentFromLine', input
    @stop()

Commands.before 'select.line.range', packageInfo, (input, context) ->
  if input?
    number = input.toString()
    length = Math.floor(number.length / 2)
    first = number.substr(0, length)
    last = number.substr(length, length + 1)
    first = parseInt(first)
    last = parseInt(last)
    if last < first
      temp = last
      last = first
      first = temp

  @runAtomCommand 'selectLineRange',
    from: first
    to: last
  @stop()
