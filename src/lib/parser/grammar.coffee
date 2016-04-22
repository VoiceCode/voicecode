class Grammar
  instance = null
  constructor: () ->
    return instance if instance?
    instance = @

  buildCommands: (kind) ->
    result = @buildCommandList Commands.Utility.sortedCommandKeys(kind)
    if result?.length
      result
    else
      "'xxyyzz'"

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

  buildIds: (kind) ->
    ids = Commands.Utility.sortedCommandKeys(kind)
    results = []
    for id in ids
      command = Commands.mapping[id]
      if command.enabled and command.needsParsing != false
        section = switch command.grammarType
          when "custom"
            @buildId command
          when "textCapture"
            @buildId command
          when "singleSearch"
            @buildId command
          when "integerCapture"
            @buildId command
          when "numberRange"
            @buildId command
          when "individual"
            @buildId command
          when "oneArgument"
            @buildId command
          when "commandCapture"
            @buildId command
          when "unconstrainedText"
            @buildId command
        results.push section if section?
    if results.length
      results.join('/\n')
    else
      # something that should never occur (just to satisfy parser constraints)
      '"zzyyxx"'

  buildMisspellings: ->
    results = []
    for id, command of Commands.mapping
      if command.enabled and command.needsParsing != false
        if command.misspellings?.length
          normalized = command.spoken.replace(/\W+/g, "_")
          alternates = _.map command.misspellings, (alt) ->
            "\"#{alt} \""
          alternates.push "\"#{command.spoken} \""
          result = [
            "__#{normalized} = (("
            alternates.join('/')
            "){return '#{command.id}';}"
            ')'
          ].join('')
          results.push result
    results.join('\n')

  translationIds: ->
    _.sortBy(
      _.map Settings.translations, (value, key) ->
        "\"#{key} \""
    , (e) -> e
    ).reverse().join("/\n")

  findableIds: ->
    @buildRecognizedNameList Commands.Utility.sortedCommandKeys('findable')

  repeaterIds: ->
    @buildRecognizedNameList Commands.Utility.sortedCommandKeys('repeater')

  buildRecognizedNameList: (ids) ->
    _.map _.uniq(ids), (id) =>
      @buildId Commands.mapping[id]
    .join '/\n'

  buildPhonemeChain: ->
    _.map Packages.get('alphabet').settings().letters, (value, key) ->
      "'#{value}'"
    .join "/"

  buildId: (command, returnId = true) ->
    name = command.spoken
    if command.misspellings?.length
      normalized = name.replace(/\W+/g, "_")
      "__#{normalized}"
    else
      [
        "\"#{name} \""
        "{return '#{command.id}';}" if returnId
      ].join('')

  customCommand: (command) ->
    name = command.spoken
    first = []
    second = []
    for item in command.grammar.tokens
      switch item.kind
        when 'list', 'inlineList'
          if item.optional
            first.push "_#{item.uniqueName}:(_#{item.name})?"
          else
            first.push "_#{item.uniqueName}:(_#{item.name})"
          second.push "#{item.uniqueName}: _#{item.uniqueName}"
        when 'text'
          if item.optional
            first.push "('#{item.text}')?"
          else
            first.push "('#{item.text}')?"
          first.push "ss"
        when 'special'
          switch item.name
            when 'spoken'
              first.push @buildId(command, false)
    [
      first.join(" ")
      "{return{c:'#{command.id}',a:{#{second.join(",")}}};}"
    ].join ' '

  customLists: ->
    _.map(Commands.Utility.getUsedOptionLists('recognized'), @buildCustomList).join("\n")

  buildCustomList: (items, name) ->
    sorted = _.sortBy(items, (e) -> e).reverse()
    itemString = _.map sorted, (item) ->
      _.map item.split(' '), (word) ->
        "\"#{word}\""
      .join('sd') + "ss"
    .join "/\n"
    "_#{name}=value:(#{itemString}) {return value;}"

  singleLetterSuffix: ->
    Packages.get('alphabet').settings().singleLetterSuffix
  uppercaseLetterPrefix: ->
    Packages.get('alphabet').settings().uppercaseLetterPrefix

  build: -> """
    {
      var g = grammarContext;
      var state = new GrammarState();
      var phonemes = _.invert(Packages.get('alphabet').settings().letters);
    }

    start = commands:(command)*

    command =
      c:customCommand & {return state.found(c)} {return c}/
      c:textCaptureCommand & {return state.found(c)} {return c}/
      c:singleSearchCommand & {return state.found(c)} {return c}/
      c:integerCaptureCommand & {return state.found(c)} {return c}/
      c:numberRangeCommand & {return state.found(c)} {return c}/
      c:individualCommand & {return state.found(c)} {return c}/
      c:oneArgumentCommand & {return state.found(c)} {return c}/
      c:commandCaptureCommand & {return state.found(c)} {return c}/
      c:unconstrainedTextCommand & {return state.found(c)} {return c}/
      c:literalCommand & {return state.found(c)} {return c}

    #{@buildMisspellings()}

    customCommandId = #{@buildIds('custom')}
    customCommand = #{@buildCommands('custom')}

    textCaptureId = #{@buildIds('textCapture')}
    textCaptureCommand = id:textCaptureId a:textArgument? {return{c:id,a:a}}

    singleSearchId = #{@buildIds('singleSearch')}
    singleSearchCommand = id:singleSearchId r:singleSearchArgument? d:repeaterId? {return{c:id,a:{value:r,distance:d}}}

    integerCaptureId = #{@buildIds('integerCapture')}
    integerCaptureCommand = id:integerCaptureId a:fuzzyInteger? {return{c:id,a:a}}

    numberRangeId = #{@buildIds('numberRange')}
    numberRangeCommand = id:numberRangeId a:(numberRange/fuzzyInteger)? {return{c:id,a:a}}

    individualId = #{@buildIds('individual')}
    individualCommand = id:individualId {return{c:id}}

    oneArgumentId = #{@buildIds('oneArgument')}
    oneArgumentCommand = id:oneArgumentId a:(fuzzyInteger/singleTextArgument)? {return{c:id,a:a}}

    commandCaptureId = #{@buildIds('commandCapture')}
    commandCaptureCommand = id:commandCaptureId a:(commandId)? {return{c:id,a:a}}

    unconstrainedTextId = #{@buildIds('unconstrainedText')}
    unconstrainedTextCommand = id:unconstrainedTextId a:(unconstrainedText)? {return{c:id,a:a}}

    commandId =
      customCommandId /
      textCaptureId /
      singleSearchId /
      integerCaptureId /
      numberRangeId /
      individualId /
      oneArgumentId /
      commandCaptureId /
      unconstrainedTextId

    literalCommand = a:(
      nestedText /
      translation /
      exactInteger /
      labeledPhonemeString /
      word /
      symbol
    )+ {return {c: "core:literal", a: a};}

    #{@customLists()}

    sentinel = id:(commandId) &{return state.sen(id)}

    textArgument = segments:(
      nestedText /
      translation /
      exactInteger /
      phonemeString /
      word
    )+ {return g.flatten(segments)}

    repeaterId
      = id:(#{@repeaterIds()}) {return Commands.getRepeater(id);}

    singleSearchArgument = (
      findable /
      nestedText /
      translation /
      contextualInteger /
      singleTextArgument
    )

    findable =
      id:(#{@findableIds()})
      {return Commands.getFindable(id);}

    singleTextArgument =
      translation /
      phonemeString /
      word /
      exactInteger /
      symbol

    nestedText
      = id:nestedTextId arguments:(word)+
      {return g.grammarTransform(id, (arguments));}

    unconstrainedText = unconstrainedWord*
    unconstrainedWord = chars:(!ss ch:. {return ch})* ss {return chars.join('')}

    nestedTextId = "shrink" / "treemail" / "trusername" / "trassword"

    translation = id:translationId {return Settings.translations[id.trim()];}

    translationId = id:(#{@translationIds()}) {return id;}

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

    sd = ("-" / " ")+
    twenty = "twenty" sd {return 20;}
    thirty = "thirty" sd {return 30;}
    forty = "forty" sd {return 40;}
    fifty = "fifty" sd {return 50;}
    sixty = "sixty" sd {return 60;}
    seventy = "seventy" sd {return 70;}
    eighty = "eighty" sd {return 80;}
    ninety = "ninety" sd {return 90;}

    hundred = "hundred" ss {return '00';}
    thousand = "thousand" ss {return '000';}
    million = "million" ss {return '000000';}
    billion = "billion" ss {return '000000000';}
    trillion = "trillion" ss {return '000000000000';}

    phonemeRoot = letter:(#{@buildPhonemeChain()})
      {return phonemes[letter];}

    phonemeIndividual = first:phonemeRoot ss {return first;}
    phonemeCapital = '#{@uppercaseLetterPrefix()}' ss root:phonemeRoot ss {return root.toUpperCase();}
    phonemeSuffix = root:phonemeRoot ss '#{@singleLetterSuffix()}' ss {return root;}
    phonemeString =
      phonemes:(phonemeSuffix / phonemeCapital / phonemeIndividual)+
      {return phonemes.join('');}
    labeledPhonemeString =
      phonemes:(phonemeString)
      {return {text: phonemes, source: 'phonemes'};}

  """

module.exports = new Grammar
