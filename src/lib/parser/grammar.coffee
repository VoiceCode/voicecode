class Grammar
  instance = null
  constructor: () ->
    return instance if instance?
    instance = @

  buildCommands: (kind) ->
    @buildCommandList Commands.Utility.sortedCommandKeys(kind)

  buildCommandList: (keys) ->
    results = _.map keys, (id) =>
      command = new Command id
      if command.enabled
        unless command.needsParsing is false
          switch command.grammarType
            when "custom"
              @customCommand command
            when "textCapture"
              @textCaptureCommand command
            when "singleSearch"
              @singleSearchCommand command
            when "integerCapture"
              @integerCaptureCommand command
            when "numberRange"
              @numberRangeCommand command
            when "individual"
              @individualCommand command
            when "oneArgument"
              @oneArgumentCommand command
            when "unconstrainedText"
              @unconstrainedTextCommand command
    _.compact(results).join('/\n')

  translationIds: ->
    _.map(Settings.translations, (value, key) -> "\"#{key}\"").join(" / ")

  findableIds: ->
    @buildRecognizedNameList Commands.Utility.sortedCommandKeys('findable')

  repeaterIds: ->
    @buildRecognizedNameList Commands.Utility.sortedCommandKeys('repeater')

  buildRecognizedNameList: (ids) ->
    _.map ids, (id) =>
      @buildMisspellings Commands.mapping[id], true
    .join '/'

  buildPhonemeChain: ->
    _.map Settings.letters, (value, key) ->
      "'#{value}'"
    .join "/"

  buildMisspellings: (command, convergent = false) ->
    name = command.spoken
    if command.misspellings?.length
      alternates = _.map command.misspellings, (alt) ->
        "'#{alt}'"
      alternates.push "'#{name}'"
      misspellings = _.sortBy(alternates, (e) -> e).reverse()
      result = [
        '('
        misspellings.join(" / ")
        if convergent
          "{return '#{name}';}"
        ')'
      ].join('')
    else
      "'#{name}'"

  customCommand: (command) ->
    name = command.spoken
    first = if command.grammar.includeName
      [@buildMisspellings(command), "ss"]
    else
      []
    second = []
    for item in command.grammar.tokens
      if item.list?
        if item.optional
          first.push "_#{item.uniqueName}:(_#{item.name})?"
        else
          first.push "_#{item.uniqueName}:(_#{item.name})"
        second.push "#{item.uniqueName}: _#{item.uniqueName}"
      else if item.text?
        if item.optional
          first.push "('#{item.text}')?"
        else
          first.push "('#{item.text}')?"
        first.push "ss"
    [
      first.join(" ")
      "{return{c:'#{command.id}',a:{#{second.join(",")}}};}"
    ].join ' '

  customLists: ->
    _.map(Commands.Utility.getUsedOptionLists('recognized'), @buildCustomList).join("\n")

  buildCustomList: (items, name) ->
    sorted = _.sortBy(items, (e) -> e).reverse()
    itemString = _.map sorted, (item) ->
      "\"#{item}\""
    .join " / "
    "_#{name}=value:(#{itemString}) ss {return value;}"

  textCaptureCommand: (command) ->
    [
      @buildMisspellings(command)
      "ss"
      "a:textArgument?"
      "{return{c:'#{command.id}',a:a}}"
    ].join ' '

  singleSearchCommand: (command) ->
    [
      @buildMisspellings(command)
      "ss"
      "r:singleSearchArgument?"
      "d:repeaterId?"
      "{return{c:'#{command.id}',a:{value:r,distance:d}}}"
    ].join ' '

  integerCaptureCommand: (command) ->
    # TODO parseInt on arg in normalizeOptions
    [
      @buildMisspellings(command)
      "ss"
      "a:fuzzyInteger?"
      "{return{c:'#{command.id}',a:a}}"
    ].join ' '

  numberRangeCommand: (command) ->
    [
      @buildMisspellings(command)
      "ss"
      "a:(numberRange/fuzzyInteger)?"
      "{return{c:'#{command.id}',a:a}}"
    ].join ' '

  individualCommand: (command) ->
    [
      @buildMisspellings(command)
      "ss"
      "{return{c:'#{command.id}'}}"
    ].join ' '

  oneArgumentCommand: (command) ->
    [
      @buildMisspellings(command)
      "ss"
      "a:(fuzzyInteger/singleTextArgument)?"
      "{return{c:'#{command.id}',a:a}}"
    ].join ' '

  unconstrainedTextCommand: (command) ->
    [
      @buildMisspellings(command)
      "ss"
      "a:(unconstrainedText)?"
      "{return{c:'#{command.id}',a:a}}"
    ].join ' '

  buildSentinels: ->
    keys = _.union Commands.keys['individual'],
      Commands.keys['oneArgument'],
      Commands.keys['numberRange'],
      Commands.keys['integerCapture'],
      Commands.keys['singleSearch'],
      Commands.keys['custom'],
      Commands.keys['textCapture']

    results = []
    _.each keys, (key) ->
      command = new Command key
      if command.enabled and command.needsParsing != false and command.spoken?
        conditional = command.isConditional() or command.continuous is false
        results.push [key, command.spoken, conditional]
        _.each command.misspellings, (word) ->
          results.push [key, word, conditional]

    _.map _.sortBy(results, (e) -> e[1]).reverse(), (e) ->
      value = "'#{e[1]}'"
      if e[2]
        value + "&{return state.sen('#{e[0]}')}"
      else
        value
    .join '/'

  build: -> """
    {
      var g = grammarContext;
      var state = new GrammarState();
    }

    start = commands:(command)*

    command =
      command:customCommand & {return state.found(command)} {return command}/
      command:textCaptureCommand & {return state.found(command)} {return command}/
      command:singleSearchCommand & {return state.found(command)} {return command}/
      command:integerCaptureCommand & {return state.found(command)} {return command}/
      command:numberRangeCommand & {return state.found(command)} {return command}/
      command:individualCommand & {return state.found(command)} {return command}/
      command:oneArgumentCommand & {return state.found(command)} {return command}/
      command:unconstrainedTextCommand & {return state.found(command)} {return command}/
      command:literalCommand & {return state.found(command)} {return command}

    textCaptureCommand = #{@buildCommands('textCapture')}
    customCommand = #{@buildCommands('custom')}
    singleSearchCommand = #{@buildCommands('singleSearch')}
    integerCaptureCommand = #{@buildCommands('integerCapture')}
    numberRangeCommand = #{@buildCommands('numberRange')}
    individualCommand = #{@buildCommands('individual')}
    oneArgumentCommand = #{@buildCommands('oneArgument')}
    unconstrainedTextCommand = #{@buildCommands('unconstrainedText')}
    literalCommand = a:(
      nestedText /
      translation /
      exactInteger /
      labeledPhonemeString /
      word /
      symbol
    )+ {return {c: "core:literal", a: a};}

    #{@customLists()}

    sentinel = s:(#{@buildSentinels()}) ss

    textArgument = segments:(
      nestedText /
      translation /
      exactInteger /
      phonemeString /
      word
    )+ {return g.flatten(segments)}

    repeaterId
      = id:(#{@repeaterIds()}) ss {return Commands.getRepeater(id);}

    singleSearchArgument = (
      findable /
      nestedText /
      translation /
      contextualInteger /
      singleTextArgument
    )

    findable =
      id:(#{@findableIds()}) ss
      {return Commands.getFindable(id);}

    singleTextArgument =
      translation /
      phonemeString /
      word /
      exactInteger /
      symbol

    nestedText
      = id:nestedTextId ss arguments:(word)+
      {return g.grammarTransform(id, (arguments));}

    unconstrainedText = unconstrainedWord*
    unconstrainedWord = chars:(!ss ch:. {return ch})* ss {return chars.join('')}

    nestedTextId = "shrink" / "treemail" / "trusername" / "trassword"

    translation = id:translationId {return translationReplacement(id);}

    translationId
      = id:(#{@translationIds()}) ss {return id;}

    s = " "*

    ss = " "+

    word =
      !sentinel
      text:([a-z]i / '.' / "'" / '-' / '&' / '`' / '/' / ':' / [0-9])+ ss
      {return text.join('')}

    symbol =
      !sentinel
      symbol:([$-/] / [:-?] / [{-~] / '!' / '"' / '^' / '_' / '`' / '[' / ']' / '#' / '@' / '\\\\' / '`' / '&') s
      {return symbol}

    numberRange = first:(fuzzyInteger) "." ss last:(fuzzyInteger)? {return {first: parseInt(first), last: parseInt(last)};}

    numerals = d:[0-9]+ s {return d.join('');}

    contextualInteger =
      components:(tensPlace / fuzzyDigit / teen / powers / numerals)+
      {return components.join('');}

    fuzzyInteger =
      components:(tensPlace / fuzzyDigit / teen / powers / numerals)+
      {return components.join('');}

    exactInteger
      = start:(tensPlace / exactDigit / teen / powers / numerals) rest:(fuzzyInteger)*
      {return start.toString() + rest.join('');}

    fuzzyDigit = zero / oh / one / to / two / three / for / four / five / six / seven / eight / nine
    exactDigit = zero / one / two / three / four / five / six / seven / eight / nine
    teen = ten / eleven / twelve / thirteen / fourteen / fifteen / sixteen / seventeen / eighteen / nineteen
    tensPlace = twenty / thirty / forty / fifty / sixty / seventy / eighty / ninety
    powers = hundred / thousand / million / billion / trillion

    zero = "zero" ss {return 0;}
    oh = "oh" ss {return 0;}
    one = "one" ss {return 1;}
    to = "to" ss {return 2;}
    two = ("two" / "twah") ss {return 2;}
    three = "three" ss {return 3;}
    for = "for" ss {return 4;}
    four = ("four" / "quads") ss {return 4;}
    five = "five" ss {return 5;}
    six = "six" ss {return 6;}
    seven = "seven" ss {return 7;}
    eight = "eight" ss {return 8;}
    nine = "nine" ss {return 9;}

    ten = "ten" ss {return 10;}
    eleven = "eleven" ss {return 11;}
    twelve = "twelve" ss {return 12;}
    thirteen = "thirteen" ss {return 13;}
    fourteen = "fourteen" ss {return 14;}
    fifteen = "fifteen" ss {return 15;}
    sixteen = "sixteen" ss {return 16;}
    seventeen = "seventeen" ss {return 17;}
    eighteen = "eighteen" ss {return 18;}
    nineteen = "nineteen" ss {return 19;}

    dashOrSpace = ("-" / " ")+
    twenty = "twenty" dashOrSpace {return 20;}
    thirty = "thirty" dashOrSpace {return 30;}
    forty = "forty" dashOrSpace {return 40;}
    fifty = "fifty" dashOrSpace {return 50;}
    sixty = "sixty" dashOrSpace {return 60;}
    seventy = "seventy" dashOrSpace {return 70;}
    eighty = "eighty" dashOrSpace {return 80;}
    ninety = "ninety" dashOrSpace {return 90;}

    hundred = "hundred" ss {return '00';}
    thousand = "thousand" ss {return '000';}
    million = "million" ss {return '000000';}
    billion = "billion" ss {return '000000000';}
    trillion = "trillion" ss {return '000000000000';}

    phonemeRoot = letter:(#{@buildPhonemeChain()})
      {return Alphabet.roots[letter];}

    phonemeIndividual = first:phonemeRoot ss {return first;}
    phonemeCapital = '#{Settings.uppercaseLetterPrefix}' ss root:phonemeRoot ss {return root.toUpperCase();}
    phonemeSuffix = root:phonemeRoot ss '#{Settings.singleLetterSuffix}' ss {return root;}
    phonemeString =
      phonemes:(phonemeSuffix / phonemeCapital / phonemeIndividual)+
      {return phonemes.join('');}
    labeledPhonemeString =
      phonemes:(phonemeString)
      {return {text: phonemes, source: 'phonemes'};}

  """

module.exports = new Grammar
