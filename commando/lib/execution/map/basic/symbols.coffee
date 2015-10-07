Commands.createDisabledWithDefaults
  tags: ['symbol', 'recommended']
,
  'dot':
    findable: '.'
    misspellings: ['.']
    spaceBefore: true
    action: ->
      @string '.'
  'star':
    misspellings: ['*']
    findable: '*'
    spaceBefore: true
    action: ->
      @string '*'
  'slash':
    misspellings: ['/']
    findable: '/'
    spaceBefore: true
    action: ->
      @string '/'
  'shalls':
    # misspellings: ['\\']
    description: "backslash. hint: 'shalls' is 'slash' backward."
    findable: '\\'
    action: ->
      @string '\\'
  'comma':
    misspellings: [',']
    findable: ','
    action: ->
      @string ','
  'tilde':
    misspellings: ['~']
    findable: '~'
    spaceBefore: true
    action: ->
      @string '~'
  'colon':
    misspellings: [':']
    findable: ':'
    spaceBefore: true
    action: ->
      @string ':'
  'equeft':
    findable: ' = '
    action: ->
      @string ' = '
  'smaqual':
    findable: '='
    action: ->
      @string '='
  'qualcoif':
    tags: ['symbol', 'quotes', 'recommended']
    findable: '="'
    action: ->
      @string '=""'
      @left()
  'qualposh':
    findable: "='"
    tags: ['symbol', 'quotes', 'recommended']
    action: ->
      @string "=''"
      @left()
  'prexcoif':
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
  'prex':
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
  'prekris':
    action: ->
      @string '()'
  'brax':
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
  'kirksorp':
    findable: '{'
    action: ->
      @string '{'
  'kirkos':
    findable: '}'
    action: ->
      @string '}'
  'kirk':
    findable: '{}'
    spaceBefore: true
    action: ->
      @string '{}'
      @left()
  'kirblock':
    action: ->
      @string '{}'
      @left()
      @enter()
  'prank':
    description: 'inserts 2 spaces leaving cursor in the middle. If text is selected, will wrap the selected text in spaces'
    findable: '  '
    action: ->
      if @canDetermineSelections() and @isTextSelected()
        t = @getSelectedText()
        @string(" #{t} ")
      else
        @string '  '
        @left()
  'minquall':
    findable: ' -= '
    action: ->
      @string ' -= '
  'pluqual':
    findable: ' += '
    action: ->
      @string ' += '
  'banquall':
    findable: ' != '
    action: ->
      @string ' != '
  'longqual':
    findable: ' == '
    action: ->
      @string ' == '
  'lessqual':
    findable: ' <= '
    action: ->
      @string ' <= '
  'grayqual':
    findable: ' >= '
    action: ->
      @string ' >= '
  'posh':
    tags: ['symbol', 'quotes', 'recommended']
    misspellings: ['pash']
    spaceBefore: true
    findable: "''"
    action: ->
      @string "''"
      @left()
  'coif':
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
  'shrocket':
    findable: ' => '
    action: ->
      @string ' => '
  'swipe':
    misspellings: ['swiped', 'swipes']
    findable: ', '
    action: ->
      @string ', '
  'coalgap':
    findable: ': '
    action: ->
      @string ': '
  'coalshock':
    findable: ':\r'
    action: ->
      @key ':'
      @enter()
  'divy':
    findable: ' / '
    action: ->
      @string ' / '
  'sinker':
    findable: ';'
    action: ->
      @key 'right', 'command'
      @key ';'
  'sunkshock':
    misspellings: ['sinkshock'] #TODO remove later
    action: ->
      @key ';'
      @key 'return'
  'sunk':
    misspellings: ['stunk']
    findable: ';'
    action: ->
      @key ';'
  'clamor':
    misspellings: ['clamber', 'clamour']
    findable: '!'
    action: ->
      @key '!'
  'loco':
    misspellings: ['@']
    findable: '@'
    spaceBefore: true
    action: ->
      @string '@'
  'amper':
    findable: '&'
    action: ->
      @string '&'
  'damper':
    findable: ' & '
    action: ->
      @string ' & '
  'pounder':
    findable: '#'
    repeatable: true
    spaceBefore: true
    action: ->
      @string '#'
  'questo':
    findable: '?'
    misspellings: ["?"]
    action: ->
      @string '?'
  'bartrap':
    findable: '||'
    action: ->
      @string '||'
      @left()
  'goalpost':
    findable: ' || '
    action: ->
      @string ' || '
  'orquals':
    findable: ' ||= '
    action: ->
      @string ' ||= '
  'spike':
    findable: '|'
    action: ->
      @string '|'
  'angler':
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
    findable: '+'
    spaceBefore: true
    action: ->
      @string '+'
  'deplush':
    findable: ' + '
    action: ->
      @string ' + '
  'minus':
    tags: ['symbol', 'minus', 'recommended']
    repeatable: true
    findable: '-'
    spaceBefore: true
    action: ->
      @string '-'
  'deminus':
    tags: ['symbol', 'minus', 'recommended']
    findable: ' - '
    action: ->
      @string ' - '
  'lambo':
    misspellings: ['limbo']
    findable: '->'
    spaceBefore: true
    action: ->
      @string '->'
  'quatches':
    tags: ['symbol', 'quotes', 'recommended']
    findable: '"'
    action: ->
      @string '"'
  'quatchet':
    tags: ['symbol', 'quotes', 'recommended']
    findable: "'"
    action: ->
      @string "'"
  'percy':
    findable: '%'
    spaceBefore: true
    action: ->
      @string '%'
  'depercy':
    findable: ' % '
    action: ->
      @string ' % '
  'dolly':
    misspellings: ['dalai', 'dawley', 'donnelly', 'donley', 'dali', 'dollies']
    findable: '$'
    spaceBefore: true
    action: ->
      @string '$'
  'clangle':
    findable: '<'
    action: ->
      @string '<'
  'declangle':
    findable: ' < '
    action: ->
      @string ' < '
  'langlang':
    pronunciation: 'lang glang'
    findable: '<<'
    action: ->
      @string '<<'
  'wrangle':
    findable: '>'
    action: ->
      @string '>'
  'derangle':
    findable: ' > '
    action: ->
      @string ' > '
  'rangrang':
    pronunciation: 'rang grang'
    findable: '>>'
    action: ->
      @string '>>'
  'precorp':
    findable: '('
    action: ->
      @string '('
  'prekose':
    findable: ')'
    action: ->
      @string ')'
  'brackorp':
    findable: '['
    action: ->
      @string '['
  'brackose':
    findable: ']'
    action: ->
      @string ']'
  'crunder':
    findable: '_'
    action: ->
      @string '_'
  'coaltwice':
    findable: '::'
    action: ->
      @string '::'
  'mintwice':
    tags: ['symbol', 'minus', 'recommended']
    findable: '--'
    action: ->
      @string '--'
  'tinker':
    findable: '`'
    action: ->
      @string '`'
  'caret':
    findable: '^'
    action: ->
      @string '^'
  'pixel':
    tags: ['symbol']
    findable: 'px'
    action: ->
      @string 'px '
  'quesquall':
    tags: ['symbol']
    findable: ' ?= '
    action: ->
      @string ' ?= '
  'ellipsis':
    findable: '...'
    action: ->
      @string '...'
