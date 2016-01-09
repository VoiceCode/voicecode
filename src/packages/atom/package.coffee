_pipe = require './pipe'
_remoteCodeInjector = require './remote_code_injector'

pack = Packages.register
  name: 'atom'
  applications: ['com.github.atom']
  description: 'Atom IDE integration (atom.io)'
  pipe: _pipe
  remoteCodeInjector: _remoteCodeInjector
pack.state ?= {}

Settings.extend "editorApplications", pack.applications()
Events.on 'atomMessage', ({type, body}) ->
  if type is 'editor-state'
    Actions.setCurrentApplication _.extend Actions.currentApplication(),
    editorFocused: body.focused
    editorIsMini: body.mini


pack.actions
  runAtomCommand: (method, args) ->
    pack.options.pipe.send
      type: 'invocation'
      body: {method, args}

pack.settings
  modalWindowDelay: 400

pack.implement
  condition: ->
    !@currentApplication().editorIsMini
,
  'common:enter': ->
    @runAtomCommand 'editorNewLine'


pack.implement
  condition: ->
    !!@currentApplication().editorFocused
,
  'core:string': (string) ->
    @runAtomCommand 'editorInsertText', string



pack.implement
  'line.move.up': ->
    @key 'up', 'control command'

  'line.move.down': ->
    @key 'down', 'control command'

  'selection:word.next': (input) ->
    @runAtomCommand 'selectNextWord', input or 1

  'selection:word.previous': (input) ->
    @runAtomCommand 'selectPreviousWord', input or 1

  'editor:move-to-line-number': (input) ->
    if input
      @runAtomCommand 'goToLine', input
    else
      @key 'g', 'control'

  'editor:move-to-line-number+way-right': true
  'editor:move-to-line-number+way-left': true
  'editor:insert-under-line-number': true
  'editor:move-to-line-number+select-line': true

  'object:refresh': ->
    @key 'L', 'control option command'

  'object:duplicate': ->
    # TODO: steal implementation from package
    # @runAtomCommand "trigger", "duplicate-line-or-selection:duplicate"
    @key 'D', 'shift command'

  'text-manipulation:delete-lines': ({first, last} = {}) ->
    if last?
      @runAtomCommand 'selectLineRange',
        from: first
        to: last
    else if first?
      @runAtomCommand 'goToLine', first
    @delay 40
    @key 'k', 'control shift'

  'selection:previous.word-occurrence': (input) ->
    term = input?.value or @storage.previousSearchTerm
    if term?.length
      @storage.previousSearchTerm = term
      @runAtomCommand "selectPreviousOccurrence",
        value: term
        distance: input.distance or 1

  'selection:next.word-occurrence': (input) ->
    term = input?.value or @storage.nextTrapSearchTerm
    if term?.length
      @storage.previousTrapSearchTerm = term
      @runAtomCommand "selectNextOccurrence",
        value: term
        distance: input.distance or 1

  'selection:extend.next.word-occurrence': (input) ->
    term = input?.value or @storage.previousSearchTerm
    if term?.length
      @storage.previousSearchTerm = term
      @runAtomCommand "selectToNextOccurrence",
        value: term
        distance: input.distance or 1

  'selection:extend.previous.word-occurrence': (input) ->
    term = input?.value or @storage.previousSearchTerm
    if term?.length
      @storage.previousSearchTerm = term
      @runAtomCommand "selectToPreviousOccurrence",
        value: term
        distance: input.distance or 1

  'selection:previous.selection-occurrence': ->
    @runAtomCommand "selectPreviousOccurrence",
      value: null
      distance: 1

  'selection:next.selection-occurrence': ->
    @runAtomCommand "selectNextOccurrence",
      value: null
      distance: 1

  'selection:previous.word-by-surrounding-characters': (input) ->
    term = input?.value or @storage.previousTrapSearchTerm
    if term?.length
      @storage.previousTrapSearchTerm = term
      @runAtomCommand "selectSurroundedOccurrence",
        expression: term
        distance: input.distance or 1
        direction: -1

  'selection:next.word-by-surrounding-characters': (input) ->
    term = input?.value or @storage.previousTrapSearchTerm
    if term?.length
      @storage.previousTrapSearchTerm = term
      @runAtomCommand "selectSurroundedOccurrence",
        expression: term
        distance: input.distance or 1
        direction: 1

  'editor:expand-selection-to-scope': ->
    @runAtomCommand "trigger", "expand-selection:expand"

  'editor:toggle-comments': ({first, last} = {}) ->
    if last?
      @runAtomCommand 'selectLineRange',
        from: first
        to: last
    else if first?
      @runAtomCommand 'goToLine', first
    @delay 50
    @key '/', 'command'

  'editor:extend-selection-to-line-number': (input) ->
    @runAtomCommand 'extendToLine', input

  'editor:insert-from-line-number': (input) ->
    if input?
      @runAtomCommand 'insertContentFromLine', input

  'editor:select-line-number-range': (input) ->
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

pack.commands
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


Chain.preprocess pack.options, (chain) ->
  _.reduce chain, (newChain, link, index) ->
    newChain.push link
    if link.command is 'core:literal' and
      chain[index - 1]?.command is 'common:open.tab' and
      chain[index + 1]?.command is 'common:enter'
        newChain.push {command: 'core:delay', arguments: pack.settings().modalWindowDelay}
    newChain
  , []
