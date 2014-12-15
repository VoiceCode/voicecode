_.extend Commands.mapping,
  "olly":
    kind: "action"
    grammarType: "individual"
    description: "select all"
    actions: [
      kind: "key"
      key: "A"
      modifiers: ["command"]
    ]
  "sparky":
    kind: "action"
    grammarType: "individual"
    description: "paste the alternate clipboard"
    actions: [
      kind: "key"
      key: "V"
      modifiers: ["command", "shift"]
    ]
  "allspark":
    kind: "action"
    grammarType: "individual"
    description: "select all then paste the clipboard"
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
    actions: [
      kind: "key"
      key: "V"
      modifiers: ["command"]
    ]
  "sage":
    kind: "action"
    grammarType: "individual"
    description: "file > save"
    actions: [
      kind: "key"
      key: "S"
      modifiers: ["command"]
    ]
  "stooshwick":
    kind: "action"
    grammarType: "individual"
    description: "copy whatever is selected then switch applications"
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
    actions: [
      kind: "key"
      key: "C"
      modifiers: ["command"]
    ]
  "allstoosh":
    kind: "action"
    grammarType: "individual"
    description: "select all then copy whatever is selected"
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
    aliases: ["snatched"]
    actions: [
      kind: "key"
      key: "X"
      modifiers: ["command"]
    ]
  "totch":
    kind: "action"
    grammarType: "numberCapture"
    repeatable: true
    description: "close a window or tab"
    actions: [
      kind: "key"
      key: "W"
      modifiers: ["command"]
    ]
  "marco":
    kind: "action"
    grammarType: "individual"
    description: "find"
    actions: [
      kind: "key"
      key: "F"
      modifiers: ["command"]
    ]
  "talky":
    kind: "action"
    grammarType: "individual"
    description: "open a new tab"
    actions: [
      kind: "key"
      key: "T"
      modifiers: ["command"]
    ]
  "randall":
    kind: "action"
    grammarType: "individual"
    description: "press escape"
    actions: [
      kind: "key"
      key: "Escape"
    ]
  "chomlug":
    kind: "action"
    grammarType: "individual"
    description: "press escape"
    actions: [
      kind: "key"
      key: "L"
      modifiers: ["command"]
    ]
  "storky":
    kind: "action"
    grammarType: "individual"
    description: "press the delete key twice (non-repeatable, for when you need to enter a number afterwards)"
    actions: [
      kind: "key"
      key: "Delete"
    ,
      kind: "key"
      key: "Delete"
    ]
  "stork":
    kind: "action"
    grammarType: "individual"
    description: "press the delete key (non-repeatable, for when you need to enter a number afterwards)"
    actions: [
      kind: "key"
      key: "Delete"
    ]

