_.extend Commands.mapping,
  "kef":
    kind: "action"
    grammarType: "individual"
    description: "press option-delete"
    tags: ["deleting", "option"]
    actions: [
      kind: "key"
      key: "Delete"
      modifiers: ['option']
    ]
  "steffi":
    kind: "action"
    grammarType: "individual"
    description: "delete a partial word at a time"
    tags: ["deleting"]
    contextualActions:
      "sublime": 
        requirements: [
          application: "Sublime Text"
        ]
        actions: [
          kind: "key"
          key: "Delete"
          modifiers: ['control']
        ]
      "vim":
        requirements: [
          application: "iTerm"
          context: "vim"
        ,
          application: "MacVim"
        ]
        actions: [
          kind: "key"
          key: "Delete"
          modifiers: ['option']
        ]
      "emacs":
        requirements: [
          application: "iTerm"
          context: "emacs"
        ,
          application: "Emacs"
        ]
        actions: [
          kind: "key"
          key: "Delete"
          modifiers: ['option']
        ]
    actions: [
      kind: "key"
      key: "Delete"
      modifiers: ['option']
    ]
  "stippy":
    kind: "action"
    grammarType: "individual"
    description: "forward delete a partial word at a time"
    tags: ["deleting"]
    applicationActions:
      "Sublime Text": [
        kind: "key"
        key: "ForwardDelete"
        modifiers: ['control']
      ]
    actions: [
      kind: "key"
      key: "ForwardDelete"
      modifiers: ['control']
    ]
  "kite":
    kind: "action"
    grammarType: "individual"
    description: "forward delete a word at a time"
    tags: ["deleting"]
    actions: [
      kind: "key"
      key: "ForwardDelete"
      modifiers: ['option']
    ]