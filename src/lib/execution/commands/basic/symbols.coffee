Commands.createDisabledWithDefaults
  tags: ['symbol', 'recommended']
,
  'symbol.dot':
    spoken: 'dot'
    findable: '.'
    misspellings: ['.']
    spaceBefore: true
    action: ->
      @string '.'
  'symbol.star':
    spoken: 'star'
    misspellings: ['*']
    findable: '*'
    spaceBefore: true
    action: ->
      @string '*'
  'symbol.slash':
    spoken: 'slash'
    misspellings: ['/']
    findable: '/'
    spaceBefore: true
    action: ->
      @string '/'
  'symbol.backslash':
    spoken: 'shalls'
    # misspellings: ['\\']
    description: "backslash. hint: 'shalls' is 'slash' backward."
    findable: '\\'
    action: ->
      @string '\\'
  'symbol.comma':
    spoken: 'comma'
    misspellings: [',']
    findable: ','
    action: ->
      @string ','
  'symbol.tilde':
    spoken: 'tilde'
    misspellings: ['~']
    findable: '~'
    spaceBefore: true
    action: ->
      @string '~'
  'symbol.colon':
    spoken: 'colon'
    misspellings: [':']
    findable: ':'
    spaceBefore: true
    action: ->
      @string ':'
  'symbol.equal.padded':
    spoken: 'equeft'
    findable: ' = '
    action: ->
      @string ' = '
  'symbol.equal':
    spoken: 'smaqual'
    findable: '='
    action: ->
      @string '='
  'symbol.equal.surround.doubleQuotes':
    spoken: 'qualcoif'
    tags: ['symbol', 'quotes', 'recommended']
    findable: '="'
    action: ->
      @string '=""'
      @left()
  'symbol.equal.surround.singleQuotes':
    spoken: 'qualposh'
    findable: "='"
    tags: ['symbol', 'quotes', 'recommended']
    action: ->
      @string "=''"
      @left()
  'symbol.surround.parentheses.quotes':
    spoken: 'prexcoif'
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
  'symbol.surround.parentheses':
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
  'symbol.parentheses':
    spoken: 'prekris'
    action: ->
      @string '()'
  'symbol.brackets':
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
  'symbol.braces.left':
    spoken: 'kirksorp'
    findable: '{'
    action: ->
      @string '{'
  'symbol.braces.right':
    spoken: 'kirkos'
    findable: '}'
    action: ->
      @string '}'
  'symbol.braces.surround':
    spoken: 'kirk'
    findable: '{}'
    spaceBefore: true
    action: ->
      @string '{}'
      @left()
  'symbol.braces.surround.block':
    spoken: 'kirblock'
    action: ->
      @string '{}'
      @left()
      @enter()
  'symbol.space.surround':
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
  'symbol.minusEqual.padded':
    spoken: 'minquall'
    findable: ' -= '
    action: ->
      @string ' -= '
  'symbol.plusEqual.padded':
    spoken: 'pluqual'
    findable: ' += '
    action: ->
      @string ' += '
  'symbol.notEqual.padded':
    spoken: 'banquall'
    findable: ' != '
    action: ->
      @string ' != '
  'symbol.isEqual.padded':
    spoken: 'longqual'
    findable: ' == '
    action: ->
      @string ' == '
  'symbol.lessEqual.padded':
    spoken: 'lessqual'
    findable: ' <= '
    action: ->
      @string ' <= '
  'symbol.moreEqual.padded':
    spoken: 'grayqual'
    findable: ' >= '
    action: ->
      @string ' >= '
  'symbol.singleQuotes.surround':
    spoken: 'posh'
    tags: ['symbol', 'quotes', 'recommended']
    misspellings: ['pash']
    spaceBefore: true
    findable: "''"
    action: ->
      @string "''"
      @left()
  'symbol.doubleQuotes.surround':
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
  'symbol.doubleArrow.right.padded':
    spoken: 'shrocket'
    findable: ' => '
    action: ->
      @string ' => '
  'symbol.comma.padded.right':
    spoken: 'swipe'
    misspellings: ['swiped', 'swipes']
    findable: ', '
    action: ->
      @string ', '
  'symbol.colon.padded.right':
    spoken: 'coalgap'
    findable: ': '
    action: ->
      @string ': '
  'symbol.colon.enter':
    spoken: 'coalshock'
    findable: ':\r'
    action: ->
      @key ':'
      @enter()
  'symbol.slash.padded':
    spoken: 'divy'
    findable: ' / '
    action: ->
      @string ' / '
  'symbol.semicolon.position.right':
    spoken: 'sinker'
    findable: ';'
    action: ->
      @key 'right', 'command'
      @key ';'
  'symbol.semicolon.enter':
    spoken: 'sunkshock'
    misspellings: ['sinkshock'] #TODO remove later
    action: ->
      @key ';'
      @key 'return'
  'symbol.semicolon':
    spoken: 'sunk'
    misspellings: ['stunk']
    findable: ';'
    action: ->
      @key ';'
  'symbol.exclamation':
    spoken: 'clamor'
    misspellings: ['clamber', 'clamour']
    findable: '!'
    action: ->
      @key '!'
  'symbol.at':
    spoken: 'loco'
    misspellings: ['@']
    findable: '@'
    spaceBefore: true
    action: ->
      @string '@'
  'symbol.ampersand':
    spoken: 'amper'
    findable: '&'
    action: ->
      @string '&'
  'symbol.ampersand.padded':
    spoken: 'damper'
    findable: ' & '
    action: ->
      @string ' & '
  'symbol.pound':
    spoken: 'pounder'
    findable: '#'
    repeatable: true
    spaceBefore: true
    action: ->
      @string '#'
  'symbol.questionMark':
    spoken: 'questo'
    findable: '?'
    misspellings: ["?"]
    action: ->
      @string '?'
  'symbol.verticalBar.twice':
    spoken: 'bartrap'
    findable: '||'
    action: ->
      @string '||'
      @left()
  'symbol.verticalBar.twice.padded':
    spoken: 'goalpost'
    findable: ' || '
    action: ->
      @string ' || '
  'symbol.orEqual.padded':
    spoken: 'orquals'
    findable: ' ||= '
    action: ->
      @string ' ||= '
  'symbol.verticalBar':
    spoken: 'spike'
    findable: '|'
    action: ->
      @string '|'
  'symbol.angles.surround':
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
  'symbols.plus':
    spoken: 'plus'
    findable: '+'
    spaceBefore: true
    action: ->
      @string '+'
  'symbols.plus.padded':
    spoken: 'deplush'
    findable: ' + '
    action: ->
      @string ' + '
  'symbol.minus':
    spoken: 'minus'
    tags: ['symbol', 'minus', 'recommended']
    misspellings: ['minas']
    repeatable: true
    findable: '-'
    spaceBefore: true
    action: ->
      @string '-'
  'symbol.minus.padded':
    spoken: 'deminus'
    tags: ['symbol', 'minus', 'recommended']
    findable: ' - '
    action: ->
      @string ' - '
  'symbol.singleArrow.right':
    spoken: 'lambo'
    misspellings: ['limbo']
    findable: '->'
    spaceBefore: true
    action: ->
      @string '->'
  'symbol.doubleQuote':
    spoken: 'quatches'
    tags: ['symbol', 'quotes', 'recommended']
    findable: '"'
    action: ->
      @string '"'
  'symbol.singleQuote':
    spoken: 'quatchet'
    tags: ['symbol', 'quotes', 'recommended']
    findable: "'"
    action: ->
      @string "'"
  'symbol.percent':
    spoken: 'percy'
    findable: '%'
    spaceBefore: true
    action: ->
      @string '%'
  'symbol.percent.padded':
    spoken: 'depercy'
    findable: ' % '
    action: ->
      @string ' % '
  'symbol.dollar':
    spoken: 'dolly'
    misspellings: ['dalai', 'dawley', 'donnelly', 'donley', 'dali', 'dollies']
    findable: '$'
    spaceBefore: true
    action: ->
      @string '$'
  'symbol.angles.left':
    spoken: 'clangle'
    findable: '<'
    action: ->
      @string '<'
  'symbol.angles.left.padded':
    spoken: 'declangle'
    findable: ' < '
    action: ->
      @string ' < '
  'symbol.angles.left.twice':
    spoken: 'langlang'
    pronunciation: 'lang glang'
    findable: '<<'
    action: ->
      @string '<<'
  'symbol.angles.right':
    spoken: 'wrangle'
    findable: '>'
    action: ->
      @string '>'
  'symbol.angles.right.padded':
    spoken: 'derangle'
    findable: ' > '
    action: ->
      @string ' > '
  'symbol.angles.right.twice':
    spoken: 'rangrang'
    pronunciation: 'rang grang'
    findable: '>>'
    action: ->
      @string '>>'
  'symbol.parentheses.left':
    spoken: 'precorp'
    findable: '('
    action: ->
      @string '('
  'symbol.parentheses.right':
    spoken: 'prekose'
    findable: ')'
    action: ->
      @string ')'
  'symbol.brackets.left':
    spoken: 'brackorp'
    findable: '['
    action: ->
      @string '['
  'symbol.brackets.right':
    spoken: 'brackose'
    findable: ']'
    action: ->
      @string ']'
  'symbol.underscore':
    spoken: 'crunder'
    findable: '_'
    action: ->
      @string '_'
  'symbol.colon.twice':
    spoken: 'coaltwice'
    findable: '::'
    action: ->
      @string '::'
  'symbol.minus.twice':
    spoken: 'mintwice'
    tags: ['symbol', 'minus', 'recommended']
    findable: '--'
    action: ->
      @string '--'
  'symbol.backtick':
    spoken: 'tinker'
    findable: '`'
    action: ->
      @string '`'
  'symbol.caret':
    spoken: 'caret'
    findable: '^'
    action: ->
      @string '^'
  'symbol.pixel':
    spoken: 'pixel'
    tags: ['symbol']
    findable: 'px'
    action: ->
      @string 'px '
  'symbol.question.equal.padded':
    spoken: 'quesquall'
    tags: ['symbol']
    findable: ' ?= '
    action: ->
      @string ' ?= '
  'symbol.ellipsis':
    spoken: 'ellipsis'
    findable: '...'
    action: ->
      @string '...'
