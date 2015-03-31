_.extend Commands.mapping,
  "shock":
    kind: "action"
    grammarType: "individual"
    aliases: ["shocked", "shox", "chalk"]
    description: "press the return key"
    tags: ["Return"]
    actions: [
      kind: "key"
      key: "Return"
    ]
  "junk":
    kind: "action"
    grammarType: "individual"
    description: "press the delete key"
    aliases: ["junks", "junked"]
    tags: ["deleting"]
    actions: [
      kind: "key"
      key: "Delete"
    ]
  "spunk":
    kind: "action"
    grammarType: "individual"
    description: "pressed the forward delete key"
    tags: ["deleting"]
    actions: [
      kind: "key"
      key: "ForwardDelete"
    ]
  "dizzle":
    kind: "action"
    grammarType: "individual"
    description: "undo"
    tags: ["application", "command", "Z"]
    actions: [
      kind: "key"
      key: "Z"
      modifiers: ["command"]
    ]
  "rizzle":
    kind: "action"
    grammarType: "individual"
    description: "redo"
    tags: ["application", "command+shift", "Z"]
    actions: [
      kind: "key"
      key: "Z"
      modifiers: ["command", "shift"]
    ]
  "tarp":
    kind: "action"
    grammarType: "individual"
    description: "inserts a tab"
    tags: ["Tab"]
    actions: [
      kind: "key"
      key: "Tab"
    ]
  "tarsh":
    kind: "action"
    grammarType: "individual"
    description: "inserts a shift + tab"
    tags: ["tab", "shift"]
    actions: [
      kind: "key"
      key: "Tab"
      modifiers: ["shift"]
    ]
  "gibby":
    kind: "action"
    description: "Switch to next window in same application"
    grammarType: "individual"
    tags: ["application", "command"]
    actions: [
      kind: "keystroke"
      keystroke: "`"
      modifiers: ["command"]
    ]
  "shibby":
    kind: "action"
    description: "Switch to previous window in same application"
    grammarType: "individual"
    tags: ["application", "command"]
    actions: [
      kind: "keystroke"
      keystroke: "`"
      modifiers: ["command", "shift"]
    ]
  "shompla":
    kind: "action"
    description: "zoom in"
    grammarType: "individual"
    tags: ["application", "command", "plus"]
    actions: [
      kind: "keystroke"
      keystroke: "="
      modifiers: ["command"]
    ]
  "shaman":
    kind: "action"
    description: "zoom out"
    grammarType: "individual"
    tags: ["application", "command", "minus"]
    actions: [
      kind: "keystroke"
      keystroke: "-"
      modifiers: ["command"]
    ]
  "shabble":
    kind: "action"
    description: ""
    grammarType: "individual"
    tags: ["["]
    actions: [
      kind: "keystroke"
      keystroke: "["
      modifiers: ["command"]
    ]
  "shabber":
    kind: "action"
    description: ""
    grammarType: "individual"
    aliases: ["shammar"]
    tags: ["]"]
    actions: [
      kind: "keystroke"
      keystroke: "]"
      modifiers: ["command"]
    ]
  "marneck":
    kind: "action"
    description: "find the next occurrence of a search term"
    grammarType: "individual"
    tags: ["application", "command", "G"]
    actions: [
      kind: "key"
      key: "G"
      modifiers: ["command"]
    ]
  "marpreev":
    kind: "action"
    description: "find the previous occurrence of a search term"
    grammarType: "individual"
    tags: ["application", "command+shift", "G"]
    actions: [
      kind: "key"
      key: "G"
      modifiers: ["command", "shift"]
    ]
  "scrodge":
    kind: "action"
    description: "scroll down"
    grammarType: "individual"
    tags: ["scroll", "down"]
    actions: [
      kind: "key"
      key: "PageDown"
      delay: 0.2
    ]
  "scroop":
    kind: "action"
    description: "scroll up"
    grammarType: "individual"
    tags: ["scroll", "up"]
    actions: [
      kind: "key"
      key: "PageUp"
      delay: 0.2
    ]
  "scrolltop":
    kind: "action"
    description: "scroll to top"
    grammarType: "individual"
    tags: ["scroll", "up"]
    actions: [
      kind: "key"
      key: "Home"
    ]
  "scrollend":
    kind: "action"
    description: "scroll to bottom"
    grammarType: "individual"
    tags: ["scroll", "down"]
    actions: [
      kind: "key"
      key: "End"
    ]



