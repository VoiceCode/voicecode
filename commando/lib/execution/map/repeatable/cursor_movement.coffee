_.extend Commands.mapping,
  "doomway":
    kind: "action"
    repeatable: true
    grammarType: "numberCapture"
    description: "move the cursor to the bottom of the page"
    tags: ["movement"]
    actions: [
      kind: "key"
      key: "Down"
      modifiers: ["command"]
    ]
  "doom":
    kind: "action"
    repeatable: true
    grammarType: "numberCapture"
    description: "press the down arrow"
    tags: ["movement"]
    actions: [
      kind: "key"
      key: "Down"
    ]
  "jeepway":
    kind: "action"
    grammarType: "numberCapture"
    description: "move the cursor to the top of the page"
    tags: ["movement"]
    actions: [
      kind: "key"
      key: "Up"
      modifiers: ["command"]
    ]
  "jeep":
    kind: "action"
    repeatable: true
    description: "Press the up arrow"
    grammarType: "numberCapture"
    tags: ["movement"]
    actions: [
      kind: "key"
      key: "Up"
    ]
  "crimp":
    kind: "action"
    repeatable: true
    grammarType: "numberCapture"
    description: "press the left arrow"
    tags: ["movement"]
    actions: [
      kind: "key"
      key: "Left"
    ]
  "chris":
    kind: "action"
    repeatable: true
    grammarType: "numberCapture"
    description: "press the right arrow"
    aliases: ["krist", "crist"]
    actions: [
      kind: "key"
      key: "Right"
    ]
  "shunkrim":
    kind: "action"
    repeatable: true
    grammarType: "numberCapture"
    description: "move the cursor by word to the left"
    actions: [
      kind: "key"
      key: "Left"
      modifiers: ['option']
    ]
  "wonkrim":
    kind: "action"
    repeatable: true
    grammarType: "numberCapture"
    description: "move the cursor by partial word to the left"
    actions: [
      kind: "key"
      key: "Left"
      modifiers: ['control']
    ]
  "wonkrish":
    kind: "action"
    repeatable: true
    grammarType: "numberCapture"
    description: "move the cursor by partial word to the right"
    actions: [
      kind: "key"
      key: "Right"
      modifiers: ['control']
    ]
  "shunkrish":
    kind: "action"
    repeatable: true
    grammarType: "numberCapture"
    description: "move the cursor by word to the right"
    actions: [
      kind: "key"
      key: "Right"
      modifiers: ['option']
    ]

