Commands.createDisabled
  "dot":
    findable: "."
    aliases: ["."]
    tags: ["symbol", "recommended"]
    action: ->
      @string "."
  "star":
    aliases: ["*"]
    findable: "*"
    tags: ["symbol", "recommended"]
    action: ->
      @string "*"
  "slash":
    aliases: ["/"]
    findable: "/"
    tags: ["symbol", "recommended"]
    action: ->
      @string "/"
  "quackish":
    # aliases: ["\\"]
    findable: "\\"
    tags: ["symbol", "recommended"]
    action: ->
      @string "\\"
  "comma":
    aliases: [","]
    findable: ","
    tags: ["symbol", "recommended"]
    action: ->
      @string ","
  "tilde":
    aliases: ["~"]
    findable: "~"
    tags: ["symbol", "recommended"]
    action: ->
      @string "~"
  "colon":
    aliases: [":"]
    findable: ":"
    tags: ["symbol", "recommended"]
    action: ->
      @string ":"
  "equeft":
    findable: " = "
    tags: ["symbol", "recommended"]
    action: ->
      @string " = "
  "smaqual":
    tags: ["symbol", "recommended"]
    findable: "="
    action: ->
      @string "="
  "qualcoif":
    tags: ["symbol", "quotes", "recommended"]
    findable: '="'
    action: ->
      @string '=""'
      @key "Left"
  "qualposh":
    findable: "='"
    tags: ["symbol", "quotes", "recommended"]
    action: ->
      @string "=''"
      @key "Left"
  "prexcoif":
    description: "inserts parentheses then double quotes leaving cursor inside them. If text is selected, will wrap the selected text"
    tags: ["symbol", "quotes", "recommended"]
    action: ->
      if @canDetermineSelections() and @isTextSelected()
        t = @getSelectedText()
        @string('("' + t + '")')
      else
        @string '("")'
        @key "Left"
        @key "Left"
  "prex":
    description: "inserts parentheses leaving cursor inside them. If text is selected, will wrap the selected text"
    tags: ["symbol", "recommended"]
    findable: "()"
    action: ->
      if @canDetermineSelections() and @isTextSelected()
        t = @getSelectedText()
        @string("(#{t})")
      else
        @string "()"
        @key "Left"
  "prekris":
    tags: ["symbol", "recommended"]
    action: ->
      @string "()"
  "brax":
    description: "inserts brackets leaving cursor inside them. If text is selected, will wrap the selected text"
    tags: ["symbol", "recommended"]
    findable: "[]"
    action: ->
      if @canDetermineSelections() and @isTextSelected()
        t = @getSelectedText()
        @string("[#{t}]")
      else
        @string "[]"
        @key "Left"
  "kirksorp":
    tags: ["symbol", "recommended"]
    findable: "{"
    action: ->
      @string "{"
  "kirkos":
    tags: ["symbol", "recommended"]
    findable: "}"
    action: ->
      @string "}"
  "kirk":
    tags: ["symbol", "recommended"]
    findable: "{}"
    action: ->
      @string "{}"
      @key "Left"
  "dekirk":
    tags: ["symbol", "recommended"]
    findable: "{}"
    action: ->
      @string " {}"
      @key "Left"
  "kirblock":
    tags: ["symbol", "recommended"]
    action: ->
      @string "{}"
      @key "Left"
      @key "Return"
  "prank":
    tags: ["symbol", "recommended"]
    description: "inserts 2 spaces leaving cursor in the middle. If text is selected, will wrap the selected text in spaces"
    findable: "  "
    action: ->
      if @canDetermineSelections() and @isTextSelected()
        t = @getSelectedText()
        @string(" #{t} ")
      else
        @string "  "
        @key "Left"
  "deprex":
    tags: ["symbol", "recommended"]
    findable: "()"
    action: ->
      @string " ()"
      @key "Left"
  "debrax":
    tags: ["symbol", "recommended"]
    findable: "[]"
    action: ->
      @string " []"
      @key "Left"
  "minquall":
    tags: ["symbol", "recommended"]
    findable: " -= "
    action: ->
      @string " -= "
  "pluqual":
    tags: ["symbol", "recommended"]
    findable: " += "
    action: ->
      @string " += "
  "banquall":
    tags: ["symbol", "recommended"]
    findable: " != "
    action: ->
      @string " != "
  "longqual":
    tags: ["symbol", "recommended"]
    findable: " == "
    action: ->
      @string " == "
  "lessqual":
    tags: ["symbol", "recommended"]
    findable: " <= "
    action: ->
      @string " <= "
  "grayqual":
    tags: ["symbol", "recommended"]
    findable: " >= "
    action: ->
      @string " >= "
  "posh":
    tags: ["symbol", "quotes", "recommended"]
    aliases: ["pash"]
    findable: "'"
    action: ->
      @string "''"
      @key "Left"
  "deeposh":
    tags: ["symbol", "quotes", "recommended"]
    findable: "'"
    action: ->
      @string " ''"
      @key "Left"
  "coif":
    tags: ["symbol", "quotes", "recommended"]
    aliases: ["coiffed"]
    description: "inserts quotes leaving cursor inside them. If text is selected, will wrap the selected text"
    findable: "\""
    action: ->
      if @canDetermineSelections() and @isTextSelected()
        t = @getSelectedText()
        @string("\"#{t}\"")
      else
        @string '""'
        @key "Left"
  "decoif":
    tags: ["symbol", "quotes", "recommended"]
    findable: "\""
    action: ->
      @string ' ""'
      @key "Left"
  "shrocket":
    tags: ["symbol", "recommended"]
    findable: " => "
    action: ->
      @string " => "
  "swipe":
    tags: ["symbol", "recommended"]
    aliases: ["swiped", "swipes"]
    findable: ", "
    action: ->
      @string ", "
  "swipshock":
    tags: ["symbol", "recommended"]
    action: ->
      @key ","
      @key "Return"
  "coalgap":
    tags: ["symbol", "recommended"]
    findable: ": "
    action: ->
      @string ": "
  "coalshock":
    tags: ["symbol", "recommended"]
    findable: ":\r"
    action: ->
      @key ":"
      @key "Return"
  "divy":
    tags: ["symbol", "recommended"]
    findable: " / "
    action: ->
      @string " / "
  "sinker":
    tags: ["symbol", "recommended"]
    findable: ";"
    action: ->
      @key "Right", ['command']
      @key ';'
  "sunkshock":
    tags: ["symbol", "recommended"]
    aliases: ["sinkshock"] #TODO remove later
    action: ->
      @key ";"
      @key 'Return'
  "sunk":
    tags: ["symbol", "recommended"]
    aliases: ["stunk"]
    findable: ";"
    action: ->
      @key ";"
  "clamor":
    tags: ["symbol", "recommended"]
    aliases: ["clamber", "clamour"]
    findable: "!"
    action: ->
      @key "!"
  "loco":
    tags: ["symbol", "recommended"]
    findable: "@"
    action: ->
      @string "@"
  "deloco":
    tags: ["symbol", "recommended"]
    findable: " @"
    action: ->
      @string " @"
  "amper":
    tags: ["symbol", "recommended"]
    findable: "&"
    action: ->
      @string "&"
  "damper":
    tags: ["symbol", "recommended"]
    findable: " & "
    action: ->
      @string " & "
  "pounder":
    tags: ["symbol", "recommended"]
    findable: "#"
    action: ->
      @string "#"
  "questo":
    tags: ["symbol", "recommended"]
    findable: "?"
    action: ->
      @string "?"
  "bartrap":
    tags: ["symbol", "recommended"]
    findable: "||"
    action: ->
      @string "||"
      @key "Left"
  "goalpost":
    tags: ["symbol", "recommended"]
    findable: " || "
    action: ->
      @string " || "
  "orquals":
    tags: ["symbol", "recommended"]
    findable: " ||= "
    action: ->
      @string " ||= "
  "spike":
    tags: ["symbol", "recommended"]
    findable: "|"
    action: ->
      @string "|"
  "angler":
    description: "inserts angle brackets leaving cursor inside them. If text is selected, will wrap the selected text"
    tags: ["symbol", "recommended"]
    findable: "<>"
    action: ->
      if @canDetermineSelections() and @isTextSelected()
        t = @getSelectedText()
        @string("<#{t}>")
      else
        @string "<>"
        @key "Left"
  "plus":
    tags: ["symbol", "recommended"]
    findable: "+"
    action: ->
      @string "+"
  "deplush":
    tags: ["symbol", "recommended"]
    findable: " + "
    action: ->
      @string " + "
  "minus":
    tags: ["symbol", "minus", "recommended"]
    findable: "-"
    action: ->
      @string "-"
  "deminus":
    tags: ["symbol", "minus", "recommended"]
    findable: " - "
    action: ->
      @string " - "
  "skoofin":
    tags: ["symbol", "minus", "recommended"]
    findable: " -"
    action: ->
      @string " -"
  "lambo":
    aliases: ["limbo"]
    tags: ["symbol", "recommended"]
    findable: "->"
    action: ->
      @string "->"
  "quatches":
    tags: ["symbol", "quotes", "recommended"]
    findable: '"'
    action: ->
      @string '"'
  "quatchet":
    tags: ["symbol", "quotes", "recommended"]
    findable: "'"
    action: ->
      @string "'"
  "percy":
    tags: ["symbol", "recommended"]
    findable: "%"
    action: ->
      @string "%"
  "depercy":
    tags: ["symbol", "recommended"]
    findable: " % "
    action: ->
      @string " % "
  "chriskoosh":
    tags: ["symbol", "recommended"]
    findable: " "
    action: ->
      @key "Right"
      @key " "
  "dolly":
    tags: ["symbol", "recommended"]
    aliases: ["dalai", "dawley", "donnelly", "donley", "dali"]
    findable: "$"
    action: ->
      @string "$"
  "clangle":
    tags: ["symbol", "recommended"]
    findable: "<"
    action: ->
      @string "<"
  "declangle":
    tags: ["symbol", "recommended"]
    findable: " < "
    action: ->
      @string " < "
  "langlang":
    tags: ["symbol", "recommended"]
    pronunciation: "lang glang"
    findable: "<<"
    action: ->
      @string "<<"
  "wrangle":
    tags: ["symbol", "recommended"]
    findable: ">"
    action: ->
      @string ">"
  "derangle":
    tags: ["symbol", "recommended"]
    findable: " > "
    action: ->
      @string " > "
  "rangrang":
    tags: ["symbol", "recommended"]
    pronunciation: "rang grang"
    findable: ">>"
    action: ->
      @string ">>"
  "precorp":
    tags: ["symbol", "recommended"]
    findable: "("
    action: ->
      @string "("
  "prekose":
    tags: ["symbol", "recommended"]
    findable: ")"
    action: ->
      @string ")"
  "brackorp":
    tags: ["symbol", "recommended"]
    findable: "["
    action: ->
      @string "["
  "brackose":
    tags: ["symbol", "recommended"]
    findable: "]"
    action: ->
      @string "]"
  "crunder":
    tags: ["symbol", "recommended"]
    findable: "_"
    action: ->
      @string "_"
  "coaltwice":
    tags: ["symbol", "recommended"]
    findable: "::"
    action: ->
      @string "::"
  "mintwice":
    tags: ["symbol", "minus", "recommended"]
    findable: "--"
    action: ->
      @string "--"
  "tinker":
    tags: ["symbol", "recommended"]
    findable: "`"
    action: ->
      @string "`"
  "caret":
    tags: ["symbol", "recommended"]
    findable: "^"
    # aliases: ["^"]
    action: ->
      @string "^"
  "pixel":
    tags: ["symbol"]
    findable: "px"
    action: ->
      @string "px "
  "quesquall":
    tags: ["symbol"]
    findable: " ?= "
    action: ->
      @string " ?= "
