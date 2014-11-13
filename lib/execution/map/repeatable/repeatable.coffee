_.extend Commands.mapping,
  "shock":
    kind: "action"
    repeatable: true
    grammarType: "numberCapture"
    description: "press the return key"
    actions: [
      kind: "key"
      key: "Return"
    ]
  "junk":
    kind: "action"
    repeatable: true
    grammarType: "numberCapture"
    description: "press the delete key"
    actions: [
      kind: "key"
      key: "Delete"
    ]
  "spunk":
    kind: "action"
    repeatable: true
    grammarType: "numberCapture"
    description: "pressed the forward delete key"
    actions: [
      kind: "key"
      key: "ForwardDelete"
    ]
  "dizzle":
    kind: "action"
    repeatable: true
    grammarType: "numberCapture"
    description: "undo"
    actions: [
      kind: "key"
      key: "Z"
      modifiers: ["command"]
    ]
  "rizzle":
    kind: "action"
    repeatable: true
    grammarType: "numberCapture"
    description: "redo"
    actions: [
      kind: "key"
      key: "Z"
      modifiers: ["command", "shift"]
      modifiers: ["command"]
    ]
  "tarp":
    kind: "action"
    repeatable: true
    grammarType: "numberCapture"
    description: "inserts a tab"
    actions: [
      kind: "key"
      key: "Tab"
    ]
  "tarsh":
    kind: "action"
    repeatable: true
    grammarType: "numberCapture"
    description: "inserts a shift + tab"
    actions: [
      kind: "key"
      key: "Tab"
      modifiers: ["shift"]
    ]
  "gibby":
    kind: "action"
    description: "Switch to next window in same application"
    grammarType: "numberCapture"
    repeatable: true
    actions: [
      kind: "keystroke"
      keystroke: "`"
      modifiers: ["command"]
    ]
  "shibby":
    kind: "action"
    description: "Switch to previous window in same application"
    grammarType: "numberCapture"
    repeatable: true
    actions: [
      kind: "keystroke"
      keystroke: "`"
      modifiers: ["command", "shift"]
    ]
  "shompla":
    kind: "action"
    description: "zoom in"
    grammarType: "numberCapture"
    repeatable: true
    actions: [
      kind: "keystroke"
      keystroke: "+"
      modifiers: ["command"]
    ]
  "shaman":
    kind: "action"
    description: "zoom out"
    grammarType: "numberCapture"
    repeatable: true
    actions: [
      kind: "keystroke"
      keystroke: "-"
      modifiers: ["command"]
    ]
  "shabble":
    kind: "action"
    description: ""
    grammarType: "numberCapture"
    repeatable: true
    actions: [
      kind: "keystroke"
      keystroke: "["
      modifiers: ["command"]
    ]
  "shabber":
    kind: "action"
    description: ""
    grammarType: "numberCapture"
    repeatable: true
    actions: [
      kind: "keystroke"
      keystroke: "]"
      modifiers: ["command"]
    ]
  "marneck":
    kind: "action"
    description: "find the next occurrence of a search term"
    grammarType: "numberCapture"
    repeatable: true
    actions: [
      kind: "key"
      key: "G"
      modifiers: ["command"]
    ]
  "marpreev":
    kind: "action"
    description: "find the previous occurrence of a search term"
    grammarType: "numberCapture"
    repeatable: true
    actions: [
      kind: "key"
      key: "G"
      modifiers: ["command", "shift"]
    ]
  "scrodge":
    kind: "action"
    description: "scroll down"
    grammarType: "numberCapture"
    repeatable: true
    actions: [
      kind: "key"
      key: "PageDown"
      delay: 0.2
    ]
  "scroop":
    kind: "action"
    description: "scroll up"
    grammarType: "numberCapture"
    repeatable: true
    actions: [
      kind: "key"
      key: "PageUp"
      delay: 0.2
    ]
  "scrolltop":
    kind: "action"
    description: "scroll up"
    grammarType: "numberCapture"
    repeatable: true
    actions: [
      kind: "key"
      key: "Home"
    ]
  "scrollend":
    kind: "action"
    description: "scroll up"
    grammarType: "numberCapture"
    repeatable: true
    actions: [
      kind: "key"
      key: "End"
    ]



