_.extend Commands.mapping,
  ".":
    kind: "action"
    grammarType: "individual"
    aliases: ["dot"]
    actions: [
      kind: "key"
      key: "Period"
    ]
  "/":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "key"
      key: "Slash"
    ]
  "slash":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "key"
      key: "Slash"
    ]
  "quals":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: " = "
    ]
  "smaqual":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: "="
    ]
  "qualquo":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: "=\"\""
    ,
      kind: "key"
      key: "Left"
    ]
  "prex":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: "()"
    ,
      kind: "key"
      key: "Left"
    ]
  "brax":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: "[]"
    ,
      kind: "key"
      key: "Left"
    ]
  "kirk":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: "{}"
    ,
      kind: "key"
      key: "Left"
    ]
  "dekirk":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: " {}"
    ,
      kind: "key"
      key: "Left"
    ]
  "kirblock":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: "{}"
    ,
      kind: "key"
      key: "Left"
    ,
      kind: "key"
      key: "Return"
    ]
  "prank":
    kind: "action"
    grammarType: "individual"
    description: "inserts 2 spaces then left arrow"
    actions: [
      kind: "keystroke"
      keystroke: "  "
    ,
      kind: "key"
      key: "Left"
    ]
  "deprex":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: " ()"
    ,
      kind: "key"
      key: "Left"
    ]
  "debrax":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: " []"
    ,
      kind: "key"
      key: "Left"
    ]
  "tranquil":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: " -= "
    ]
  "pluqual":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: " += "
    ]
  "banquall":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: " != "
    ]
  "longqual":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: " == "
    ]
  "lessqual":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: " <= "
    ]
  "grayqual":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: " >= "
    ]
  "posh":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: "''"
    ,
      kind: "key"
      key: "Left"
    ]  
  "deeposh":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: " ''"
    ,
      kind: "key"
      key: "Left"
    ]  
  "coif":
    kind: "action"
    grammarType: "individual"
    aliases: ["coiffed"]
    actions: [
      kind: "keystroke"
      keystroke: '\"\"'
    ,
      kind: "key"
      key: "Left"
    ]  
  "decoif":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: " \"\""
    ,
      kind: "key"
      key: "Left"
    ]  
  "shrocket":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: " => "
    ]
  "swipe":
    kind: "action"
    grammarType: "individual"
    aliases: ["swiped"]
    actions: [
      kind: "keystroke"
      keystroke: ", "
    ]
  "swipshock":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: ","
    ,
      kind: "key"
      key: "Return"
    ]
  "coalgap":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: ": "
    ]
  "coalshock":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: ":"
    ,
      kind: "key"
      key: "Return"
    ]
  "divy":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: " / "
    ]
  "sinker":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: ";"
    ]
  "sinkshock":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: ";"
    ,
      kind: "key"
      key: "Return"
    ]
  "clamor":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: "!"
    ]
  "loco":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: "@"
    ]
  "deloco":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: " @"
    ]
  "amper":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: "&"
    ]
  "damper":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: " & "
    ]
  "pounder":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: "#"
    ]
  "questo":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: "?"
    ]
  "bartrap":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: "||"
    ,
      kind: "key"
      key: "Left"
    ]
  "goalpost":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: " || "
    ]
  "orquals":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: " ||= "
    ]
  "spike":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: "|"
    ]
  "angler":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: "<>"
    ,
      kind: "key"
      key: "Left"
    ]
  "plus":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: "+"
    ]
  "deplush":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: " + "
    ]
  "minus":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: "-"
    ]
  "deminus":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: " - "
    ]
  "skoofin":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: " -"
    ]
  "lambo":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: "->"
    ]
  "quatches":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: "\""
    ]
  "quatchet":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: "'"
    ]
  "percy":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: "%"
    ]
  "depercy":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: " % "
    ]
  "riskoosh":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "key"
      key: "Right"
    ,
      kind: "keystroke"
      keystroke: " "
    ]
  "dolly":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: "$"
    ]
  "clangle":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: "<"
    ]
  "langlang":
    kind: "action"
    grammarType: "individual"
    pronunciation: "lang glang"
    actions: [
      kind: "keystroke"
      keystroke: "<<"
    ]
  "wrangle":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: ">"
    ]
  "rangrang":
    kind: "action"
    grammarType: "individual"
    pronunciation: "rang grang"
    actions: [
      kind: "keystroke"
      keystroke: ">>"
    ]
  "brackorp":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: "["
    ]
  "brackose":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: "]"
    ]
  "kirksorp":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: "{"
    ]
  "kirkos":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: "}"
    ]
  "crunder":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: "_"
    ]
  "coaltwice":
    kind: "action"
    grammarType: "individual"
    actions: [
      kind: "keystroke"
      keystroke: "::"
    ]

  