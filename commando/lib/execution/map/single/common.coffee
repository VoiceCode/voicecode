_.extend Commands.mapping,
  "olly":
    kind: "action"
    grammarType: "individual"
    description: "select all"
    tags: ["selection", "A"]
    actions: [
      kind: "key"
      key: "A"
      modifiers: ["command"]
    ]
  "sparky":
    kind: "action"
    grammarType: "individual"
    description: "paste the alternate clipboard"
    tags: ["V", "copy-paste"]
    actions: [
      kind: "key"
      key: "V"
      modifiers: ["command", "shift"]
    ]
  "allspark":
    kind: "action"
    grammarType: "individual"
    description: "select all then paste the clipboard"
    tags: ["V", "A", "copy-paste", "selection"]
    actions: [
      kind: "key"
      key: "A"
      modifiers: ["command"]
    ,
      kind: "key"
      key: "V"
      modifiers: ["command"]
    ]
  "spark":
    kind: "action"
    grammarType: "individual"
    description: "paste the clipboard"
    aliases: ["sparked"]
    tags: ["V", "copy-paste"]
    actions: [
      kind: "key"
      key: "V"
      modifiers: ["command"]
    ]
  "sparshock":
    kind: "action"
    grammarType: "individual"
    description: "paste the clipboard then press enter"
    tags: ["V", "copy-paste", "combo", "Return"]
    actions: [
      kind: "key"
      key: "V"
      modifiers: ["command"]
    ,
      kind: "key"
      key: "Return"
    ]
  "sage":
    kind: "action"
    grammarType: "individual"
    description: "file > save"
    tags: ["application", "command", "S"]
    actions: [
      kind: "key"
      key: "S"
      modifiers: ["command"]
    ]
  "sagewick":
    kind: "action"
    grammarType: "individual"
    description: "file > save"
    tags: ["application", "command", "S", "combo"]
    actions: [
      kind: "key"
      key: "S"
      modifiers: ["command"]
    ,
      kind: "key"
      key: "Tab"
      modifiers: ["command"]
    ]
  "stooshwick":
    kind: "action"
    grammarType: "individual"
    description: "copy whatever is selected then switch applications"
    tags: ["C", "copy-paste", "application", "system"]
    actions: [
      kind: "key"
      key: "C"
      modifiers: ["command"]
    ,
      kind: "key"
      key: "Tab"
      modifiers: ["command"]
    ]
  "stoosh":
    kind: "action"
    grammarType: "individual"
    description: "copy whatever is selected"
    tags: ["C", "copy-paste"]
    actions: [
      kind: "key"
      key: "C"
      modifiers: ["command"]
    ]
  "allstoosh":
    kind: "action"
    grammarType: "individual"
    description: "select all then copy whatever is selected"
    tags: ["A", "C", "copy-paste", "selection"]
    actions: [
      kind: "key"
      key: "A"
      modifiers: ["command"]
    ,
      kind: "key"
      key: "C"
      modifiers: ["command"]
    ]
  "snatch":
    kind: "action"
    grammarType: "individual"
    description: "cut whatever is selected"
    tags: ["X", "copy-paste"]
    aliases: ["snatched"]
    actions: [
      kind: "key"
      key: "X"
      modifiers: ["command"]
    ]
  "totch":
    kind: "action"
    grammarType: "individual"
    description: "close a window or tab"
    tags: ["application", "command", "W"]
    actions: [
      kind: "key"
      key: "W"
      modifiers: ["command"]
    ]
  "marco":
    kind: "action"
    grammarType: "individual"
    description: "find"
    tags: ["application", "command", "F"]
    actions: [
      kind: "key"
      key: "F"
      modifiers: ["command"]
    ]
  "talky":
    kind: "action"
    grammarType: "individual"
    description: "open a new tab"
    tags: ["application", "command", "T"]
    actions: [
      kind: "key"
      key: "T"
      modifiers: ["command"]
    ]
  "randall":
    kind: "action"
    grammarType: "individual"
    description: "press escape"
    tags: ["Escape"]
    actions: [
      kind: "key"
      key: "Escape"
    ]
