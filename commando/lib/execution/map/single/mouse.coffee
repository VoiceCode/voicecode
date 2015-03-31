_.extend Commands.mapping,
  "duke":
    kind: "action"
    grammarType: "individual"
    description: "mouse double click"
    tags: ["mouse"]
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
    tags: ["mouse"]
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
    tags: ["mouse"]
    actions: [
      kind: "key"
      key: "I"
      modifiers: ["command", "option", "control", "shift"]
      delay: 0.1
    ]
  "triplick":
    kind: "combo"
    grammarType: "individual"
    description: "mouse left click"
    tags: ["mouse"]
    combo: ["chiff", "chiff", "chiff"]
  "shicks":
    kind: "action"
    grammarType: "individual"
    description: "mouse shift click"
    tags: ["mouse"]
    actions: [
      kind: "key"
      key: "A"
      modifiers: ["command", "option", "control", "shift"]
      delay: 0.1
    ]
  "comlick":
    kind: "action"
    grammarType: "individual"
    description: "mouse command+click"
    tags: ["mouse"]
    actions: [
      kind: "key"
      key: "X"
      modifiers: ["command", "option", "control", "shift"]
      delay: 0.1
    ]
  "croplick":
    kind: "action"
    grammarType: "individual"
    description: "mouse option+click"
    tags: ["mouse"]
    actions: [
      kind: "key"
      key: "X"
      modifiers: ["command", "option", "control", "shift"]
      delay: 0.1
    ]
