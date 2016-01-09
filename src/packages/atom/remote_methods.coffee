{Point, Emitter, TextEditor} = require 'atom'
{View, TextEditorView} = require 'atom-space-pen-views'
return new class RemoteMethods
  constructor: ->
    @disposables = []
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
  editorNewLine: ->
    @_editor().insertNewline()
  editorInsertText: (string) ->
    @_editor().insertText string
  _editor: ->
    @__editor or null
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

  trigger: (command) ->
    atom.views.getView(atom.workspace).dispatchEvent(new CustomEvent(command, {bubbles: true, cancelable: true}))

  goToLine: (line) ->
    position = new Point(line - 1, 0)
    editor = @_editor()
    editor.scrollToBufferPosition(position)
    editor.setCursorBufferPosition(position)
    editor.moveToFirstCharacterOfLine()

  selectLineRange: (options) ->
    from = new Point(options.from - 1, 0)
    to = new Point(options.to, 0)
    editor = @_editor()
    return unless editor
    editor.setSelectedBufferRange([from, to])

  extendSelectionToLine: (line) ->
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

  selectNextWord: (distance) ->
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

  selectPreviousWord: (distance) ->
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

  ###
  options.value => search term
  options.distance => preferred match index
  ###
  selectNextOccurrence: (options) ->
    editor = @_editor()
    return unless editor
    found = null
    if options.value is null
      options.value = editor.selections[0].getText()
      return if options.value is ''
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
    editor.mergeCursors() # undocumented

  ###
  options.value => search term
  options.distance => preferred match index
  ###
  selectPreviousOccurrence: (options) ->
    editor = @_editor()
    return unless editor
    found = null
    if options.value is null
      options.value = editor.selections[0].getText()
      return if options.value is ''
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
    editor.mergeCursors() # undocumented

  ###
  options.value => search term
  options.distance => preferred match index
  ###
  selectToNextOccurrence: (options) ->
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

  ###
  options.value => search term
  options.distance => preferred match index
  ###
  selectToPreviousOccurrence: (options) ->
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

  selectSurroundedOccurrence: (options) ->
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

  # case transforms

  transformSelectedText: (transform) ->
    transformer = new Transformer()
    editor = @_editor()
    return unless editor
    editor.mutateSelectedText (selection) ->
      text = selection.getText()
      transformed = transformer[transform](text)
      selection.delete()
      selection.insertText(transformed)

  insertContentFromLine: (line) ->
    editor = @_editor()
    return unless editor
    return unless line
    content = editor.getBuffer().lines[line - 1]?.trim()
    editor.insertText(content)
