# TODO: distance parameter must react to repetition command
# TODO: implement synchronicity. We need to wait for success/failure call back.
#       The chain must break if something like core.search.next.wordOccurrence fails
#       Actions.breakChain: -> emit 'chainLinkBroken', ...

instance = Packages.register
  name: 'atom'
  description: 'Atom IDE integration'
  triggerScopes: ['Atom']
  tags: ['atom']

instance.before
  'line.move.up': ->
    @key 'up', 'control command'
    @stop()

  'line.move.down': ->
    @key 'down', 'control command'
    @stop()

  'select.word.next': (input) ->
    @runAtomCommand 'selectNextWord', input or 1
    @stop()

  'select.word.previous': (input) ->
    @runAtomCommand 'selectPreviousWord', input or 1
    @stop()

  'cursor.move.lineNumber': (input) ->
    if input
      @runAtomCommand 'goToLine', input
    else
      @key 'g', 'control'
    @stop()

  # thank you very much, I tried it while rewriting this.../facepalm...ha ha
  'object.refresh': ->
    @key 'L', 'control option command'
    @stop()

  'object.duplicate': ({first, last} = {}) ->
    # TODO: steal implementation from package
    # @runAtomCommand "trigger", "duplicate-line-or-selection:duplicate"
    @key 'D', 'shift command'
    @stop()

  'delete.all.line': ({first, last} = {}) ->
    if last?
      @runAtomCommand 'selectLineRange',
        from: first
        to: last
    else if first?
      @runAtomCommand 'goToLine', first
    @delay 40
    @key 'k', 'control shift'
    @stop()

  'search.previous.wordOccurrence': (input) ->
    term = input?.value or @storage.previousSearchTerm
    if term?.length
      @storage.previousSearchTerm = term
      @runAtomCommand "selectPreviousOccurrence",
        value: term
        distance: input.distance or 1
      @stop()

  'search.next.wordOccurrence': (input) ->
    term = input?.value or @storage.nextTrapSearchTerm
    if term?.length
      @storage.previousTrapSearchTerm = term
      @runAtomCommand "selectNextOccurrence",
        value: term
        distance: input.distance or 1
      @stop()

  'search.extendSelection.next.wordOccurrence': (input) ->
    term = input?.value or @storage.previousSearchTerm
    if term?.length
      @storage.previousSearchTerm = term
      @runAtomCommand "selectToNextOccurrence",
        value: term
        distance: input.distance or 1
      @stop()

  'search.extendSelection.previous.wordOccurrence': (input) ->
    term = input?.value or @storage.previousSearchTerm
    if term?.length
      @storage.previousSearchTerm = term
      @runAtomCommand "selectToPreviousOccurrence",
        value: term
        distance: input.distance or 1
      @stop()

  'search.previous.selectionOccurrence': ->
    @runAtomCommand "selectPreviousOccurrence",
      value: null
      distance: 1
    @stop()

  'search.next.selectionOccurrence': ->
    @runAtomCommand "selectNextOccurrence",
      value: null
      distance: 1
    @stop()

  'search.previous.wordBySurroundingCharacters': (input) ->
    term = input?.value or @storage.previousTrapSearchTerm
    if term?.length
      @storage.previousTrapSearchTerm = term
      @runAtomCommand "selectSurroundedOccurrence",
        expression: term
        distance: input.distance or 1
        direction: -1
      @stop()

  'search.next.wordBySurroundingCharacters': (input) ->
    term = input?.value or @storage.previousTrapSearchTerm
    if term?.length
      @storage.previousTrapSearchTerm = term
      @runAtomCommand "selectSurroundedOccurrence",
        expression: term
        distance: input.distance or 1
        direction: 1
      @stop()

  'combo.expandSelectionToScope': ->
    @runAtomCommand "trigger", "expand-selection:expand"
    @stop()

  'ide.toggleComment': ({first, last} = {}) ->
    if last?
      @runAtomCommand 'selectLineRange',
        from: first
        to: last
    else if first?
      @runAtomCommand 'goToLine', first
    @delay 50
    @key '/', 'command'
    @stop()

  'select.untilLineNumber': (input) ->
    @runAtomCommand 'extendSelectionToLine', input
    @stop()

  'combo.insertContentFromLine': (input) ->
    if input?
      @runAtomCommand 'insertContentFromLine', input
      @stop()

  'select.line.range': (input) ->
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

instance.commands
  'connect': # TODO: deprecated?
    spoken: 'connector'
    description: 'connect voicecode to atom'
    action: ->
      # can't use runAtomCommand here because it isn't connected yet :)
      @openMenuBarPath(['Packages', 'VoiceCode', 'Connect'])
  'projects.list':
    spoken: 'projector'
    description: 'Switch projects in Atom'
    action: ->
      @runAtomCommand 'trigger', 'project-manager:list-projects'
  'jump-to-symbol.dialogue':
    spoken: 'jumpy'
    description: 'Open jump-to-symbol dialogue'
    action: ->
      @runAtomCommand 'trigger', 'symbols-view:toggle-file-symbols'
  'search-selection':
    spoken: 'marthis'
    description: 'Use the currently selected text as a search term'
    action: ->
      @key 'e', 'command'
  'open':
    spoken: 'tradam' # TODO: deprecated?
    description: 'Open Atom. (this is needed because the regular "fox Atom" always opens a new window)'
    action: -> @openApplication "Atom"
