{Point, Emitter, TextEditor} = require 'atom'
{View, TextEditorView} = require 'atom-space-pen-views'

# command = 'duplicate-line-or-selection:duplicate'
# command = 'duplicate-line-or-selection:duplicate'
# command = 'tree-view:add-file'
# console.dir $('atom-workspace atom-text-editor.is-focused')[0].dispatchEvent(new CustomEvent(command, {bubbles: true, cancelable: true}))
# console.dir $('.tree-view')[0].dispatchEvent(new CustomEvent(command, {bubbles: true, cancelable: true}))
# option command I


# var keyboardEvent = document.createEvent("KeyboardEvent");
# var initMethod = typeof keyboardEvent.initKeyboardEvent !== 'undefined' ? "initKeyboardEvent" : "initKeyEvent";
#
#
# keyboardEvent[initMethod](
#                    "keydown", // event type : keydown, keyup, keypress
#                     true, // bubbles
#                     true, // cancelable
#                     window, // viewArg: should be window
#                     false, // ctrlKeyArg
#                     false, // altKeyArg
#                     false, // shiftKeyArg
#                     false, // metaKeyArg
#                     40, // keyCodeArg : unsigned long the virtual key code, else 0
#                     0 // charCodeArgs : unsigned long the Unicode character associated with the depressed key, else 0
# );
# document.dispatchEvent(keyboardEvent);
# option = shift = meta = control = false
# key = 13
# keyboardEvent = document.createEvent('Event')
# keyboardEvent.type = 'keydown'
# keyboardEvent.initEvent 'keydown', true, true#, window, control, option, shift, meta, key, 0
# keyboardEvent.which = key
# keyboardEvent.keyCode = key
# keyboardEvent.keyIdentifier = key
#
# document.dispatchEvent keyboardEvent

# {buildKeydownEvent} = require('atom-keymap')


# buildKeydownEvent 'ctrl-a'
# atom.keymaps.handleKeyboardEvent atom.keymaps.constructor.buildKeydownEvent 'cmd-a', target: document.body
# console.log JSON.stringify atom.keymaps.constructor.buildKeydownEvent.toString()
methods =  {
    # console.log @_editor()
    # console.log atom.views.getView(@_editor())
    # @disposables.push atom.workspace.observeActivePaneItem (item) ->
    #   console.log item
    # @emitter = new Emitter()
    # @disposables.push atom.workspace.observeTextEditors (editor) ->
    #   domElement = atom.views.getView(editor)
    #   $(domElement).on 'focus', -> console.log editor
    #   $(domElement).on 'blur', -> console.log editor

    # setInterval ->
    #   console.log atom.workspace.getActivePane()
    # , 1000
    # _.all atom.workspace.getBottomPanels(), (p) ->
    #   @disposable.push p.emitter.on 'did-change-visible', ->
    #     console.log arguments
    # old = Emitter::emit
    # Emitter::emit = ->
    #   unless arguments[0] is 'did-update-state'
    #     console.log _.toArray arguments
    #   old.apply @, arguments
    # console.log atom.views.providers.length
    # atom.views.providers.forEach (provider) ->
    #   if provider.modelConstructor.toString().indexOf('function TextEditor') isnt -1
    #     console.log provider
    # @disposables.push atom.workspace.observePanes (pane) =>
      # console.log pane.items
    # atom.views.views.forEach ->
    #   console.log arguments
    #   if instance instanceof TextEditor
    #     console.log instance
    #     $(domElement).on 'focus', -> console.log instance
    #     $(domElement).on 'blur', -> console.log instance

  cleanup: ->
    _.all @disposables, (disposable) ->
      disposable.dispose()

  _editor: ->
    global.voicecode.currentEditor()
    # the method below does not work on mini editors
    # atom.workspace.getActiveTextEditor()
  _afterRange: (selection, editor) ->
    [selection.getBufferRange().end, editor.getEofBufferPosition()]
  _beforeRange: (selection) ->
    [0, selection.getBufferRange().start]
  _pointAfter: (pt) ->
    new Point(pt.row, pt.column + 1)
  _pointBefore: (pt) ->
    new Point(pt.row, pt.column - 1)
  _searchEscape: (expression) ->
    expression.replace(/[\-\[\]\/\{\}\(\)\*\+\?\.\\\^\$\|]/g, "\\$&")

  redo: (params, callback = null) ->
    @_editor().redo()
    callback null, true

  undo: (params, callback = null) ->
    @_editor().undo()
    callback null, true

  editorNewLine: (params, callback = null)->
    @_editor().insertNewline()
    callback null, true

  editorInsertText: (string, callback = null) ->
    editor = @_editor()
    if not editor?
      callback 'NO EDITOR'
    else
      editor.insertText string
      callback null, true

  deleteWordBackward: (times = 1, callback) ->
    editor = @_editor()
    _.times times, editor.deleteToBeginningOfWord()
    callback null, true

  deleteWordForward: (times = 1, callback) ->
    editor = @_editor()
    _.times times, editor.deleteToEndOfWord()
    callback null, true

  deleteToBeginningOfLine: (params, callback) ->
    editor = @_editor()
    editor.deleteToBeginningOfLine()
    callback null, true

  deleteToEndOfLine: (params, callback )->
    editor = @_editor()
    editor.deleteToEndOfLine()
    callback null, true

  moveToEndOfLine: (params, callback) ->
    editor = @_editor()
    editor.moveToEndOfLine()
    callback null, true

  newLineAbove: (params, callback) ->
    editor = @_editor()
    if not editor?
      callback 'NO EDITOR'
    else
      editor.insertNewlineAbove()
      callback null, true

  newLineBelow: (params, callback) ->
    editor = @_editor()
    if not editor?
      callback 'NO EDITOR'
    else
      editor.insertNewlineBelow()
      callback null, true

  deleteBackward: (times, callback) ->
    editor = @_editor()
    if not editor?
      callback 'NO EDITOR'
    else
      editor.backspace()
      callback null, true
  deleteForward: (times, callback) ->
    editor = @_editor()
    if not editor?
      callback 'NO EDITOR'
    else
      editor.delete()
      callback null, true
  trigger: ({command, selector}, callback) ->
    # atom.views.getView(atom.workspace).dispatchEvent(new CustomEvent(command, {bubbles: true, cancelable: true}))
    $(selector)[0].dispatchEvent(new CustomEvent(command, {bubbles: true, cancelable: true}))
    callback null, true
  goToLine: (line, callback) ->
    position = new Point(line - 1, 0)
    editor = @_editor()
    if not editor?
      callback 'NO EDITOR'
    editor.scrollToBufferPosition(position)
    editor.setCursorBufferPosition(position)
    editor.moveToFirstCharacterOfLine()
    callback null, true
  selectLineRange: (options, callback) ->
    from = new Point(options.from - 1, 0)
    to = new Point(options.to, 0)
    editor = @_editor()
    return unless editor
    editor.setSelectedBufferRange([from, to])
    callback null, true
  extendSelectionToLine: (line, callback) ->
    line = line - 1
    editor = @_editor()
    return unless editor
    current = editor.getSelections()[0].getBufferRange()
    range = if line < current.start.row
      [new Point(line, 0), current.end]
    else if line > current.end.row
      [current.start, new Point(line + 1, 0)]
    else if line is current.start.row or line is current.end.row
      # nothing
    else
      topHeight = line - current.start.row
      bottomHeight = current.end.row - line
      if topHeight > bottomHeight
        [new Point(line, 0), current.end]
      else
        [current.start, new Point(line + 1, 0)]
    if range?
      editor.setSelectedBufferRange(range)
  selectNextWord: (distance, callback) ->
    editor = @_editor()
    return unless editor
    for selection in editor.getSelections()
      index = 0
      found = null
      range = @_afterRange(selection, editor)
      editor.scanInBufferRange /[\w]+/g, range, (result) ->
        if result.match
          found = result
          if index++ is (distance - 1)
            result.stop()
      if found?
        selection.setBufferRange([found.range.start, found.range.end])
    editor.mergeCursors() # undocumented
    callback null, true
  selectPreviousWord: (distance, callback) ->
    editor = @_editor()
    return unless editor
    for selection in editor.getSelections()
      index = 0
      found = null
      range = @_beforeRange(selection)
      editor.backwardsScanInBufferRange /[\w]+/g, range, (result) ->
        if result.match
          found = result
          if index++ is (distance - 1)
            result.stop()
      if found?
        selection.setBufferRange([found.range.start, found.range.end])
    editor.mergeCursors() # undocumented
    callback null, true
  ###
  options.value => search term
  options.distance => preferred match index
  ###
  selectNextOccurrence: (options, callback) ->
    editor = @_editor()
    return unless editor
    found = null
    if options.value is null
      options.value = editor.selections[0].getText()
      if options.value is ''
        callback 'nothing selected'
        return false
    for selection in editor.getSelections()
      index = 0
      range = @_afterRange(selection, editor)
      editor.scanInBufferRange new RegExp(@_searchEscape(options.value), "ig"), range, (result) ->
        if result.match
          found = result
          if index++ is (options.distance - 1)
            result.stop()
      if found?
        selection.setBufferRange([found.range.start, found.range.end])
      else
        callback 'wordNotFound'
    editor.mergeCursors() # undocumented
    callback null, true
  ###
  options.value => search term
  options.distance => preferred match index
  ###
  selectPreviousOccurrence: (options, callback) ->
    editor = @_editor()
    return unless editor
    found = null
    if options.value is null
      options.value = editor.selections[0].getText()
      if options.value is ''
        callback 'nothing selected'
        return false
    for selection in editor.getSelections()
      index = 0
      range = @_beforeRange(selection)
      editor.backwardsScanInBufferRange new RegExp(@_searchEscape(options.value), "ig"), range, (result) ->
        if result.match
          found = result
          if index++ is (options.distance - 1)
            result.stop()
      if found?
        selection.setBufferRange([found.range.start, found.range.end])
      else
        callback 'wordNotFound'
    editor.mergeCursors() # undocumented
    callback null, true

  ###
  options.value => search term
  options.distance => preferred match index
  ###
  selectToNextOccurrence: (options, callback) ->
    editor = @_editor()
    return unless editor
    for selection, index in editor.getSelections()
      found = null
      index = 0
      range = @_afterRange(selection, editor)
      editor.scanInBufferRange new RegExp(@_searchEscape(options.value), "ig"), range, (result) ->
        console.log result: result
        if result.match
          found = result
          if index++ is (options.distance - 1)
            result.stop()
      if found?
        selection.setBufferRange([selection.getBufferRange().start, found.range.end])
      else
        callback 'wordNotFound'
      callback null, true

  ###
  options.value => search term
  options.distance => preferred match index
  ###
 selectToPreviousOccurrence: (options, callback) ->
    editor = @_editor()
    return unless editor
    for selection in editor.getSelections()
      found = null
      index = 0
      range = @_beforeRange(selection, editor)
      editor.backwardsScanInBufferRange new RegExp(@_searchEscape(options.value), "ig"), range, (result) ->
        if result.match
          found = result
          if index++ is (options.distance - 1)
            result.stop()
      if found?
        selection.setBufferRange([found.range.start, selection.getBufferRange().end])
      else
        callback 'wordNotFound'
      callback null, true
  selectSurroundedOccurrence: (options, callback) ->
    expression = options.expression
    return unless expression.length
    direction = options.direction
    distance = (options.distance or 1) - 1

    first = expression[0]
    last = expression[expression.length - 1]
    find = new RegExp("(^|\\W)#{first}[\\w]+#{last}($|\\W)", "ig")
    editor = @_editor()
    return unless editor
    console.log
      first: first
      last: last
      find: find

    for selection in editor.getSelections()
      found = null
      index = 0
      if direction is 1
        range = @_afterRange(selection, editor)
        editor.scanInBufferRange find, range, (result) ->
          if result.match
            found = result
            if index++ is (options.distance - 1)
              result.stop()
      else
        range = @_beforeRange(selection)
        editor.backwardsScanInBufferRange find, range, (result) ->
          if result.match
            found = result
            if index++ is (options.distance - 1)
              result.stop()
      if found?
        selection.setBufferRange([@_pointAfter(found.range.start), @_pointBefore(found.range.end)])
      else
        callback 'wordNotFound'
      callback null, true

  # case transforms
  transformSelectedText: (transform, callback) ->
    transformer = new Transformer()
    editor = @_editor()
    return unless editor
    editor.mutateSelectedText (selection) ->
      text = selection.getText()
      transformed = transformer[transform](text)
      selection.delete()
      selection.insertText(transformed)
      callback null, true
  insertContentFromLine: (line, callback) ->
    editor = @_editor()
    return unless editor
    return unless line
    content = editor.getBuffer().lines[line - 1]?.trim()
    editor.insertText(content)
    callback null, true
}

class Transformer
  hasSpace = /\s/
  hasSeparator = /[\W_]/
  separatorSplitter = /[\W_]+(.|$)/g
  camelSplitter = /(.)([A-Z]+)/g
  minors = [
    'a'
    'an'
    'and'
    'as'
    'at'
    'but'
    'by'
    'en'
    'for'
    'from'
    'how'
    'if'
    'in'
    'neither'
    'nor'
    'of'
    'on'
    'only'
    'onto'
    'out'
    'or'
    'per'
    'so'
    'than'
    'that'
    'the'
    'to'
    'until'
    'up'
    'upon'
    'v'
    'v.'
    'versus'
    'vs'
    'vs.'
    'via'
    'when'
    'with'
    'without'
    'yet'
  ]

  unseparate: (string) ->
    string.replace separatorSplitter, (m, next) ->
      if next then ' ' + next else ''

  uncamelize: (string) ->
    string.replace camelSplitter, (m, previous, uppers) ->
      previous + ' ' + uppers.toLowerCase().split('').join(' ')

  toNoCase: (string) ->
    if hasSpace.test(string)
      return string.toLowerCase()
    if hasSeparator.test(string)
      return (@unseparate(string) or string).toLowerCase()
    @uncamelize(string).toLowerCase()

  identity: (string) ->
    @toNoCase(string).replace /[\W_]+(.|$)/g, (matches, match) ->
      if match then ' ' + match else ''

  snake: (string) ->
    @identity(string).replace /\s/g, '_'

  camel: (string) ->
    @identity(string).replace /\s(\w)/g, (matches, letter) ->
      letter.toUpperCase()

  toDotCase: (string) ->
    @identity(string).replace /\s/g, '.'

  toConstantCase: (string) ->
    @snake(string).toUpperCase()

  titleFirstSentance: (string) ->
    @toNoCase(string).replace /[a-z]/i, (letter) ->
      letter.toUpperCase()

  spine: (string) ->
    @identity(string).replace /\s/g, '-'

  capital: (string) ->
    @toNoCase(string).replace /(^|\s)(\w)/g, (matches, previous, letter) ->
      previous + letter.toUpperCase()

  stud: (string) ->
    @identity(string).replace /(?:^|\s)(\w)/g, (matches, letter) ->
      letter.toUpperCase()

  upperCase: (string) ->
    @identity(string).toUpperCase()

  lowerSlam: (string) ->
    @identity(string).replace /\s/g, ''

  upperSlam: (string) ->
    @identity(string).replace(/\s/g, '').toUpperCase()

  upperSnake: (string) ->
    @snake(string).toUpperCase()

  upperSpine: (string) ->
    @spine(string).toUpperCase()

  titleSentance: (string) ->
    escape = (str) ->
      String(str).replace /([.*+?=^!:${}()|[\]\/\\])/g, '\\$1'
    escaped = minors.map(escape)
    minorMatcher = new RegExp('[^^]\\b(' + escaped.join('|') + ')\\b', 'ig')
    colonMatcher = /:\s*(\w)/g
    @capital(string).replace(minorMatcher, (minor) ->
      minor.toLowerCase()
    ).replace colonMatcher, (letter) ->
      letter.toUpperCase()

return methods
