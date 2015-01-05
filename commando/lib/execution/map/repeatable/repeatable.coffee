_.extend Commands.mapping,
  "shock":
    kind: "action"
    repeatable: true
    grammarType: "numberCapture"
    aliases: ["shocked", "shox"]
    description: "press the return key"
    tags: ["Return"]
    actions: [
      kind: "key"
      key: "Return"
    ]
  "junk":
    kind: "action"
    repeatable: true
    grammarType: "numberCapture"
    description: "press the delete key"
    tags: ["Delete"]
    actions: [
      kind: "key"
      key: "Delete"
    ]
  "spunk":
    kind: "action"
    repeatable: true
    grammarType: "numberCapture"
    description: "pressed the forward delete key"
    tags: ["ForwardDelete"]
    actions: [
      kind: "key"
      key: "ForwardDelete"
    ]
  "dizzle":
    kind: "action"
    repeatable: true
    grammarType: "numberCapture"
    description: "undo"
    tags: ["application", "command", "Z"]
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
    tags: ["application", "command+shift", "Z"]
    actions: [
      kind: "key"
      key: "Z"
      modifiers: ["command", "shift"]
    ]
  "tarp":
    kind: "action"
    repeatable: true
    grammarType: "numberCapture"
    description: "inserts a tab"
    tags: ["Tab"]
    actions: [
      kind: "key"
      key: "Tab"
    ]
  "tarsh":
    kind: "action"
    repeatable: true
    grammarType: "numberCapture"
    description: "inserts a shift + tab"
    tags: ["Tab", "shift"]
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
    tags: ["application", "command"]
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
    tags: ["application", "command"]
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
    tags: ["application", "command", "Plus", "Equal"]
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
    tags: ["application", "command", "Minus"]
    actions: [
      kind: "keystroke"
      keystroke: "-"
      modifiers: ["command"]
    ]
  "shabble":
    kind: "action"
    description: ""
    grammarType: "numberCapture"
    tags: ["LeftBracket"]
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
    tags: ["RightBracket"]
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
    tags: ["application", "command", "G"]
    actions: [
      kind: "key"
      key: "G"
      modifiers: ["command"]
    ]
  "marpreev":
    kind: "action"
    description: "find the previous occurrence of a search term"
    grammarType: "numberCapture"
    tags: ["application", "command+shift", "G"]
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
    tags: ["scroll"]
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
    tags: ["scroll"]
    actions: [
      kind: "key"
      key: "PageUp"
      delay: 0.2
    ]
  "scrolltop":
    kind: "action"
    description: "scroll to top"
    grammarType: "numberCapture"
    tags: ["scroll"]
    repeatable: true
    actions: [
      kind: "key"
      key: "Home"
    ]
  "scrollend":
    kind: "action"
    description: "scroll to bottom"
    grammarType: "numberCapture"
    repeatable: true
    tags: ["scroll"]
    actions: [
      kind: "key"
      key: "End"
    ]



