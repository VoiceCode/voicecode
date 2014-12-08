_.extend Commands.mapping,
  "shin":
    kind: "action"
    grammarType: "individual"
    description: "does nothing, but enters into voice code"
    actions: []
  "skoosh":
    kind: "action"
    grammarType: "individual"
    description: "insert a space"
    actions: [
      kind: "key"
      key: "Space"
    ]
  "shockoon":
    kind: "action"
    description: "Inserts a new line below the current line"
    grammarType: "individual"
    actions: [
      kind: "key"
      key: "Right"
      modifiers: ["command"]
    ,
      kind: "key"
      key: "Return"
    ]
  "shocktar":
    kind: "action"
    description: "Inserts a new line then a tab"
    grammarType: "individual"
    actions: [
      kind: "key"
      key: "Return"
    ,
      kind: "key"
      key: "Tab"
    ]
  "shockey":
    kind: "action"
    description: "Inserts a new line above the current line"
    grammarType: "individual"
    actions: [
      kind: "key"
      key: "Up"
    ,
      kind: "key"
      key: "Right"
      modifiers: ["command"]
    ,
      kind: "key"
      key: "Return"
    ]