class Grammar
  instance = null
  constructor: () ->
    return instance if instance?
    instance = @
  textCaptureCommands: ->
    @buildCommandList Commands.Utility.sortedCommandKeys("textCapture")
  textCaptureCommandsContinuous: ->
    @buildCommandList Commands.Utility.sortedCommandKeys("textCapture", true)
  integerCaptureCommands: ->
    @buildCommandList Commands.Utility.sortedCommandKeys("integerCapture")
  integerCaptureCommandsContinuous: ->
    @buildCommandList Commands.Utility.sortedCommandKeys("integerCapture", true)
  numberRangeCommands: ->
    @buildCommandList Commands.Utility.sortedCommandKeys("numberRange")
  numberRangeCommandsContinuous: ->
    @buildCommandList Commands.Utility.sortedCommandKeys("numberRange", true)
  individualCommands: ->
    @buildCommandList Commands.Utility.sortedCommandKeys("individual")
  individualCommandsContinuous: ->
    @buildCommandList Commands.Utility.sortedCommandKeys("individual", true)
  singleSearchCommands: ->
    @buildCommandList Commands.Utility.sortedCommandKeys("singleSearch")
  singleSearchCommandsContinuous: ->
    @buildCommandList Commands.Utility.sortedCommandKeys("singleSearch", true)
  findableCommands: ->
    @buildCommandList Commands.Utility.sortedCommandKeys("findable")
  oneArgumentCommands: ->
    @buildCommandList Commands.Utility.sortedCommandKeys("oneArgument")
  oneArgumentCommandsContinuous: ->
    @buildCommandList Commands.Utility.sortedCommandKeys("oneArgument", true)
  customCommands: ->
    @buildCommandList Commands.Utility.sortedCommandKeys("custom")
  # customCommandsContinuous: ->
  #   @buildCommandList Commands.Utility.sortedCommandKeys("custom", true)
  repeaterCommands: ->
    @buildCommandList Commands.Utility.sortedCommandKeys("repeater")
  buildCommandList: (keys) ->
    results = []
    for id in keys
      command = Commands.mapping[id]
      continue unless command?
      name = command.spoken
      if command.enabled
        if command.misspellings?.length
          if name is "."
            results.push "dot"
          else
            results.push _.snakeCase(name)
        else
          results.push "\"#{name}\""
    results.join(' / ')
  misspellings: ->
    results = []
    for id, command of Commands.mapping
      name = command.spoken
      if command.misspellings?.length
        alternates = _.map command.misspellings, (alt) ->
          "'#{alt}'"
        alternates.push "'#{name}'"
        normalName = if name is "."
          "dot"
        else
          name.split(" ").join('_')
        misspellings = _.sortBy(alternates, (e) -> e).reverse()
        aliasLine = "#{normalName} = (#{misspellings.join(" / ")}) {return '#{name}';}"
        results.push aliasLine
    results.join("\n")
  translationIdentifiers: ->
    _.map(Settings.translations, (value, key) -> "\"#{key}\"").join(" / ")
  buildPhonemeChain: ->
    _.map Settings.letters, (value, key) ->
      "'#{value}'"
    .join " / "
  modifierSuffixes: ->
    '"' + _.values(Modifiers.suffixes()).join('" / "') + '"'
  modifierPrefixes: ->
    '"' + _.keys(Settings.modifierPrefixes).join('" / "') + '"'
  buildNew: -> """
    {
      var g = grammarContext;
    }

    start
      = phrase

    phrase
      = commands:(command)*

    command
      = customCommand /
        textCaptureCommand /
        singleSearchCommand /
        integerCaptureCommand /
        numberRangeCommand /
        individualCommand /
        oneArgumentCommand /
        modifierCommand /
        literalCommand

    textCaptureCommand
      = left:textCaptureIdentifier right:textArgument? {return {command: left, arguments: right};}

    textCaptureIdentifier
      = identifier:(#{@textCaptureCommands()}) ss {return identifier;}

    #{@misspellings()}

    #{@customCommandsContent()}

    #{@customLists()}

    overrideCommand
     = keeperLeft:overrideIdentifier keeperRight:(identifier / spokenInteger / modifierCommand)
     {
      if (isNaN(keeperRight)) {
        return keeperRight;
      }
      else {
        return numberToWords(keeperRight);
      }
     }

    overrideIdentifier
      = identifier:("keeper") ss {return identifier;}

    textArgument
      = (overrideCommand / nestableTextCommand / translation / exactInteger / phonemeString / word)+

    singleSearchCommand
      = left:singleSearchIdentifier right:singleSearchArgument? distance:repeaterIdentifier? {return {command: left, arguments: {value: right, distance: distance}};}

    repeaterIdentifier
      = identifier:(#{@repeaterCommands()}) ss {return Commands.mapping[identifier].repeater;}

    singleSearchIdentifier
      = identifier:(#{@singleSearchCommands()}) ss {return identifier;}

    singleSearchArgument
      = (overrideCommand / findableIdentifier / nestableTextCommand / translation / spokenInteger / singleTextArgument)

    findableIdentifier
      = identifier:(#{@findableCommands()}) ss {return Commands.getBySpoken(identifier).findable;}

    integerCaptureCommand
      = left:integerCaptureIdentifier right:spokenInteger? {return {command: left, arguments: parseInt(right)};}

    numberRangeCommand
      = left:numberRangeIdentifier right:(numberRange / spokenInteger)? {return {command: left, arguments: right};}

    integerCaptureIdentifier
      = identifier:(#{@integerCaptureCommands()}) ss {return identifier;}

    numberRangeIdentifier
      = identifier:(#{@numberRangeCommands()}) ss {return identifier;}

    oneArgumentCommand
      = left:oneArgumentIdentifier right:(spokenInteger / singleTextArgument)? {return {command: left, arguments: right};}

    oneArgumentIdentifier
      = identifier:(#{@oneArgumentCommands()}) ss {return identifier;}

    singleTextArgument
      = (translation / phonemeString / word / exactInteger / symbol)

    individualCommand
      = identifier:individualIdentifier {return {command: identifier};}

    individualIdentifier
      = identifier:(#{@individualCommands()}) ss {return identifier;}

    literalCommand
      = text:(overrideCommand / nestableTextCommand / translation / exactInteger / labeledPhonemeString / word / symbol)+ {return {command: "core:literal", arguments: text};}

    nestableTextIdentifier
      = "shrink" / "treemail" / "trusername" / "trassword"

    nestableTextCommand
      = identifier:nestableTextIdentifier ss arguments:(word)+
      {return g.grammarTransform(identifier, (arguments));}

    translation
      = identifier:translationIdentifier {return translationReplacement(identifier);}

    translationIdentifier
      = identifier:(#{@translationIdentifiers()}) ss {return identifier;}

    s = " "*

    ss = " "+

    identifier = id:(
      textCaptureIdentifier /
      integerCaptureIdentifier /
      numberRangeIdentifier /
      individualIdentifier /
      oneArgumentIdentifier /
      singleSearchIdentifier /
      nestableTextIdentifier /
      overrideIdentifier /
      modifierIdentifier /
      modifierPrefix
    ) s {return id;}

    word = !identifier !customCommand text:([a-z]i / '.' / "'" / '-' / '&' / '`' / '/' / [0-9])+ ss {return text.join('')}

    symbol = !identifier symbol:([$-/] / [:-?] / [{-~] / '!' / '"' / '^' / '_' / '`' / '[' / ']' / '#' / '@' / '\\\\' / '`' / '&') s {return symbol}

    numberRange = first:(spokenInteger) "." ss last:(spokenInteger)? {return {first: parseInt(first), last: parseInt(last)};}

    integer "integer"
      = digits:[0-9]+ s {return makeInteger(digits);}

    spokenInteger
      = components:(tensPlace / spokenDigit / teen / thousands / integer)+
      {return components.join('');}

    exactInteger
      = start:(tensPlace / exactDigit / teen / thousands / integer) rest:(spokenInteger)*
      {return start.toString() + rest.join('');}

    spokenDigit = zero / oh / one / to / two / three / for / four / five / six / seven / eight / nine
    exactDigit = zero / one / two / three / four / five / six / seven / eight / nine
    teen = ten / eleven / twelve / thirteen / fourteen / fifteen / sixteen / seventeen / eighteen / nineteen
    tensPlace = twenty / thirty / forty / fifty / sixty / seventy / eighty / ninety
    thousands = hundred / thousand / million / billion / trillion

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

    twenty = "twenty" ("-" / " ")+ {return 20;}
    thirty = "thirty" ("-" / " ")+ {return 30;}
    forty = "forty" ("-" / " ")+ {return 40;}
    fifty = "fifty" ("-" / " ")+ {return 50;}
    sixty = "sixty" ("-" / " ")+ {return 60;}
    seventy = "seventy" ("-" / " ")+ {return 70;}
    eighty = "eighty" ("-" / " ")+ {return 80;}
    ninety = "ninety" ("-" / " ")+ {return 90;}

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

    modifierIdentifier
      = prefix:modifierPrefix ss suffix:modifierSuffix {return prefix + " " + suffix;}

    modifierCommand
      = identifier:modifierIdentifier ss {return {command: identifier};}

    modifierPrefix = #{@modifierPrefixes()}
    modifierSuffix = #{@modifierSuffixes()}
  """
  build: -> """
    {
      var g = grammarContext;
    }

    start
      = phrase

    phrase
      = first:(command) rest:(commandContinuous)* {return [first].concat(rest);}

    command
      = customCommand /
        textCaptureCommand /
        singleSearchCommand /
        integerCaptureCommand /
        numberRangeCommand /
        individualCommand /
        oneArgumentCommand /
        modifierCommand /
        literalCommand

    commandContinuous
      = customCommand /
        textCaptureCommandContinuous /
        singleSearchCommandContinuous /
        integerCaptureCommandContinuous /
        numberRangeCommandContinuous /
        individualCommandContinuous /
        oneArgumentCommandContinuous /
        modifierCommand /
        literalCommand

    textCaptureCommand
      = left:textCaptureIdentifier right:textArgument? {return {command: left, arguments: right};}
    textCaptureCommandContinuous
      = left:textCaptureIdentifierContinuous right:textArgument? {return {command: left, arguments: right};}

    textCaptureIdentifier
      = identifier:(#{@textCaptureCommands()}) ss {return identifier;}
    textCaptureIdentifierContinuous
      = identifier:(#{@textCaptureCommandsContinuous()}) ss {return identifier;}


    #{@misspellings()}

    #{@customCommandsContent()}

    #{@customLists()}

    overrideCommand
     = keeperLeft:overrideIdentifier keeperRight:(identifier / spokenInteger)
     {
      if (isNaN(keeperRight)) {
        return keeperRight;
      }
      else {
        return numberToWords(keeperRight);
      }
     }

    overrideIdentifier
      = identifier:("keeper") ss {return identifier;}

    textArgument
      = (overrideCommand / nestableTextCommand / translation / exactInteger / phonemeString / word)+

    singleSearchCommand
      = left:singleSearchIdentifier right:singleSearchArgument? distance:repeaterIdentifier? {return {command: left, arguments: {value: right, distance: distance}};}
    singleSearchCommandContinuous
      = left:singleSearchIdentifierContinuous right:singleSearchArgument? distance:repeaterIdentifier? {return {command: left, arguments: {value: right, distance: distance}};}

    repeaterIdentifier
      = identifier:(#{@repeaterCommands()}) ss {return Commands.mapping[identifier].repeater;}

    singleSearchIdentifier
      = identifier:(#{@singleSearchCommands()}) ss {return identifier;}
    singleSearchIdentifierContinuous
      = identifier:(#{@singleSearchCommandsContinuous()}) ss {return identifier;}

    singleSearchArgument
      = (overrideCommand / findableIdentifier / nestableTextCommand / translation / spokenInteger / singleTextArgument)

    findableIdentifier
      = identifier:(#{@findableCommands()}) ss {return Commands.getBySpoken(identifier).findable;}

    integerCaptureCommand
      = left:integerCaptureIdentifier right:spokenInteger? {return {command: left, arguments: parseInt(right)};}
    integerCaptureCommandContinuous
      = left:integerCaptureIdentifierContinuous right:spokenInteger? {return {command: left, arguments: parseInt(right)};}

    numberRangeCommand
      = left:numberRangeIdentifier right:(numberRange / spokenInteger)? {return {command: left, arguments: right};}
    numberRangeCommandContinuous
      = left:numberRangeIdentifierContinuous right:(numberRange / spokenInteger)? {return {command: left, arguments: right};}

    integerCaptureIdentifier
      = identifier:(#{@integerCaptureCommands()}) ss {return identifier;}
    integerCaptureIdentifierContinuous
      = identifier:(#{@integerCaptureCommandsContinuous()}) ss {return identifier;}

    numberRangeIdentifier
      = identifier:(#{@numberRangeCommands()}) ss {return identifier;}
    numberRangeIdentifierContinuous
      = identifier:(#{@numberRangeCommandsContinuous()}) ss {return identifier;}

    oneArgumentCommand
      = left:oneArgumentIdentifier right:(spokenInteger / singleTextArgument)? {return {command: left, arguments: right};}
    oneArgumentCommandContinuous
      = left:oneArgumentIdentifierContinuous right:(spokenInteger / singleTextArgument)? {return {command: left, arguments: right};}

    oneArgumentIdentifier
      = identifier:(#{@oneArgumentCommands()}) ss {return identifier;}
    oneArgumentIdentifierContinuous
      = identifier:(#{@oneArgumentCommandsContinuous()}) ss {return identifier;}

    singleTextArgument
      = (translation / phonemeString / word / exactInteger / symbol)

    individualCommand
      = identifier:individualIdentifier {return {command: identifier};}
    individualCommandContinuous
      = identifier:individualIdentifierContinuous {return {command: identifier};}

    individualIdentifier
      = identifier:(#{@individualCommands()}) ss {return identifier;}
    individualIdentifierContinuous
      = identifier:(#{@individualCommandsContinuous()}) ss {return identifier;}

    literalCommand
      = text:(overrideCommand / nestableTextCommand / translation / exactInteger / labeledPhonemeString / word / symbol)+ {return {command: "core:literal", arguments: text};}

    nestableTextIdentifier
      = "shrink" / "treemail" / "trusername" / "trassword"

    nestableTextCommand
      = identifier:nestableTextIdentifier ss arguments:(word)+
      {return g.grammarTransform(identifier, (arguments));}

    translation
      = identifier:translationIdentifier {return translationReplacement(identifier);}

    translationIdentifier
      = identifier:(#{@translationIdentifiers()}) ss {return identifier;}

    s = " "*

    ss = " "+

    identifier = id:(
      textCaptureIdentifierContinuous /
      integerCaptureIdentifierContinuous /
      numberRangeIdentifierContinuous /
      individualIdentifierContinuous /
      oneArgumentIdentifierContinuous /
      singleSearchIdentifierContinuous /
      nestableTextIdentifier /
      overrideIdentifier /
      modifierIdentifier /
      modifierPrefix
    ) s {return id;}

    word = !identifier !customCommand text:([a-z]i / '.' / "'" / '-' / '&' / '`' / '/' / [0-9])+ ss {return text.join('')}

    symbol = !identifier symbol:([$-/] / [:-?] / [{-~] / '!' / '"' / '^' / '_' / '`' / '[' / ']' / '#' / '@' / '\\\\' / '`' / '&') s {return symbol}

    numberRange = first:(spokenInteger) "." ss last:(spokenInteger)? {return {first: parseInt(first), last: parseInt(last)};}

    integer "integer"
      = digits:[0-9]+ s {return makeInteger(digits);}

    spokenInteger
      = components:(tensPlace / spokenDigit / teen / thousands / integer)+
      {return components.join('');}

    exactInteger
      = start:(tensPlace / exactDigit / teen / thousands / integer) rest:(spokenInteger)*
      {return start.toString() + rest.join('');}

    spokenDigit = zero / oh / one / to / two / three / for / four / five / six / seven / eight / nine
    exactDigit = zero / one / two / three / four / five / six / seven / eight / nine
    teen = ten / eleven / twelve / thirteen / fourteen / fifteen / sixteen / seventeen / eighteen / nineteen
    tensPlace = twenty / thirty / forty / fifty / sixty / seventy / eighty / ninety
    thousands = hundred / thousand / million / billion / trillion

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

    twenty = "twenty" ("-" / " ")+ {return 20;}
    thirty = "thirty" ("-" / " ")+ {return 30;}
    forty = "forty" ("-" / " ")+ {return 40;}
    fifty = "fifty" ("-" / " ")+ {return 50;}
    sixty = "sixty" ("-" / " ")+ {return 60;}
    seventy = "seventy" ("-" / " ")+ {return 70;}
    eighty = "eighty" ("-" / " ")+ {return 80;}
    ninety = "ninety" ("-" / " ")+ {return 90;}

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

    modifierIdentifier
      = prefix:modifierPrefix ss suffix:modifierSuffix {return prefix + " " + suffix;}

    modifierCommand
      = identifier:modifierIdentifier ss {return {command: identifier};}

    modifierPrefix = #{@modifierPrefixes()}
    modifierSuffix = #{@modifierSuffixes()}
    """
  customCommandsContent: ->
    cc = _.map Commands.Utility.sortedCommandKeys("custom"), (id) =>
      command = new Command(id, null)
      unless command.needsParsing is false
        "(" + @buildCustomCommand(command) + ")"
    result = _.compact(cc).join(" / ")

    """
    customCommand = #{result}
    """
  buildCustomCommand: (command) ->
    name = command.spoken
    first = if command.grammar.includeName
      token = if command.misspellings?.length
        name.split(" ").join('_')
      else
        '"' + name + '"'
      [token, "ss"]
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

    returnObject = second.join(", ")
    first.join(" ") + " " + "{return {command: '#{name}', arguments: {#{returnObject}}};}"

  customLists: ->
    _.map(Commands.Utility.getUsedOptionLists('recognized'), @buildCustomList).join("\n")

  buildCustomList: (items, name) ->
    sorted = _.sortBy(items, (e) -> e).reverse()
    itemString = _.map sorted, (item) ->
      "\"#{item}\""
    .join " / "
    "_#{name} = value:(#{itemString}) ss {return value;}"
module.exports = new Grammar
