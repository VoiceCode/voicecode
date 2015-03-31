_.extend Commands.mapping,
  "shroomway":
    kind: "action"
    grammarType: "individual"
    description: "select all text downward"
    tags: ["selection"]
    actions: [
      kind: "key"
      key: "Down"
      modifiers: ['shift', 'command']
    ]
  "shroom":
    kind: "action"
    grammarType: "individual"
    description: "shift down, select text by line downward"
    tags: ["selection"]
    actions: [
      kind: "key"
      key: "Down"
      modifiers: ['shift']
    ]
  "shreepway":
    kind: "action"
    grammarType: "individual"
    description: "select all text upward"
    tags: ["selection"]
    actions: [
      kind: "key"
      key: "Up"
      modifiers: ['shift', 'command']
    ]
  "shreep":
    kind: "action"
    grammarType: "individual"
    description: "shift up, select text by line upward"
    tags: ["selection"]
    actions: [
      kind: "key"
      key: "Up"
      modifiers: ['shift']
    ]
  "shrim":
    kind: "action"
    grammarType: "individual"
    description: "extend selection by character to the left"
    tags: ["selection"]
    actions: [
      kind: "key"
      key: "Left"
      modifiers: ['shift']
    ]
  "shrish":
    kind: "action"
    grammarType: "individual"
    description: "extend selection by character to the right"
    tags: ["selection"]
    actions: [
      kind: "key"
      key: "Right"
      modifiers: ['shift']
    ]
  "scram":
    kind: "action"
    grammarType: "individual"
    description: "extend selection by word to the left"
    tags: ["selection"]
    actions: [
      kind: "key"
      key: "Left"
      modifiers: ['shift', 'option']
    ]
  "scrish":
    kind: "action"
    grammarType: "individual"
    description: "extend selection by word to the right"
    tags: ["selection"]
    actions: [
      kind: "key"
      key: "Right"
      modifiers: ['option', 'shift']
    ]
