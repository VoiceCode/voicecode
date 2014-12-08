_.extend Commands.mapping,
  "duke":
    kind: "action"
    grammarType: "individual"
    description: "mouse double click"
    actions: [
      kind: "key"
      key: "P"
      modifiers: ["command", "option", "control", "shift"]
      delay: 0.1
    ]
  "chipper":
    kind: "action"
    grammarType: "individual"
    description: "mouse right click"
    actions: [
      kind: "key"
      key: "O"
      modifiers: ["command", "option", "control", "shift"]
      delay: 0.1
    ]
  "chiff":
    kind: "action"
    grammarType: "individual"
    description: "mouse left click"
    actions: [
      kind: "key"
      key: "I"
      modifiers: ["command", "option", "control", "shift"]
      delay: 0.1
    ]
  "shicks":
    kind: "action"
    grammarType: "individual"
    description: "mouse shift click"
    actions: [
      kind: "key"
      key: "A"
      modifiers: ["command", "option", "control", "shift"]
      delay: 0.1
    ]
  "chibble":
    kind: "action"
    grammarType: "individual"
    description: "selects the entire line of text cursor hovers over"
    actions: [
      kind: "key"
      key: "I"
      modifiers: ["command", "option", "control", "shift"]
      delay: 0.1
    ,
      kind: "key"
      key: "Left"
      modifiers: ["command"]
    ,
      kind: "key"
      key: "Right"
      modifiers: ["command", "shift"]
    ]
