pack = Packages.register
  name: 'mouse-combo'
  description: 'Combinations of mouse actions and other actions'

pack.commands
  'select-hovered-line':
    spoken: 'chibble'
    description: 'selects the entire line of text cursor hovers over'
    tags: ['mouse', 'combo', 'recommended']
    mouseLatency: true
    action: (input, context) ->
      @do 'mouse:click', input, context
      @key 'Left', 'command'
      @key 'Right', 'command shift'
  'double-click+copy':
    spoken: 'dookoosh'
    grammarType: 'oneArgument'
    description: 'mouse double click, then copy'
    tags: ['mouse', 'combo', 'recommended', 'clipboard']
    mouseLatency: true
    action: (input, context) ->
      @do 'mouse:double-click', input, context
      @do 'clipboard:copy', input
  'double-click+paste':
    spoken: 'doopark'
    grammarType: 'oneArgument'
    description: 'mouse double click, then paste'
    tags: ['mouse', 'combo', 'clipboard']
    mouseLatency: true
    action: (input, context) ->
      @do 'mouse:double-click', input, context
      @do 'clipboard:paste', input
  'click+paste':
    spoken: 'chiffpark'
    grammarType: 'oneArgument'
    description: 'mouse single click, then paste'
    tags: ['mouse', 'combo', 'recommended', 'clipboard']
    mouseLatency: true
    action: (input, context) ->
      @do 'mouse:click', input, context
      @do 'clipboard:paste', input
  'select-line+copy':
    spoken: 'shackloosh'
    grammarType: 'oneArgument'
    description: 'select entire line, then copy'
    tags: ['selection', 'combo', 'clipboard']
    action: (input) ->
      @do 'select.line.text'
      @do 'clipboard:copy', input
  'select-line+paste':
    spoken: 'shacklark'
    grammarType: 'oneArgument'
    description: 'select entire line, then paste'
    tags: ['selection', 'combo', 'clipboard']
    action: (input) ->
      @do 'select.line.text'
      @do 'clipboard:paste', input
  'select-hovered-line+copy':
    spoken: 'chibloosh'
    grammarType: 'oneArgument'
    description: 'select entire line under mouse, then copy'
    tags: ['selection', 'mouse', 'combo', 'clipboard']
    mouseLatency: true
    action: (input, context) ->
      @do 'selectLineUnderMouse', input, context
      @do 'clipboard:copy', input
  'select-hovered-line+paste':
    spoken: 'chiblark'
    grammarType: 'oneArgument'
    description: 'select entire line, then paste'
    tags: ['selection', 'combo', 'clipboard']
    mouseLatency: true
    action: (input, context) ->
      @do 'selectLineUnderMouse', input, context
      @do 'clipboard:paste', input
  'click+insert-below':
    spoken: 'chiffacoon'
    description: 'click, then insert new line below'
    tags: ['mouse', 'combo']
    mouseLatency: true
    action: (input, context) ->
      @do 'mouse:click', input, context
      @do 'common:newLineBelow'
  'click+space':
    spoken: 'chiffkoosh'
    description: 'click, then insert a space'
    tags: ['mouse', 'combo', 'space']
    mouseLatency: true
    action: (input, context) ->
      @do 'mouse:click', input, context
      @do 'symbols:space'
  'click+delete-line':
    spoken: 'sappy'
    misspellings: ['sapi']
    description: 'click, then delete entire line'
    tags: ['mouse', 'combo']
    mouseLatency: true
    action: (input, context) ->
      @do 'mouse:click', input, context
      @do 'delete.all.line'
  'click+delete-line-right':
    spoken: 'sapper'
    description: 'click, then delete line to the right'
    tags: ['mouse', 'combo']
    mouseLatency: true
    action: (input, context) ->
      @do 'mouse:click', input, context
      @do 'delete.all.right'
  'click+delete-line-left':
    spoken: 'sapple'
    description: 'click, then delete line to the left'
    tags: ['mouse', 'combo']
    mouseLatency: true
    action: (input, context) ->
      @do 'mouse:click', input, context
      @do 'delete.all.left'
  'insert-hovered':
    spoken: 'grabsy'
    scope: 'abstract'
    description: 'Will grab the text underneath the mouse,
    then insert it at the current cursor location.
    Only supports a few applications for now but will be expanded.'
    tags: ['mouse', 'combo', 'clipboard']
