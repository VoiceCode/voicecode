Commands.create
  "dot":
    kind: "action"
    grammarType: "individual"
    findable: "."
    aliases: ["."]
    tags: ["symbol", "recommended"]
    action: ->
      @string "."
  "star":
    kind: "action"
    grammarType: "individual"
    aliases: ["*"]
    findable: "*"
    tags: ["symbol", "recommended"]
    action: ->
      @string "*"
  "slash":
    kind: "action"
    grammarType: "individual"
    aliases: ["/"]
    findable: "/"
    tags: ["symbol", "recommended"]
    action: ->
      @string "/"
  "comma":
    kind: "action"
    grammarType: "individual"
    aliases: [","]
    findable: ","
    tags: ["symbol", "recommended"]
    action: ->
      @string ","
  "tilde":
    kind: "action"
    grammarType: "individual"
    aliases: ["~"]
    findable: "~"
    tags: ["symbol", "recommended"]
    action: ->
      @string "~"
  "colon":
    kind: "action"
    grammarType: "individual"
    aliases: [":"]
    findable: ":"
    tags: ["symbol", "recommended"]
    action: ->
      @string ":"
  "equeft":
    kind: "action"
    grammarType: "individual"
    findable: " = "
    tags: ["symbol", "recommended"]
    action: ->
      @string " = "
  "smaqual":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: "="
    action: ->
      @string "="
  "qualcoif":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "quotes", "recommended"]
    findable: '="'
    action: ->
      @string '=""'
      @key "Left"
  "qualposh":
    kind: "action"
    grammarType: "individual"
    findable: "='"
    tags: ["symbol", "quotes", "recommended"]
    action: ->
      @string "=''"
      @key "Left"
  "prexcoif":
    kind: "action"
    grammarType: "individual"
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
    kind: "action"
    grammarType: "individual"
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
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @string "()"
  "brax":
    kind: "action"
    grammarType: "individual"
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
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: "{"
    action: ->
      @string "{"
  "kirkos":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: "}"
    action: ->
      @string "}"
  "kirk":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: "{}"
    action: ->
      @string "{}"
      @key "Left"
  "dekirk":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: "{}"
    action: ->
      @string " {}"
      @key "Left"
  "kirblock":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @string "{}"
      @key "Left"
      @key "Return"
  "prank":
    kind: "action"
    grammarType: "individual"
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
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: "()"
    action: ->
      @string " ()"
      @key "Left"
  "debrax":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: "[]"
    action: ->
      @string " []"
      @key "Left"
  "minquall":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: " -= "
    action: ->
      @string " -= "
  "pluqual":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: " += "
    action: ->
      @string " += "
  "banquall":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: " != "
    action: ->
      @string " != "
  "longqual":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: " == "
    action: ->
      @string " == "
  "lessqual":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: " <= "
    action: ->
      @string " <= "
  "grayqual":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: " >= "
    action: ->
      @string " >= "
  "posh":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "quotes", "recommended"]
    aliases: ["pash"]
    findable: "'"
    action: ->
      @string "''"
      @key "Left"
  "deeposh":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "quotes", "recommended"]
    findable: "'"
    action: ->
      @string " ''"
      @key "Left"
  "coif":
    kind: "action"
    grammarType: "individual"
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
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "quotes", "recommended"]
    findable: "\""
    action: ->
      @string ' ""'
      @key "Left"
  "shrocket":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: " => "
    action: ->
      @string " => "
  "swipe":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    aliases: ["swiped", "swipes"]
    findable: ", "
    action: ->
      @string ", "
  "swipshock":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @key ","
      @key "Return"
  "coalgap":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: ": "
    action: ->
      @string ": "
  "coalshock":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: ":\r"
    action: ->
      @key ":"
      @key "Return"
  "divy":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: " / "
    action: ->
      @string " / "
  "sinker":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: ";"
    action: ->
      @key "Right", ['command']
      @key ';'
  "sunkshock":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    aliases: ["sinkshock"] #TODO remove later
    action: ->
      @key ";"
      @key 'Return'
  "sunk":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    aliases: ["stunk"]
    findable: ";"
    action: ->
      @key ";"
  "clamor":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    aliases: ["clamber", "clamour"]
    findable: "!"
    action: ->
      @key "!"
  "loco":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: "@"
    action: ->
      @string "@"
  "deloco":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: " @"
    action: ->
      @string " @"
  "amper":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: "&"
    action: ->
      @string "&"
  "damper":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: " & "
    action: ->
      @string " & "
  "pounder":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: "#"
    action: ->
      @string "#"
  "questo":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: "?"
    action: ->
      @string "?"
  "bartrap":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: "||"
    action: ->
      @string "||"
      @key "Left"
  "goalpost":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: " || "
    action: ->
      @string " || "
  "orquals":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: " ||= "
    action: ->
      @string " ||= "
  "spike":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: "|"
    action: ->
      @string "|"
  "angler":
    kind: "action"
    grammarType: "individual"
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
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: "+"
    action: ->
      @string "+"
  "deplush":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: " + "
    action: ->
      @string " + "
  "minus":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "minus", "recommended"]
    findable: "-"
    action: ->
      @string "-"
  "deminus":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "minus", "recommended"]
    findable: " - "
    action: ->
      @string " - "
  "skoofin":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "minus", "recommended"]
    findable: " -"
    action: ->
      @string " -"
  "lambo":
    kind: "action"
    grammarType: "individual"
    aliases: ["limbo"]
    tags: ["symbol", "recommended"]
    findable: "->"
    action: ->
      @string "->"
  "quatches":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "quotes", "recommended"]
    findable: '"'
    action: ->
      @string '"'
  "quatchet":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "quotes", "recommended"]
    findable: "'"
    action: ->
      @string "'"
  "percy":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: "%"
    action: ->
      @string "%"
  "depercy":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: " % "
    action: ->
      @string " % "
  "chriskoosh":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: " "
    action: ->
      @key "Right"
      @key " "
  "dolly":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    aliases: ["dalai", "dawley", "donnelly", "donley", "dali"]
    findable: "$"
    action: ->
      @string "$"
  "clangle":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: "<"
    action: ->
      @string "<"
  "declangle":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: " < "
    action: ->
      @string " < "
  "langlang":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    pronunciation: "lang glang"
    findable: "<<"
    action: ->
      @string "<<"
  "wrangle":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: ">"
    action: ->
      @string ">"
  "derangle":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: " > "
    action: ->
      @string " > "
  "rangrang":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    pronunciation: "rang grang"
    findable: ">>"
    action: ->
      @string ">>"
  "precorp":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: "("
    action: ->
      @string "("
  "prekose":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: ")"
    action: ->
      @string ")"
  "brackorp":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: "["
    action: ->
      @string "["
  "brackose":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: "]"
    action: ->
      @string "]"
  "crunder":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: "_"
    action: ->
      @string "_"
  "coaltwice":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: "::"
    action: ->
      @string "::"
  "mintwice":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "minus", "recommended"]
    findable: "--"
    action: ->
      @string "--"
  "tinker":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: "`"
    action: ->
      @string "`"
  "caret":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    findable: "^"
    # aliases: ["^"]
    action: ->
      @string "^"
  "pixel":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    findable: "px"
    # aliases: ["^"]
    action: ->
      @string "px "
  "quesquall":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    findable: " ?= "
    action: ->
      @string " ?= "
