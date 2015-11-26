pack = Packages.register
  name: 'symbols'
  description: 'Main symbols and symbol combos'

pack.commands
  tags: ['recommended']
,
  'dot':
    spoken: 'dot'
    findable: '.'
    misspellings: ['.']
    spaceBefore: true
    action: ->
      @string '.'
  'star':
    spoken: 'star'
    misspellings: ['*']
    findable: '*'
    spaceBefore: true
    action: ->
      @string '*'
  'slash':
    spoken: 'slash'
    misspellings: ['/']
    findable: '/'
    spaceBefore: true
    action: ->
      @string '/'
  'backslash':
    spoken: 'shalls'
    # misspellings: ['\\']
    description: "backslash. hint: 'shalls' is 'slash' backward."
    findable: '\\'
    action: ->
      @string '\\'
  'comma':
    spoken: 'comma'
    misspellings: [',']
    findable: ','
    action: ->
      @string ','
  'tilde':
    spoken: 'tilde'
    misspellings: ['~']
    findable: '~'
    spaceBefore: true
    action: ->
      @string '~'
  'colon':
    spoken: 'colon'
    misspellings: [':']
    findable: ':'
    spaceBefore: true
    action: ->
      @string ':'
  'equal':
    spoken: 'smaqual'
    findable: '='
    action: ->
      @string '='
  'equal.padded':
    spoken: 'equeft'
    findable: ' = '
    action: ->
      @string ' = '
  'equal+surround-double-quotes':
    spoken: 'quall coif'
    tags: ['symbol', 'quotes', 'recommended']
    findable: '="'
    action: ->
      @string '=""'
      @left()
  'equal+surround-single-quotes':
    spoken: 'quall posh'
    findable: "='"
    tags: ['symbol', 'quotes', 'recommended']
    action: ->
      @string "=''"
      @left()
  'surround-parentheses+surround-quotes':
    spoken: 'prex coif'
    description: 'inserts parentheses then double quotes leaving cursor inside them. If text is selected, will wrap the selected text'
    tags: ['symbol', 'quotes', 'recommended']
    action: ->
      if @canDetermineSelections() and @isTextSelected()
        t = @getSelectedText()
        @string('("' + t + '")')
      else
        @string '("")'
        @left()
        @left()
  'surround-parentheses':
    spoken: 'prex'
    description: 'inserts parentheses leaving cursor inside them. If text is selected, will wrap the selected text'
    findable: '()'
    spaceBefore: true
    action: ->
      if @canDetermineSelections() and @isTextSelected()
        t = @getSelectedText()
        @string("(#{t})")
      else
        @string '()'
        @left()
  'parentheses':
    spoken: 'prekris'
    action: ->
      @string '()'
  'brackets':
    spoken: 'brax'
    description: 'inserts brackets leaving cursor inside them. If text is selected, will wrap the selected text'
    findable: '[]'
    spaceBefore: true
    action: ->
      if @canDetermineSelections() and @isTextSelected()
        t = @getSelectedText()
        @string("[#{t}]")
      else
        @string '[]'
        @left()
  'left-brace':
    spoken: 'kirksorp'
    findable: '{'
    action: ->
      @string '{'
  'right-brace':
    spoken: 'kirkos'
    findable: '}'
    action: ->
      @string '}'
  'surround-braces':
    spoken: 'kirk'
    findable: '{}'
    spaceBefore: true
    action: ->
      @string '{}'
      @left()
  'surround-braces-block':
    spoken: 'kirblock'
    action: ->
      @string '{}'
      @left()
      @enter()
  'surround-spaces':
    spoken: 'prank'
    description: 'inserts 2 spaces leaving cursor in the middle. If text is selected, will wrap the selected text in spaces'
    findable: '  '
    action: ->
      if @canDetermineSelections() and @isTextSelected()
        t = @getSelectedText()
        @string(" #{t} ")
      else
        @string '  '
        @left()
  'minus-equal.padded':
    spoken: 'minquall'
    findable: ' -= '
    action: ->
      @string ' -= '
  'plusEqual.padded':
    spoken: 'pluqual'
    findable: ' += '
    action: ->
      @string ' += '
  'not-equal.padded':
    spoken: 'banquall'
    findable: ' != '
    action: ->
      @string ' != '
  'is-equal.padded':
    spoken: 'longqual'
    findable: ' == '
    action: ->
      @string ' == '
  'less-equal.padded':
    spoken: 'lessqual'
    findable: ' <= '
    action: ->
      @string ' <= '
  'more-equal.padded':
    spoken: 'grayqual'
    findable: ' >= '
    action: ->
      @string ' >= '
  'surround-single-quotes':
    spoken: 'posh'
    tags: ['symbol', 'quotes', 'recommended']
    misspellings: ['pash']
    spaceBefore: true
    findable: "''"
    action: ->
      @string "''"
      @left()
  'surround-double-quotes':
    spoken: 'coif'
    tags: ['symbol', 'quotes', 'recommended']
    misspellings: ['coiffed']
    description: 'inserts quotes leaving cursor inside them. If text is selected, will wrap the selected text'
    findable: '""'
    spaceBefore: true
    action: ->
      if @canDetermineSelections() and @isTextSelected()
        t = @getSelectedText()
        @string("\"#{t}\"")
      else
        @string '""'
        @left()
  'double-right-arrow.padded':
    spoken: 'shrocket'
    findable: ' => '
    action: ->
      @string ' => '
  'comma.padded-right':
    spoken: 'swipe'
    misspellings: ['swiped', 'swipes']
    findable: ', '
    action: ->
      @string ', '
  'colon.padded-right':
    spoken: 'coalgap'
    findable: ': '
    action: ->
      @string ': '
  'colon+enter':
    spoken: 'coalshock'
    findable: ':\r'
    action: ->
      @key ':'
      @enter()
  'slash.padded':
    spoken: 'divy'
    findable: ' / '
    action: ->
      @string ' / '
  'move-way-right+semicolon':
    spoken: 'sinker'
    findable: ';'
    action: ->
      @key 'right', 'command'
      @key ';'
  'semicolon+enter':
    spoken: 'sunkshock'
    misspellings: ['sinkshock'] #TODO remove later
    action: ->
      @key ';'
      @key 'return'
  'semicolon':
    spoken: 'sunk'
    misspellings: ['stunk']
    findable: ';'
    action: ->
      @key ';'
  'exclamation':
    spoken: 'clamor'
    misspellings: ['clamber', 'clamour']
    findable: '!'
    action: ->
      @key '!'
  'at':
    spoken: 'loco'
    misspellings: ['@']
    findable: '@'
    spaceBefore: true
    action: ->
      @string '@'
  'ampersand':
    spoken: 'amper'
    findable: '&'
    action: ->
      @string '&'
  'ampersand.padded':
    spoken: 'damper'
    findable: ' & '
    action: ->
      @string ' & '
  'pound':
    spoken: 'pounder'
    findable: '#'
    repeatable: true
    spaceBefore: true
    action: ->
      @string '#'
  'question-mark':
    spoken: 'questo'
    findable: '?'
    misspellings: ["?"]
    action: ->
      @string '?'
  'vertical-bar.twice':
    spoken: 'bartrap'
    findable: '||'
    action: ->
      @string '||'
      @left()
  'vertical-bar.twice.padded':
    spoken: 'goalpost'
    findable: ' || '
    action: ->
      @string ' || '
  'or-equal.padded':
    spoken: 'orquals'
    findable: ' ||= '
    action: ->
      @string ' ||= '
  'vertical-bar':
    spoken: 'spike'
    findable: '|'
    action: ->
      @string '|'
  'surround-angles':
    spoken: 'angler'
    description: 'inserts angle brackets leaving cursor inside them. If text is selected, will wrap the selected text'
    findable: '<>'
    action: ->
      if @canDetermineSelections() and @isTextSelected()
        t = @getSelectedText()
        @string("<#{t}>")
      else
        @string '<>'
        @left()
  'plus':
    spoken: 'plus'
    findable: '+'
    spaceBefore: true
    action: ->
      @string '+'
  'plus.padded':
    spoken: 'deplush'
    findable: ' + '
    action: ->
      @string ' + '
  'minus':
    spoken: 'minus'
    tags: ['symbol', 'minus', 'recommended']
    misspellings: ['minas']
    repeatable: true
    findable: '-'
    spaceBefore: true
    action: ->
      @string '-'
  'minus.padded':
    spoken: 'deminus'
    tags: ['symbol', 'minus', 'recommended']
    findable: ' - '
    action: ->
      @string ' - '
  'single-right-arrow':
    spoken: 'lambo'
    misspellings: ['limbo']
    findable: '->'
    spaceBefore: true
    action: ->
      @string '->'
  'double-quote':
    spoken: 'quatches'
    tags: ['symbol', 'quotes', 'recommended']
    findable: '"'
    action: ->
      @string '"'
  'single-quote':
    spoken: 'quatchet'
    tags: ['symbol', 'quotes', 'recommended']
    findable: "'"
    action: ->
      @string "'"
  'percent':
    spoken: 'percy'
    findable: '%'
    spaceBefore: true
    action: ->
      @string '%'
  'percent.padded':
    spoken: 'depercy'
    findable: ' % '
    action: ->
      @string ' % '
  'dollar':
    spoken: 'dolly'
    misspellings: ['dalai', 'dawley', 'donnelly', 'donley', 'dali', 'dollies']
    findable: '$'
    spaceBefore: true
    action: ->
      @string '$'
  'left-angle':
    spoken: 'clangle'
    findable: '<'
    action: ->
      @string '<'
  'left-angle.padded':
    spoken: 'declangle'
    findable: ' < '
    action: ->
      @string ' < '
  'double-left-angle':
    spoken: 'langlang'
    pronunciation: 'lang glang'
    findable: '<<'
    action: ->
      @string '<<'
  'right-angle':
    spoken: 'wrangle'
    findable: '>'
    action: ->
      @string '>'
  'right-angle.padded':
    spoken: 'derangle'
    findable: ' > '
    action: ->
      @string ' > '
  'double-right-angle':
    spoken: 'rangrang'
    pronunciation: 'rang grang'
    findable: '>>'
    action: ->
      @string '>>'
  'left-parentheses':
    spoken: 'precorp'
    findable: '('
    action: ->
      @string '('
  'right-parentheses':
    spoken: 'prekose'
    findable: ')'
    action: ->
      @string ')'
  'left-bracket':
    spoken: 'brackorp'
    findable: '['
    action: ->
      @string '['
  'right-bracket':
    spoken: 'brackose'
    findable: ']'
    action: ->
      @string ']'
  'underscore':
    spoken: 'crunder'
    findable: '_'
    action: ->
      @string '_'
  'double-colon':
    spoken: 'coaltwice'
    findable: '::'
    action: ->
      @string '::'
  'double-minus':
    spoken: 'mintwice'
    tags: ['symbol', 'minus', 'recommended']
    findable: '--'
    action: ->
      @string '--'
  'backtick':
    spoken: 'tinker'
    findable: '`'
    action: ->
      @string '`'
  'caret':
    spoken: 'caret'
    findable: '^'
    action: ->
      @string '^'
  'pixel':
    spoken: 'pixel'
    tags: ['symbol']
    findable: 'px'
    autoSpacing: 'normal normal'
    multiPhraseAutoSpacing: 'normal normal'
    action: ->
      @string 'px'
  'question-equal.padded':
    spoken: 'quesquall'
    tags: ['symbol']
    findable: ' ?= '
    action: ->
      @string ' ?= '
  'ellipsis':
    spoken: 'ellipsis'
    findable: '...'
    action: ->
      @string '...'
