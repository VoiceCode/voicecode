Commands.createDisabledWithDefaults
  tags: ["symbol", "recommended"]
,
  "dot":
    findable: "."
    aliases: ["."]
    spaceBefore: true
    action: ->
      @string "."
  "star":
    aliases: ["*"]
    findable: "*"
    spaceBefore: true
    action: ->
      @string "*"
  "slash":
    aliases: ["/"]
    findable: "/"
    spaceBefore: true
    action: ->
      @string "/"
  "quackish":
    # aliases: ["\\"]
    findable: "\\"
    action: ->
      @string "\\"
  "comma":
    aliases: [","]
    findable: ","
    action: ->
      @string ","
  "tilde":
    aliases: ["~"]
    findable: "~"
    spaceBefore: true
    action: ->
      @string "~"
  "colon":
    aliases: [":"]
    findable: ":"
    spaceBefore: true
    action: ->
      @string ":"
  "equeft":
    findable: " = "
    action: ->
      @string " = "
  "smaqual":
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
    findable: "()"
    spaceBefore: true
    action: ->
      if @canDetermineSelections() and @isTextSelected()
        t = @getSelectedText()
        @string("(#{t})")
      else
        @string "()"
        @key "Left"
  "prekris":
    action: ->
      @string "()"
  "brax":
    description: "inserts brackets leaving cursor inside them. If text is selected, will wrap the selected text"
    findable: "[]"
    spaceBefore: true
    action: ->
      if @canDetermineSelections() and @isTextSelected()
        t = @getSelectedText()
        @string("[#{t}]")
      else
        @string "[]"
        @key "Left"
  "kirksorp":
    findable: "{"
    action: ->
      @string "{"
  "kirkos":
    findable: "}"
    action: ->
      @string "}"
  "kirk":
    findable: "{}"
    spaceBefore: true
    action: ->
      @string "{}"
      @key "Left"
  # "dekirk":
  #   findable: "{}"
  #   action: ->
  #     @string " {}"
  #     @key "Left"
  "kirblock":
    action: ->
      @string "{}"
      @key "Left"
      @key "Return"
  "prank":
    description: "inserts 2 spaces leaving cursor in the middle. If text is selected, will wrap the selected text in spaces"
    findable: "  "
    action: ->
      if @canDetermineSelections() and @isTextSelected()
        t = @getSelectedText()
        @string(" #{t} ")
      else
        @string "  "
        @key "Left"
  # "deprex":
  #   findable: "()"
  #   action: ->
  #     @string " ()"
  #     @key "Left"
  # "debrax":
  #   findable: "[]"
  #   action: ->
  #     @string " []"
  #     @key "Left"
  "minquall":
    findable: " -= "
    action: ->
      @string " -= "
  "pluqual":
    findable: " += "
    action: ->
      @string " += "
  "banquall":
    findable: " != "
    action: ->
      @string " != "
  "longqual":
    findable: " == "
    action: ->
      @string " == "
  "lessqual":
    findable: " <= "
    action: ->
      @string " <= "
  "grayqual":
    findable: " >= "
    action: ->
      @string " >= "
  "posh":
    tags: ["symbol", "quotes", "recommended"]
    aliases: ["pash"]
    spaceBefore: true
    findable: "''"
    action: ->
      @string "''"
      @key "Left"
  # "deeposh":
  #   tags: ["symbol", "quotes", "recommended"]
  #   findable: "'"
  #   action: ->
  #     @string " ''"
  #     @key "Left"
  "coif":
    tags: ["symbol", "quotes", "recommended"]
    aliases: ["coiffed"]
    description: "inserts quotes leaving cursor inside them. If text is selected, will wrap the selected text"
    findable: '""'
    spaceBefore: true
    action: ->
      if @canDetermineSelections() and @isTextSelected()
        t = @getSelectedText()
        @string("\"#{t}\"")
      else
        @string '""'
        @key "Left"
  # "decoif":
  #   tags: ["symbol", "quotes", "recommended"]
  #   findable: "\""
  #   action: ->
  #     @string ' ""'
  #     @key "Left"
  "shrocket":
    findable: " => "
    action: ->
      @string " => "
  "swipe":
    aliases: ["swiped", "swipes"]
    findable: ", "
    action: ->
      @string ", "
  "coalgap":
    findable: ": "
    action: ->
      @string ": "
  "coalshock":
    findable: ":\r"
    action: ->
      @key ":"
      @key "Return"
  "divy":
    findable: " / "
    action: ->
      @string " / "
  "sinker":
    findable: ";"
    action: ->
      @key "Right", 'command'
      @key ';'
  "sunkshock":
    aliases: ["sinkshock"] #TODO remove later
    action: ->
      @key ";"
      @key 'Return'
  "sunk":
    aliases: ["stunk"]
    findable: ";"
    action: ->
      @key ";"
  "clamor":
    aliases: ["clamber", "clamour"]
    findable: "!"
    action: ->
      @key "!"
  "loco":
    aliases: ["@"]
    findable: "@"
    spaceBefore: true
    action: ->
      @string "@"
  # "deloco":
  #   findable: " @"
  #   action: ->
  #     @string " @"
  "amper":
    findable: "&"
    action: ->
      @string "&"
  "damper":
    findable: " & "
    action: ->
      @string " & "
  "pounder":
    findable: "#"
    repeatable: true
    spaceBefore: true
    action: ->
      @string "#"
  "questo":
    findable: "?"
    action: ->
      @string "?"
  "bartrap":
    findable: "||"
    action: ->
      @string "||"
      @key "Left"
  "goalpost":
    findable: " || "
    action: ->
      @string " || "
  "orquals":
    findable: " ||= "
    action: ->
      @string " ||= "
  "spike":
    findable: "|"
    action: ->
      @string "|"
  "angler":
    description: "inserts angle brackets leaving cursor inside them. If text is selected, will wrap the selected text"
    findable: "<>"
    action: ->
      if @canDetermineSelections() and @isTextSelected()
        t = @getSelectedText()
        @string("<#{t}>")
      else
        @string "<>"
        @key "Left"
  "plus":
    findable: "+"
    spaceBefore: true
    action: ->
      @string "+"
  "deplush":
    findable: " + "
    action: ->
      @string " + "
  "minus":
    tags: ["symbol", "minus", "recommended"]
    repeatable: true
    findable: "-"
    spaceBefore: true
    action: ->
      @string "-"
  "deminus":
    tags: ["symbol", "minus", "recommended"]
    findable: " - "
    action: ->
      @string " - "
  "lambo":
    aliases: ["limbo"]
    findable: "->"
    spaceBefore: true
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
    findable: "%"
    spaceBefore: true
    action: ->
      @string "%"
  "depercy":
    findable: " % "
    action: ->
      @string " % "
  "dolly":
    aliases: ["dalai", "dawley", "donnelly", "donley", "dali", "dollies"]
    findable: "$"
    spaceBefore: true
    action: ->
      @string "$"
  "clangle":
    findable: "<"
    action: ->
      @string "<"
  "declangle":
    findable: " < "
    action: ->
      @string " < "
  "langlang":
    pronunciation: "lang glang"
    findable: "<<"
    action: ->
      @string "<<"
  "wrangle":
    findable: ">"
    action: ->
      @string ">"
  "derangle":
    findable: " > "
    action: ->
      @string " > "
  "rangrang":
    pronunciation: "rang grang"
    findable: ">>"
    action: ->
      @string ">>"
  "precorp":
    findable: "("
    action: ->
      @string "("
  "prekose":
    findable: ")"
    action: ->
      @string ")"
  "brackorp":
    findable: "["
    action: ->
      @string "["
  "brackose":
    findable: "]"
    action: ->
      @string "]"
  "crunder":
    findable: "_"
    action: ->
      @string "_"
  "coaltwice":
    findable: "::"
    action: ->
      @string "::"
  "mintwice":
    tags: ["symbol", "minus", "recommended"]
    findable: "--"
    action: ->
      @string "--"
  "tinker":
    findable: "`"
    action: ->
      @string "`"
  "caret":
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
  "ellipsis":
    findable: "..."
    action: ->
      @string "..."
