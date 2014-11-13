_.extend Commands.mapping,
  "shroom":
    kind: "action"
    repeatable: true
    grammarType: "numberCapture"
    description: "shift down, select text by line downward"
    actions: [
      kind: "key"
      key: "Down"
      modifiers: ['shift']
    ]
  "shreepway":
    kind: "action"
    repeatable: true
    grammarType: "numberCapture"
    description: "select all text upward"
    actions: [
      kind: "key"
      key: "Up"
      modifiers: ['shift', 'command']
    ]
  "shroomway":
    kind: "action"
    repeatable: true
    grammarType: "numberCapture"
    description: "select all text downward"
    actions: [
      kind: "key"
      key: "Down"
      modifiers: ['shift', 'command']
    ]
  "shreep":
    kind: "action"
    repeatable: true
    grammarType: "numberCapture"
    description: "shift up, select text by line upward"
    actions: [
      kind: "key"
      key: "Up"
      modifiers: ['shift']
    ]
  "shrim":
    kind: "action"
    repeatable: true
    grammarType: "numberCapture"
    description: "extend selection by character to the left"
    actions: [
      kind: "key"
      key: "Left"
      modifiers: ['shift']
    ]
  "shrish":
    kind: "action"
    repeatable: true
    grammarType: "numberCapture"
    description: "extend selection by character to the right"
    actions: [
      kind: "key"
      key: "Right"
      modifiers: ['shift']
    ]
  "scram":
    kind: "action"
    repeatable: true
    grammarType: "numberCapture"
    description: "extend selection by word to the left"
    actions: [
      kind: "key"
      key: "Left"
      modifiers: ['shift', 'option']
    ]
  "scrish":
    kind: "action"
    repeatable: true
    grammarType: "numberCapture"
    description: "extend selection by word to the right"
    actions: [
      kind: "key"
      key: "Right"
      modifiers: ['option', 'shift']
    ]
