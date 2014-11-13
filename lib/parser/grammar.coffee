class @Grammar
  constructor: () ->
  textCaptureCommands: ->
    @buildCommandList Commands.Utility.textCaptureCommands()
  numberCaptureCommands: ->
    @buildCommandList Commands.Utility.numberCaptureCommands()
  individualCommands: ->
    @buildCommandList Commands.Utility.individualCommands()
  oneArgumentCommands: ->
    @buildCommandList Commands.Utility.oneArgumentCommands()
  buildCommandList: (keys) ->
    results = []
    _.each keys, (name) ->
      if Commands.mapping[name].aliases?.length
        results.push name
      else
        results.push "\"#{name}\""
    results.join(' / ')
  aliases: ->
    results = []
    _.each Commands.mapping, (command, name) ->
      if command.aliases?.length
        alternates = _.map command.aliases, (alt) ->
          "'#{alt}'"
        alternates.push "'#{name}'"
        aliasLine = "#{name} = (#{alternates.join(" / ")}) {return '#{name}';}"
        results.push aliasLine
    results.join("\n")
  build: -> """
    {
      function makeInteger(o) {
        return parseInt(o.join(""), 10);
      }

      function sumArray (array) {
        for (var i = 0, sum = 0; i < array.length; sum += array[i++]);
        return sum;
      }

      var capitalLetters = {
        skyarch: "A",
        skybrov: "B",
        skychar: "C",
        skydell: "D",
        skyetch: "E",
        skyfomp: "F",
        skygoof: "G",
        skyhark: "H",
        skyice: "I",
        skyjinks: "J",
        skykoop: "K",
        skylug: "L",
        skymowsh: "M",
        skynerb: "N",
        skyork: "O",
        skypooch: "P",
        skyquash: "Q",
        skyrosh: "R",
        skysouk: "S",
        skyteek: "T",
        skyunks: "U",
        skyverge: "V",
        skywomp: "W",
        skytrex: "X",
        skyang: "Y",
        skyzoob: "Z",
      }

      function makeCapitalLetter (letter) {
        return capitalLetters[letter];
      }
    }

    start
      = phrase

    phrase
      = command+

    command
      = textCaptureCommand / numberCaptureCommand / individualCommand / oneArgumentCommand / literalNumber / literalCommand

    textCaptureCommand
      = left:textCaptureIdentifier right:textArgument? {return {command: left, arguments: right};}

    textCaptureIdentifier
      = identifier:(#{@textCaptureCommands()}) ss {return identifier;}


    #{@aliases()}

    textArgument
      = (capitalLetter / word)+

    numberCaptureCommand
      = left:numberCaptureIdentifier right:spokenInteger? {return {command: left, arguments: right};}

    numberCaptureIdentifier
      = identifier:(#{@numberCaptureCommands()}) ss {return identifier;}

    oneArgumentCommand
      = left:oneArgumentIdentifier right:(singleTextArgument / spokenInteger) {return {command: left, arguments: right};}

    oneArgumentIdentifier
      = identifier:(#{@oneArgumentCommands()}) ss {return identifier;}

    singleTextArgument
      = (word / symbol)

    individualCommand
      = identifier:individualIdentifier {return {command: identifier};}

    individualIdentifier
      = identifier:(#{@individualCommands()}) ss {return identifier;}

    literalCommand
      = text:(capitalLetter / word / symbol)+ {return {command: "literal", arguments: text};}

    literalNumber
      = number:exactInteger {return {command: "number", arguments: number};}

    capitalLetter
      = letter:(
        "skyarch" / "skybrov" / "skychar" / "skydell" / "skyetch" / "skyfomp" / "skygoof" / 
        "skyhark" / "skyice" / "skyjinks" / "skykoop" / "skylug" / "skymowsh" / "skynerb" /
        "skyork" / "skypooch" / "skyquash" / "skyrosh" / "skysouk" / "skyteek" / "skyunks" /
        "skyverge" / "skywomp" / "skytrex" / "skyang" / "skyzoob"
      ) ss {return makeCapitalLetter(letter);}
   

    s = " "*

    ss = " "+

    identifier = textCaptureIdentifier / numberCaptureIdentifier / individualIdentifier / oneArgumentIdentifier / "one" / "twah"

    word = !identifier text:([a-z]i / "." / "'" / "-")+ ss {return text.join('')}

    symbol = !identifier symbol:([$-/] / [:-?] / [{-~] / '!' / '"' / '^' / '_' / '`' / '[' / ']' / '#' / '@' / '\\\\') s {return symbol}


    integer "integer"
      = digits:[0-9]+ s {return makeInteger(digits);}

    spokenInteger
      = components:(oneThousand / oneHundred / one / two / four / integer)+
      {return sumArray(components);}

    exactInteger
      = components:(oneThousand / oneHundred / one / twah / integer)+
      {return sumArray(components);}

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

    """
