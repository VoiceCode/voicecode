_.extend Commands.mapping,
  "dookoosh":
    kind: "action"
    grammarType: "individual"
    description: "mouse double click, then copy"
    tags: ["mouse", "combo"]
    actions: [
      kind: "key"
      key: "P"
      modifiers: ["command", "option", "control", "shift"]
      delay: 0.1
    ,
      kind: "key"
      key: "C"
      modifiers: ["command"]
    ]
  "doopark":
    kind: "action"
    grammarType: "individual"
    description: "mouse double click, then paste"
    tags: ["mouse", "combo"]
    actions: [
      kind: "key"
      key: "P"
      modifiers: ["command", "option", "control", "shift"]
      delay: 0.1
    ,
      kind: "key"
      key: "V"
      modifiers: ["command"]
    ]
  "chiffpark":
    kind: "action"
    grammarType: "individual"
    description: "mouse single click, then paste"
    tags: ["mouse", "combo"]
    actions: [
      kind: "key"
      key: "I"
      modifiers: ["command", "option", "control", "shift"]
      delay: 0.1
    ,
      kind: "key"
      key: "V"
      modifiers: ["command"]
    ]
