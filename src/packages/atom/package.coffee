remote = require 'atomic_rpc'
coffeeScript = require 'coffee-script'
chokidar = require 'chokidar'
fs = require 'fs'
asyncblock = require 'asyncblock'


class AtomRemote
  constructor: () ->
    @remote = new remote {server: true, port: 7777}
    @remote.on 'connect', ({id}) => @injectCode id
    @remoteCode = ''
    Events.on 'atomRemoteCodeFileEvent', => @injectCode()
    @watch()

  call: ->
    @remote.call.apply @remote, arguments

  expose: ->
    @remote.expose.apply @remote, arguments

  injectCode: (id = null, code = null) ->
    code ?= @remoteCode
    @remote.call
      id: id
      method: 'injectCode'
      params: {code}
      # callback: (error, result)->
      #   emit 'atomCodeInjected', {id, error, result}

  watch: ->
    @watcher = chokidar.watch "#{__dirname}/remote_methods.coffee",
      persistent: true
    @watcher.on('add', (path) =>
      @handleFile 'added', path
    ).on('change', (path) =>
      @handleFile 'changed', path
    ).on('error', (err) ->
      error 'atomRemoteCodeFileError', err, err
    ).on 'ready', ->


  compileCoffeeScript: (data) ->
    coffeeScript.compile data

  handleFile: (event, fileName) ->
    remoteCode = fs.readFileSync fileName, {encoding: 'utf8'}
    try
      remoteCode = @compileCoffeeScript remoteCode
      @remoteCode = remoteCode
    catch err
      warning 'atomRemoteCodeEvaluationError',
      {err, fileName}, "#{fileName}:\n#{err}"
    emit 'atomRemoteCodeFileEvent', event



pack = Packages.register
  name: 'atom'
  applications: ['com.github.atom']
  description: 'Atom IDE integration (atom.io)'
# pack.remote = Fiber(->
#   new AtomRemote
# ).run()
pack.remote = new AtomRemote
Settings.extend "editorApplications", pack.applications()

pack.remote.expose 'updateAppState',
(state, socketId) ->
  if state.editor?
    if state.editor.focused is true
      state.currentSocketId = socketId
    state.editors = {"#{state.editor.id}": state.editor}
    delete state.editor
  Actions.setCurrentApplication _.deepExtend Actions.currentApplication(),
  state

pack.actions
  injectCode: (code) -> pack.remote.injectCode code
  runAtomCommand: (method, params, synchronous = false) ->
    id = Actions.currentApplication().currentSocketId
    if synchronous
      fiber = Fiber.current
      callback = (err = null, result) ->
        debug arguments
        if err?
          Actions.breakChain err
        fiber.run()
      pack.remote.call {id, method, params, callback}
      Fiber.yield()
    else
      pack.remote.call {id, method, params}

pack.settings
  modalWindowDelay: 400

# pack.implement
#   condition: ({key, modifiers}) ->
#     if results = _.findWhere(@currentApplication().editors, {focused: true})?
#       unless modifiers?
#         return true if key.length is 1
#       return false
# ,
#   'os:key': ({key, modifiers}) ->
#     # modifiers = Actions._normalizeModifiers modifiers
#     # modifiers = modifiers.join ' '
#     # modifiers = modifiers.replace 'control', 'ctrl'
#     # modifiers = modifiers.replace 'option', 'alt'
#     # modifiers = modifiers.replace 'command', 'cmd'
#     # modifiers = modifiers.split ' '
#     # modifiers.push key
#     # keystrokes = _.kebabCase modifiers
#     # debug "KEYSTROKES", keystrokes
#     @runAtomCommand 'editorInsertText', key, true
#
pack.implement
  condition: ->
    result = _.findWhere @currentApplication().editors, {focused: true}
    result?.mini is false
,
  'common:enter': ->
    @runAtomCommand 'editorNewLine', null, true

pack.implement
  condition: ->
    results = _.findWhere(@currentApplication().editors, {focused: true})?
    results
,
  'common:redo': ->
    @runAtomCommand 'redo', null, true
  'common:undo': ->
    @runAtomCommand 'undo', null, true
  'text-manipulation:delete-to-end-of-line': ->
    @runAtomCommand 'deleteToEndOfLine', null, true
  'text-manipulation:delete-to-beginning-of-line': ->
    @runAtomCommand 'deleteToBeginningOfLine', null, true
  'text-manipulation:delete.word.forward': ->
    @runAtomCommand 'deleteWordForward', null, true
  'text-manipulation:delete.word.backward': ->
    @runAtomCommand 'deleteWordBackward', null, true
  'cursor:way.right': ->
    @runAtomCommand 'moveToEndOfLine', null, true
  'cursor:way.left': ->
    @runAtomCommand 'deleteToBeginningOfLine', null, true
  'common:deletion.backward': (times = 1) ->
    @runAtomCommand 'deleteBackward', times, true
  'common:deletion.forward': (times = 1) ->
    @runAtomCommand 'deleteForward', times, true
  'cursor:new-line-below': ->
    @runAtomCommand 'newLineBelow', null, true
  'cursor:new-line-above': ->
    @runAtomCommand 'newLineAbove', null, true
  'os:string': (string) ->
    @runAtomCommand 'editorInsertText', string, true
  'text-manipulation:move-line-down': ->
    @key 'up', 'control command'
  'text-manipulation:move-line-up': ->
    @key 'down', 'control command'
  'selection:word.next': (input) ->
    @runAtomCommand 'selectNextWord', input or 1, true
  'selection:word.previous': (input) ->
    @runAtomCommand 'selectPreviousWord', input or 1, true
  'editor:move-to-line-number': (input) ->
    if input
      @runAtomCommand 'goToLine', input, true
    else
      @key 'g', 'control'

  'editor:move-to-line-number+way-right': true
  'editor:move-to-line-number+way-left': true
  'editor:insert-under-line-number': true
  'editor:move-to-line-number+select-line': true

  'object:duplicate': ->
    # TODO: steal implementation from package
    # @runAtomCommand "trigger", "duplicate-line-or-selection:duplicate", true
    @key 'D', 'shift command'

  'text-manipulation:delete-lines': ({first, last} = {}) ->
    if last?
      @runAtomCommand 'selectLineRange',
        from: first
        to: last
      , true
    else if first?
      @runAtomCommand 'goToLine', first, true
    @delay 40
    @key 'k', 'control shift'

  'selection:previous.word-occurrence': (input) ->
    term = input?.value or @storage.previousSearchTerm
    if term?.length
      @storage.previousSearchTerm = term
      @runAtomCommand "selectPreviousOccurrence",
        value: term
        distance: input.distance or 1
      , true

  'selection:next.word-occurrence': (input) ->
    term = input?.value or @storage.nextTrapSearchTerm
    if term?.length
      @storage.previousTrapSearchTerm = term
      @runAtomCommand "selectNextOccurrence",
        value: term
        distance: input.distance or 1
      , true
  'selection:extend.next.word-occurrence': (input) ->
    term = input?.value or @storage.previousSearchTerm
    if term?.length
      @storage.previousSearchTerm = term
      @runAtomCommand "selectToNextOccurrence",
        value: term
        distance: input.distance or 1
      , true
  'selection:extend.previous.word-occurrence': (input) ->
    term = input?.value or @storage.previousSearchTerm
    if term?.length
      @storage.previousSearchTerm = term
      @runAtomCommand "selectToPreviousOccurrence",
        value: term
        distance: input.distance or 1
      , true
  'selection:previous.selection-occurrence': ->
    @runAtomCommand "selectPreviousOccurrence",
      value: null
      distance: 1
    , true
  'selection:next.selection-occurrence': ->
    @runAtomCommand "selectNextOccurrence",
      value: null
      distance: 1
    , true

  'selection:previous.word-by-surrounding-characters': (input) ->
    term = input?.value or @storage.previousTrapSearchTerm
    if term?.length
      @storage.previousTrapSearchTerm = term
      @runAtomCommand "selectSurroundedOccurrence",
        expression: term
        distance: input.distance or 1
        direction: -1
      , true
  'selection:next.word-by-surrounding-characters': (input) ->
    term = input?.value or @storage.previousTrapSearchTerm
    if term?.length
      @storage.previousTrapSearchTerm = term
      @runAtomCommand "selectSurroundedOccurrence",
        expression: term
        distance: input.distance or 1
        direction: 1
      , true
  'editor:expand-selection-to-scope': ->
    @runAtomCommand "trigger",
      selector: 'atom-workspace',
      command: 'expand-selection:expand'
    , true

  'editor:toggle-comments': ({first, last} = {}) ->
    if last?
      @runAtomCommand 'selectLineRange',
        from: first
        to: last
      , true
    else if first?
      @runAtomCommand 'goToLine', first, true
    @delay 50
    @key '/', 'command'

  'editor:extend-selection-to-line-number': (input) ->
    @runAtomCommand 'extendSelectionToLine', input, true

  'editor:insert-from-line-number': (input) ->
    if input?
      @runAtomCommand 'insertContentFromLine', input, true

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
      , true

pack.implement
  'object:refresh': ->
    @key 'L', 'control option command'


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
      @runAtomCommand 'trigger', 'project-manager:list-projects', true
  'jump-to-symbol.dialogue':
    spoken: 'jumpy'
    description: 'Open jump-to-symbol dialogue'
    action: ->
      @runAtomCommand 'trigger', 'symbols-view:toggle-file-symbols', true
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
