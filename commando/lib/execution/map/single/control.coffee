_.extend Commands.mapping,
  "shin":
    kind: "action"
    grammarType: "individual"
    description: "does nothing, but enters into voice code"
    actions: []
    tags: ["text"]
  "skoosh":
    kind: "action"
    grammarType: "individual"
    description: "insert a space"
    tags: ["Space"]
    actions: [
      kind: "key"
      key: "Space"
    ]
  "skoopark":
    kind: "action"
    grammarType: "individual"
    description: "insert a space then paste the clipboard"
    tags: ["Space", "combo", "copy-paste",  "V"]
    actions: [
      kind: "key"
      key: "Space"
    ,
      kind: "key"
      key: "V"
      modifiers: ["command"]
    ]
  "shockoon":
    kind: "action"
    description: "Inserts a new line below the current line"
    grammarType: "individual"
    tags: ["Return", "combo"]
    contextualActions:
      "sublime": 
        requirements: [
          application: "Sublime Text"
        ]
        actions: [
          kind: "key"
          key: "Return"
          modifiers: ['command']
        ]
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
    tags: ["Return", "Tab", "combo"]
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
    tags: ["Return", "combo"]
    contextualActions:
      "sublime": 
        requirements: [
          application: "Sublime Text"
        ]
        actions: [
          kind: "key"
          key: "Return"
          modifiers: ['command', 'shift']
        ]
    actions: [
      kind: "key"
      key: "Left"
      modifiers: ["command"]
    ,
      kind: "key"
      key: "Return"
    ,
      kind: "key"
      key: "Up"
    ]