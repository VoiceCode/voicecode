Commands.create
  "dot":
    kind: "action"
    grammarType: "individual"
    aliases: ["."]
    tags: ["symbol"]
    action: ->
      @key "."
  "star":
    kind: "action"
    grammarType: "individual"
    aliases: ["*"]
    tags: ["symbol"]
    action: ->
      @key "*"
  "slash":
    kind: "action"
    grammarType: "individual"
    aliases: ["/"]
    tags: ["symbol"]
    action: ->
      @key "/"
  "comma":
    kind: "action"
    grammarType: "individual"
    aliases: [","]
    tags: ["symbol"]
    action: ->
      @key ","
  "tilde":
    kind: "action"
    grammarType: "individual"
    aliases: ["~"]
    tags: ["symbol"]
    action: ->
      @key "~"
  "colon":
    kind: "action"
    grammarType: "individual"
    aliases: [":"]
    tags: ["symbol"]
    action: ->
      @key ":"
  "equeft":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @string " = "
  "smaqual":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @key "="
  "qualquo":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "quotes"]
    action: ->
      @string '=""'
      @key "Left"
  "qualposh":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "quotes"]
    action: ->
      @string "=''"
      @key "Left"
  "prexcoif":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "quotes"]
    action: ->
      @string '("")'
      @key "Left"
      @key "Left"
  "prex":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @string "()"
      @key "Left"
  "prekris":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @string "()"
  "brax":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @string "[]"
      @key "Left"
  "kirksorp":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @key "{"
  "kirkos":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @key "}"
  "kirk":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @string "{}"
      @key "Left"
  "dekirk":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @string " {}"
      @key "Left"
  "kirblock":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @string "{}"
      @key "Left"
      @key "Return"
  "prank":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    description: "inserts 2 spaces then left arrow"
    action: ->
      @string "  "
      @key "Left"
  "deprex":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @string " ()"
      @key "Left"
  "debrax":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @string " []"
      @key "Left"
  "tranquil":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @string " -= "
  "pluqual":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @string " += "
  "banquall":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @string " != "
  "longqual":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @string " == "
  "lessqual":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @string " <= "
  "grayqual":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @string " >= "
  "posh":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "quotes"]
    aliases: ["pash"]
    action: ->
      @string "''"
      @key "Left"
  "deeposh":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "quotes"]
    action: ->
      @string " ''"
      @key "Left"
  "coif":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "quotes"]
    aliases: ["coiffed"]
    action: ->
      @string '""'
      @key "Left"
  "decoif":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "quotes"]
    action: ->
      @string ' ""'
      @key "Left"
  "shrocket":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @string " => "
  "swipe":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    aliases: ["swiped", "swipes"]
    action: ->
      @string ", "
  "swipshock":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @key ","
      @key "Return"
  "coalgap":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @string ": "
  "coalshock":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @key ":"
      @key "Return"
  "divy":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @string " / "
  "sinker":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @key "Right", ['command']
      @key ';'
  "sunkshock":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    aliases: ["sinkshock"] #TODO remove later
    action: ->
      @key ";"
      @key 'Return'
  "sunk":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    aliases: ["stunk"]
    action: ->
      @key ";"
  "clamor":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @key "!"
  "loco":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @key "@"
  "deloco":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @string " @"
  "amper":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @key "&"
  "damper":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @string " &"
  "pounder":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @key "#"
  "questo":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @key "?"
  "bartrap":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @string "||"
      @key "Left"
  "goalpost":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @string " || "
  "orquals":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @string " ||= "
  "spike":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @key "|"
  "angler":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @string "<>"
      @key "Left"
  "plus":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @key "+"
  "deplush":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @string " + "
  "minus":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "minus"]
    action: ->
      @key "-"
  "deminus":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "minus"]
    action: ->
      @string " - "
  "skoofin":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "minus"]
    action: ->
      @string " -"
  "lambo":
    kind: "action"
    grammarType: "individual"
    aliases: ["limbo"]
    tags: ["symbol"]
    action: ->
      @string "->"
  "quatches":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "quotes"]
    action: ->
      @key '"'
  "quatchet":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "quotes"]
    action: ->
      @key "'"
  "percy":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @key "%"
  "depercy":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @string " % "
  "chriskoosh":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @key "Right"
      @key " "
  "dolly":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    aliases: ["dalai", "dawley", "donnelly", "donley", "dali"]
    action: ->
      @key "$"
  "clangle":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @key "<"
  "declangle":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @string " < "
  "langlang":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    pronunciation: "lang glang"
    action: ->
      @string "<<"
  "wrangle":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @key ">"
  "derangle":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @string " > "
  "rangrang":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    pronunciation: "rang grang"
    action: ->
      @string ">>"
  "precorp":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @key "("
  "prekose":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @key ")"
  "brackorp":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @key "["
  "brackose":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @key "]"
  "crunder":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @key "_"
  "coaltwice":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @string "::"
  "mintwice":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "minus"]
    action: ->
      @string "--"
  "tinker":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    action: ->
      @key "`"
  "caret":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    # aliases: ["^"]
    action: ->
      @key "^"
  "pox":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol"]
    # aliases: ["^"]
    action: ->
      @string "px"
