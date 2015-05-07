class @Grammar
  constructor: () ->
  textCaptureCommands: ->
    @buildCommandList Commands.Utility.textCaptureCommands()
  numberCaptureCommands: ->
    @buildCommandList Commands.Utility.numberCaptureCommands()
  individualCommands: ->
    @buildCommandList Commands.Utility.individualCommands()
  singleSearchCommands: ->
    @buildCommandList Commands.Utility.singleSearchCommands()
  findableCommands: ->
    @buildCommandList Commands.Utility.findableCommands()
  oneArgumentCommands: ->
    @buildCommandList Commands.Utility.oneArgumentCommands()
  repeaterCommands: ->
    @buildCommandList Commands.Utility.repeaterCommands()
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

      function sumArray (array) {
        for (var i = 0, sum = 0; i < array.length; sum += array[i++]);
        return sum;
      }

    }

    start
      = phrase

    phrase
      = command+

    command
      = textCaptureCommand / singleSearchCommand / numberCaptureCommand / individualCommand / oneArgumentCommand / literalCommand

    textCaptureCommand
      = left:textCaptureIdentifier right:textArgument? {return {command: left, arguments: right};}

    textCaptureIdentifier
      = identifier:(#{@textCaptureCommands()}) ss {return identifier;}


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

    repeaterIdentifier
      = identifier:(#{@repeaterCommands()}) ss {return Commands.mapping[identifier].repeater;}

    singleSearchIdentifier
      = identifier:(#{@singleSearchCommands()}) ss {return identifier;}

    singleSearchArgument
      = (overrideCommand / findableIdentifier / nestableTextCommand / translation / singleTextArgument / spokenInteger)

    findableIdentifier
      = identifier:(#{@findableCommands()}) ss {return Commands.mapping[identifier].findable;}

    numberCaptureCommand
      = left:numberCaptureIdentifier right:spokenInteger? {return {command: left, arguments: parseInt(right)};}

    numberCaptureIdentifier
      = identifier:(#{@numberCaptureCommands()}) ss {return identifier;}

    oneArgumentCommand
      = left:oneArgumentIdentifier right:(singleTextArgument / spokenInteger)? {return {command: left, arguments: right};}

    oneArgumentIdentifier
      = identifier:(#{@oneArgumentCommands()}) ss {return identifier;}

    singleTextArgument
      = (word / exactInteger / symbol)

    individualCommand
      = identifier:individualIdentifier {return {command: identifier};}

    individualIdentifier
      = identifier:(#{@individualCommands()}) ss {return identifier;}

    literalCommand
      = text:(overrideCommand / nestableTextCommand / translation / word / exactInteger / symbol)+ {return {command: "vc-literal", arguments: text};}

    // literalNumber
    //   = number:exactInteger {return {command: "number", arguments: number};}
   
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

    identifier = id:(textCaptureIdentifier / numberCaptureIdentifier / individualIdentifier / oneArgumentIdentifier / "one" / "twah" / "quads" / "keeper") s {return id;}

    word = !identifier text:([a-z]i / "." / "'" / "-")+ ss {return text.join('')}

    symbol = !identifier symbol:([$-/] / [:-?] / [{-~] / '!' / '"' / '^' / '_' / '`' / '[' / ']' / '#' / '@' / '\\\\') s {return symbol}


    integer "integer"
      = digits:[0-9]+ s {return makeInteger(digits);}

    spokenInteger
      = components:(oneThousand / oneHundred / one / two / four / quads / zero / integer)+
      {return components.join('');}

    exactInteger
      = components:(oneThousand / oneHundred / one / twah / quads / zero / integer)+
      {return components.join('');}

    oneThousand
      = "one thousand" s {return 1000;}

    oneHundred
      = "one hundred" s {return 100;}

    one
      = "one" s {return 1;}

    two
      = "to" s {return 2;}

    twah
      = "twah" s {return 2;}

    four
      = "for" s {return 4;}

    quads
      = "quads" s {return 4;}

    zero
      = "oh" s {return 0;}

    """
