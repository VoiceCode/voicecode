Commands.create
  "dot":
    kind: "action"
    grammarType: "individual"
    aliases: ["."]
    tags: ["symbol", "recommended"]
    action: ->
      @key "."
  "star":
    kind: "action"
    grammarType: "individual"
    aliases: ["*"]
    tags: ["symbol", "recommended"]
    action: ->
      @key "*"
  "slash":
    kind: "action"
    grammarType: "individual"
    aliases: ["/"]
    tags: ["symbol", "recommended"]
    action: ->
      @key "/"
  "comma":
    kind: "action"
    grammarType: "individual"
    aliases: [","]
    tags: ["symbol", "recommended"]
    action: ->
      @key ","
  "tilde":
    kind: "action"
    grammarType: "individual"
    aliases: ["~"]
    tags: ["symbol", "recommended"]
    action: ->
      @key "~"
  "colon":
    kind: "action"
    grammarType: "individual"
    aliases: [":"]
    tags: ["symbol", "recommended"]
    action: ->
      @key ":"
  "equeft":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @string " = "
  "smaqual":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @key "="
  "qualcoif":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "quotes", "recommended"]
    action: ->
      @string '=""'
      @key "Left"
  "qualposh":
    kind: "action"
    grammarType: "individual"
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
    action: ->
      @key "{"
  "kirkos":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @key "}"
  "kirk":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @string "{}"
      @key "Left"
  "dekirk":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
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
    action: ->
      @string " ()"
      @key "Left"
  "debrax":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @string " []"
      @key "Left"
  "minquall":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @string " -= "
  "pluqual":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @string " += "
  "banquall":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @string " != "
  "longqual":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @string " == "
  "lessqual":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @string " <= "
  "grayqual":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @string " >= "
  "posh":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "quotes", "recommended"]
    aliases: ["pash"]
    action: ->
      @string "''"
      @key "Left"
  "deeposh":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "quotes", "recommended"]
    action: ->
      @string " ''"
      @key "Left"
  "coif":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "quotes", "recommended"]
    aliases: ["coiffed"]
    description: "inserts quotes leaving cursor inside them. If text is selected, will wrap the selected text"
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
    action: ->
      @string ' ""'
      @key "Left"
  "shrocket":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @string " => "
  "swipe":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    aliases: ["swiped", "swipes"]
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
    action: ->
      @string ": "
  "coalshock":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @key ":"
      @key "Return"
  "divy":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @string " / "
  "sinker":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
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
    action: ->
      @key ";"
  "clamor":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    aliases: ["clamber", "clamour"]
    action: ->
      @key "!"
  "loco":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @key "@"
  "deloco":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @string " @"
  "amper":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @key "&"
  "damper":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @string " &"
  "pounder":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @key "#"
  "questo":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @key "?"
  "bartrap":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @string "||"
      @key "Left"
  "goalpost":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @string " || "
  "orquals":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @string " ||= "
  "spike":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @key "|"
  "angler":
    kind: "action"
    grammarType: "individual"
    description: "inserts angle brackets leaving cursor inside them. If text is selected, will wrap the selected text"
    tags: ["symbol", "recommended"]
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
    action: ->
      @key "+"
  "deplush":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @string " + "
  "minus":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "minus", "recommended"]
    action: ->
      @key "-"
  "deminus":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "minus", "recommended"]
    action: ->
      @string " - "
  "skoofin":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "minus", "recommended"]
    action: ->
      @string " -"
  "lambo":
    kind: "action"
    grammarType: "individual"
    aliases: ["limbo"]
    tags: ["symbol", "recommended"]
    action: ->
      @string "->"
  "quatches":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "quotes", "recommended"]
    action: ->
      @key '"'
  "quatchet":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "quotes", "recommended"]
    action: ->
      @key "'"
  "percy":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @key "%"
  "depercy":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @string " % "
  "chriskoosh":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @key "Right"
      @key " "
  "dolly":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    aliases: ["dalai", "dawley", "donnelly", "donley", "dali"]
    action: ->
      @key "$"
  "clangle":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @key "<"
  "declangle":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @string " < "
  "langlang":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    pronunciation: "lang glang"
    action: ->
      @string "<<"
  "wrangle":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @key ">"
  "derangle":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @string " > "
  "rangrang":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    pronunciation: "rang grang"
    action: ->
      @string ">>"
  "precorp":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @key "("
  "prekose":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @key ")"
  "brackorp":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @key "["
  "brackose":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @key "]"
  "crunder":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @key "_"
  "coaltwice":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @string "::"
  "mintwice":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "minus", "recommended"]
    action: ->
      @string "--"
  "tinker":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    action: ->
      @key "`"
  "caret":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "recommended"]
    # aliases: ["^"]
    action: ->
      @key "^"
  "pixel":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    # aliases: ["^"]
    action: ->
      @string "px "
  "quesquall":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @string " ?= "
