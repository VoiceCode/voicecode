class @Grammar
  constructor: () ->
  textCaptureCommands: ->
    @buildCommandList Commands.Utility.sortedCommandKeys("textCapture")
  textCaptureCommandsContinuous: ->
    @buildCommandList Commands.Utility.sortedCommandKeys("textCapture", true)
  numberCaptureCommands: ->
    @buildCommandList Commands.Utility.sortedCommandKeys("numberCapture")
  numberCaptureCommandsContinuous: ->
    @buildCommandList Commands.Utility.sortedCommandKeys("numberCapture", true)
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
  repeaterCommands: ->
    @buildCommandList Commands.Utility.sortedCommandKeys("repeater")
  buildCommandList: (keys) ->
    results = []
    for name in keys
      command = Commands.mapping[name]
      if command.enabled
        if command.aliases?.length
          if name is "."
            results.push "dot"
          else
            results.push name.split(" ").join('_')
        else
          results.push "\"#{name}\""
    results.join(' / ')
  aliases: ->
    results = []
    for name, command of Commands.mapping
      if command.aliases?.length
        alternates = _.map command.aliases, (alt) ->
          "'#{alt}'"
        alternates.push "'#{name}'"
        normalName = if name is "."
          "dot"
        else
          name.split(" ").join('_')
        aliasLine = "#{normalName} = (#{alternates.join(" / ")}) {return '#{name}';}"
        results.push aliasLine
    results.join("\n")
  translationIdentifiers: ->
    _.map(Settings.translations, (value, key) -> "\"#{key}\"").join(" / ")
  build: -> """
    {
      var grammarTransforms = {
        frank: function(arguments) {
          return Scripts.fuzzyMatch(Settings.abbreviations, arguments.join(' '));
        },
        treemail: function(arguments) {
          return Scripts.fuzzyMatch(Settings.emails, arguments.join(' '));
        },
        trusername: function(arguments) {
          return Scripts.fuzzyMatch(Settings.usernames, arguments.join(' '));
        },
        trassword: function(arguments) {
          return Scripts.fuzzyMatch(Settings.passwords, arguments.join(' '));
        }
      }

      function grammarTransform (name, arguments) {
        return grammarTransforms[name](arguments);
      }

      function makeInteger(textArray) {
        return parseInt(textArray.join(""), 10);
      }
    }

    start
      = phrase

    phrase
      // sublimePhrase / atomPhrase / globalPhrase
      = first:(command) rest:(commandContinuous)* {return [first].concat(rest);}

    // sublimePhrase
    //  = "cx-sublimetext" ss first:(commandSublime) rest:(commandContinuousSublime)* {return [first].concat(rest);}

    command
      = textCaptureCommand / singleSearchCommand / numberCaptureCommand / individualCommand / oneArgumentCommand / literalCommand
    commandContinuous
      = textCaptureCommandContinuous / singleSearchCommandContinuous / numberCaptureCommandContinuous / individualCommandContinuous / oneArgumentCommandContinuous / literalCommand

    textCaptureCommand
      = left:textCaptureIdentifier right:textArgument? {return {command: left, arguments: right};}
    textCaptureCommandContinuous
      = left:textCaptureIdentifierContinuous right:textArgument? {return {command: left, arguments: right};}

    textCaptureIdentifier
      = identifier:(#{@textCaptureCommands()}) ss {return identifier;}
    textCaptureIdentifierContinuous
      = identifier:(#{@textCaptureCommandsContinuous()}) ss {return identifier;}


    #{@aliases()}

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
      = (overrideCommand / nestableTextCommand / translation / exactInteger / word)+

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
      = identifier:(#{@findableCommands()}) ss {return Commands.mapping[identifier].findable;}

    numberCaptureCommand
      = left:numberCaptureIdentifier right:spokenInteger? {return {command: left, arguments: parseInt(right)};}
    numberCaptureCommandContinuous
      = left:numberCaptureIdentifierContinuous right:spokenInteger? {return {command: left, arguments: parseInt(right)};}

    numberCaptureIdentifier
      = identifier:(#{@numberCaptureCommands()}) ss {return identifier;}
    numberCaptureIdentifierContinuous
      = identifier:(#{@numberCaptureCommandsContinuous()}) ss {return identifier;}

    oneArgumentCommand
      = left:oneArgumentIdentifier right:(spokenInteger / singleTextArgument)? {return {command: left, arguments: right};}
    oneArgumentCommandContinuous
      = left:oneArgumentIdentifierContinuous right:(spokenInteger / singleTextArgument)? {return {command: left, arguments: right};}

    oneArgumentIdentifier
      = identifier:(#{@oneArgumentCommands()}) ss {return identifier;}
    oneArgumentIdentifierContinuous
      = identifier:(#{@oneArgumentCommandsContinuous()}) ss {return identifier;}

    singleTextArgument
      = (word / exactInteger / symbol)

    individualCommand
      = identifier:individualIdentifier {return {command: identifier};}
    individualCommandContinuous
      = identifier:individualIdentifierContinuous {return {command: identifier};}

    individualIdentifier
      = identifier:(#{@individualCommands()}) ss {return identifier;}
    individualIdentifierContinuous
      = identifier:(#{@individualCommandsContinuous()}) ss {return identifier;}

    literalCommand
      = text:(overrideCommand / nestableTextCommand / translation / exactInteger / word / symbol)+ {return {command: "vc-literal", arguments: text};}
   
    nestableTextIdentifier
      = "frank" / "treemail" / "trusername" / "trassword"

    nestableTextCommand
      = identifier:nestableTextIdentifier ss arguments:(word)+
      {return grammarTransform(identifier, arguments);}

    // translations

    translation
      = identifier:translationIdentifier {return translationReplacement(identifier);}

    translationIdentifier
      = identifier:(#{@translationIdentifiers()}) ss {return identifier;}


    s = " "*

    ss = " "+

    // identifier = id:(textCaptureIdentifier / numberCaptureIdentifier / individualIdentifier / oneArgumentIdentifier / singleSearchIdentifier / overrideIdentifier) s {return id;}
    identifier = id:(textCaptureIdentifierContinuous / numberCaptureIdentifierContinuous / individualIdentifierContinuous / oneArgumentIdentifierContinuous / singleSearchIdentifierContinuous / overrideIdentifier) s {return id;}

    word = !identifier text:([a-z]i / "." / "'" / "-")+ ss {return text.join('')}

    symbol = !identifier symbol:([$-/] / [:-?] / [{-~] / '!' / '"' / '^' / '_' / '`' / '[' / ']' / '#' / '@' / '\\\\') s {return symbol}


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

    twenty = "twenty" ("-" / " ") {return 20;}
    thirty = "thirty" ("-" / " ") {return 30;}
    forty = "forty" ("-" / " ") {return 40;}
    fifty = "fifty" ("-" / " ") {return 50;}
    sixty = "sixty" ("-" / " ") {return 60;}
    seventy = "seventy" ("-" / " ") {return 70;}
    eighty = "eighty" ("-" / " ") {return 80;}
    ninety = "ninety" ("-" / " ") {return 90;}

    hundred = "hundred" ss {return '00';}
    thousand = "thousand" ss {return '000';}
    million = "million" ss {return '000000';}
    billion = "billion" ss {return '000000000';}
    trillion = "trillion" ss {return '000000000000';}

    """
