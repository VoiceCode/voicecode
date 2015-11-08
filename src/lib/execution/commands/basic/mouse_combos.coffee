Commands.createDisabled
  'combo.selectLineUnderMouse':
    spoken: 'chibble'
    description: 'selects the entire line of text cursor hovers over'
    tags: ['mouse', 'combo', 'recommended']
    mouseLatency: true
    action: (input, context) ->
      @do 'mouse.click', input, context
      @key 'Left', 'command'
      @key 'Right', 'command shift'
  'combo.double-clickThenCopy':
    spoken: 'dookoosh'
    grammarType: 'oneArgument'
    description: 'mouse double click, then copy'
    tags: ['mouse', 'combo', 'recommended', 'clipboard']
    mouseLatency: true
    inputRequired: false
    action: (input, context) ->
      @do 'mouse.double-click', input, context
      @do 'clipboard.copy', input
  'combo.double-clickThenPaste':
    spoken: 'doopark'
    grammarType: 'oneArgument'
    description: 'mouse double click, then paste'
    tags: ['mouse', 'combo', 'clipboard']
    inputRequired: false
    mouseLatency: true
    action: (input, context) ->
      @do 'mouse.double-click', input, context
      @do 'clipboard.paste', input
  'combo.mouseClickThenPaste':
    spoken: 'chiffpark'
    grammarType: 'oneArgument'
    description: 'mouse single click, then paste'
    tags: ['mouse', 'combo', 'recommended', 'clipboard']
    mouseLatency: true
    action: (input, context) ->
      @do 'mouse.click', input, context
      @do 'clipboard.paste', input
  'combo.selectLineThenCopy':
    spoken: 'shackloosh'
    grammarType: 'oneArgument'
    description: 'select entire line, then copy'
    tags: ['selection', 'combo', 'clipboard']
    inputRequired: false
    action: (input) ->
      @do 'select.all.lineText'
      @do 'clipboard.copy', input
  'combo.selectLineThenPaste':
    spoken: 'shacklark'
    grammarType: 'oneArgument'
    description: 'select entire line, then paste'
    tags: ['selection', 'combo', 'clipboard']
    inputRequired: false
    action: (input) ->
      @do 'select.all.lineText'
      @do 'clipboard.paste', input
  'combo.selectLineUnderMouseThenCopy':
    spoken: 'chibloosh'
    grammarType: 'oneArgument'
    description: 'select entire line under mouse, then copy'
    tags: ['selection', 'mouse', 'combo', 'clipboard']
    mouseLatency: true
    inputRequired: false
    action: (input, context) ->
      @do 'combo.selectLineUnderMouse', input, context
      @do 'clipboard.copy', input
  'combo.selectLineUnderMousesAndPaste':
    spoken: 'chiblark'
    grammarType: 'oneArgument'
    description: 'select entire line, then paste'
    tags: ['selection', 'combo', 'clipboard']
    mouseLatency: true
    inputRequired: false
    action: (input, context) ->
      @do 'combo.selectLineUnderMouse', input, context
      @do 'clipboard.paste', input
  'combo.clickThenInsertNewLineBelow':
    spoken: 'chiffacoon'
    description: 'click, then insert new line below'
    tags: ['mouse', 'combo']
    mouseLatency: true
    action: (input, context) ->
      @do 'mouse.click', input, context
      @do 'common.newLineBelow'
  'combo.clickThenSpace':
    spoken: 'chiffkoosh'
    description: 'click, then insert a space'
    tags: ['mouse', 'combo', 'space']
    mouseLatency: true
    action: (input, context) ->
      @do 'mouse.click', input, context
      @do 'common.space'
  'combo.clickThenDeleteLine':
    spoken: 'sappy'
    misspellings: ['sapi']
    description: 'click, then delete entire line'
    tags: ['mouse', 'combo']
    mouseLatency: true
    action: (input, context) ->
      @do 'mouse.click', input, context
      @do 'delete.all.line'
  'combo.clickThenDeleteLineRight':
    spoken: 'sapper'
    description: 'click, then delete line to the right'
    tags: ['mouse', 'combo']
    mouseLatency: true
    action: (input, context) ->
      @do 'mouse.click', input, context
      @do 'delete.all.right'
  'combo.clickThenDeleteLineLeft':
    spoken: 'sapple'
    description: 'click, then delete line to the left'
    tags: ['mouse', 'combo']
    mouseLatency: true
    action: (input, context) ->
      @do 'mouse.click', input, context
      @do 'delete.all.left'
  # RENAMING ALERT
  'combo.copyUnderMouseAndInsertAtCursor':
    spoken: 'grabsy'
    description: 'Will grab the text underneath the mouse,
    then insert it at the current cursor location.
    Only supports a few applications for now but will be expanded.'
    tags: ['mouse', 'combo', 'clipboard']
    action: () ->
      null
