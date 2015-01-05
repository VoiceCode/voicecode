_.extend Commands.mapping,
  "kef":
    kind: "action"
    repeatable: true
    grammarType: "numberCapture"
    description: "press the delete key"
    tags: ["deleting"]
    actions: [
      kind: "key"
      key: "Delete"
      modifiers: ['option']
    ]
  "steffi":
    kind: "action"
    repeatable: true
    grammarType: "numberCapture"
    description: "delete a partial word at a time"
    tags: ["deleting"]
    actions: [
      kind: "key"
      key: "Delete"
      modifiers: ['control']
    ]
  "stippy":
    kind: "action"
    repeatable: true
    grammarType: "numberCapture"
    description: "forward delete a partial word at a time"
    tags: ["deleting"]
    actions: [
      kind: "key"
      key: "ForwardDelete"
      modifiers: ['control']
    ]
  "kite":
    kind: "action"
    repeatable: true
    grammarType: "numberCapture"
    description: "forward delete a word at a time"
    tags: ["deleting"]
    actions: [
      kind: "key"
      key: "ForwardDelete"
      modifiers: ['option']
    ]