_.extend Commands.mapping,
  "doomway":
    kind: "action"
    grammarType: "individual"
    description: "move the cursor to the bottom of the page"
    tags: ["cursor"]
    actions: [
      kind: "key"
      key: "Down"
      modifiers: ["command"]
    ]
  "doom":
    kind: "action"
    grammarType: "individual"
    description: "press the down arrow"
    tags: ["cursor"]
    actions: [
      kind: "key"
      key: "Down"
    ]
  "jeepway":
    kind: "action"
    grammarType: "individual"
    description: "move the cursor to the top of the page"
    tags: ["cursor"]
    actions: [
      kind: "key"
      key: "Up"
      modifiers: ["command"]
    ]
  "jeep":
    kind: "action"
    description: "Press the up arrow"
    grammarType: "individual"
    tags: ["cursor"]
    actions: [
      kind: "key"
      key: "Up"
    ]
  "crimp":
    kind: "action"
    grammarType: "individual"
    description: "press the left arrow"
    aliases: ["crimped"]
    tags: ["cursor"]
    actions: [
      kind: "key"
      key: "Left"
    ]
  "chris":
    kind: "action"
    grammarType: "individual"
    description: "press the right arrow"
    tags: ["cursor"]
    aliases: ["krist", "crist"]
    actions: [
      kind: "key"
      key: "Right"
    ]
  "shunkrim":
    kind: "action"
    grammarType: "individual"
    description: "move the cursor by word to the left"
    tags: ["cursor"]
    actions: [
      kind: "key"
      key: "Left"
      modifiers: ['option']
    ]
  "wonkrim":
    kind: "action"
    grammarType: "individual"
    description: "move the cursor by partial word to the left"
    tags: ["cursor"]
    actions: [
      kind: "key"
      key: "Left"
      modifiers: ['control']
    ]
  "wonkrish":
    kind: "action"
    grammarType: "individual"
    description: "move the cursor by partial word to the right"
    tags: ["cursor"]
    actions: [
      kind: "key"
      key: "Right"
      modifiers: ['control']
    ]
  "shunkrish":
    kind: "action"
    grammarType: "individual"
    description: "move the cursor by word to the right"
    tags: ["cursor"]
    actions: [
      kind: "key"
      key: "Right"
      modifiers: ['option']
    ]

