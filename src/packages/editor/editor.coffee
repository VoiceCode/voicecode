pack = Packages.register
  name: 'editor'
  description: 'Common commands for editors/IDEs'
  context: 'abstract'

pack.commands
  'move-to-line-number':
    spoken: 'spring'
    grammarType: 'integerCapture'
    description: 'go to line number.'
    tags: ['cursor']
    inputRequired: false

  'combo.move-to-line-number-and-way-right':
    spoken: 'sprinkler'
    grammarType: 'integerCapture'
    description: 'go to line number then position cursor at end of line.'
    tags: ['cursor']
    inputRequired: false
    requires: [
      'editor.move-to-line-number'
      'select.way.right'
    ]
    action: (input) ->
      @do 'editor.move-to-line-number', input
      if input?
        @do 'select.way.right'

  'combo.move-to-line-number-and-way-left':
    spoken: 'sprinkle'
    grammarType: 'integerCapture'
    description: 'Go to line number then position cursor at beginning of line.'
    tags: ['selection', 'IDE', 'cursor']
    inputRequired: false
    requires: [
      'editor.move-to-line-number'
      'cursor.way.left'
    ]
    action: (input) ->
      @do 'editor.move-to-line-number', input
      if input?
        @do 'cursor.way.left'

  'combo.insert-under-line-number':
    spoken: 'sprinkoon'
    grammarType: 'integerCapture'
    description: 'Go to line number then insert a new line below.'
    tags: ['selection', 'IDE', 'cursor']
    inputRequired: false
    requires: [
      'editor.move-to-line-number'
      'common.newLineBelow'
    ]
    action: (input) ->
      @do 'editor.move-to-line-number', input
      if input?
        @do 'common.newLineBelow'

  'combo.move-to-line-number-then-select-line':
    spoken: 'spackle'
    grammarType: 'integerCapture'
    description: 'Go to line number then select entire line.'
    tags: ['selection', 'IDE', 'cursor']
    inputRequired: false
    requires: [
      'editor.move-to-line-number'
      'select.line.text'
    ]
    action: (input) ->
      @do 'editor.move-to-line-number', input
      if input?
        @do 'select.line.text'

  'expand-selection-to-scope':
    spoken: 'bracken'
    description: 'Expand selection to quotes, parens, braces, or brackets.'
    tags: ['selection', 'IDE']

  'select-line-number-range':
    spoken: 'selrang'
    grammarType: 'integerCapture'
    description: 'Selects text in a line range: selrang ten twenty.'
    tags: ['selection', 'IDE']
    inputRequired: true

  'extend-selection-to-line-number':
    spoken: 'seltil'
    grammarType: 'integerCapture'
    description: 'selects text from current position through spoken line number: seltil five five.'
    tags: ['selection', 'IDE']
    inputRequired: true

  'insert-from-line-number':
    spoken: 'clonesert'
    grammarType: 'integerCapture'
    description: 'Insert the text from another line at the current cursor position'
    tags: ['atom']
    inputRequired: true

  'toggle-comments':
    spoken: 'trundle'
    grammarType: 'numberRange'
    tags: ['IDE']
    description: 'Toggle comments on the line or range'
    inputRequired: false
