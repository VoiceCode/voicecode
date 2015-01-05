_.extend Commands.mapping,
  "ricky":
    kind: "action"
    grammarType: "individual"
    description: "moves the cursor all the way to the right"
    tags: ["cursor"]
    actions: [
      kind: "key"
      key: "Right"
      modifiers: ["command"]
    ]
  "derek":
    kind: "action"
    grammarType: "individual"
    description: "moves the cursor on the way to the right than inserts a space"
    tags: ["cursor", "Space", "Right", "combo"]
    actions: [
      kind: "key"
      key: "Right"
      modifiers: ["command"]
    ,
      kind: "key"
      key: "Space"
    ]
  "ricksy":
    kind: "action"
    grammarType: "individual"
    description: "selects all text to the right"
    tags: ["selection", "Right"]
    actions: [
      kind: "key"
      key: "Right"
      modifiers: ["command", "shift"]
    ]
  "lefty":
    kind: "action"
    grammarType: "individual"
    description: "move the cursor all the way to the left"
    tags: ["cursor", "Left"]
    actions: [
      kind: "key"
      key: "Left"
      modifiers: ["command"]
    ]  
  "lecksy":
    kind: "action"
    grammarType: "individual"
    description: "selects all text to the left"
    tags: ["selection", "Left"]
    actions: [
      kind: "key"
      key: "Left"
      modifiers: ["command", "shift"]
    ]  
  "shackle":
    kind: "action"
    grammarType: "individual"
    description: "selects the entire line"
    tags: ["selection"]
    aliases: ["sheqel"]
    actions: [
      kind: "key"
      key: "Left"
      modifiers: ["command"]
    ,
      kind: "key"
      key: "Right"
      modifiers: ["command", "shift"]
    ]  
  "snipline":
    kind: "action"
    grammarType: "individual"
    description: "will delete the entire line"
    tags: ["deleting"]
    actions: [
      kind: "key"
      key: "Right"
      modifiers: ["command"]
    ,
      kind: "key"
      key: "Delete"
      modifiers: ["command"]
    ]  
  "snipper":
    kind: "action"
    grammarType: "individual"
    description: "will delete everything to the right"
    tags: ["deleting", "Right"]
    actions: [
      kind: "key"
      key: "Right"
      modifiers: ["command", "shift"]
    ,
      kind: "key"
      key: "Delete"
    ]
  "snipple":
    kind: "action"
    grammarType: "individual"
    tags: ["deleting", "Left"]
    description: "will delete everything to the left"
    actions: [
      kind: "key"
      key: "Delete"
      modifiers: ["command"]
    ]
  "jolt":
    kind: "action"
    grammarType: "individual"
    description: "will duplicate the current line"
    tags: ["text-manipulation"]
    actions: [
      kind: "key"
      key: "Left"
      modifiers: ["command"]
    ,
      kind: "key"
      key: "Right"
      modifiers: ["command", "shift"]
    ,
      kind: "key"
      key: "C"
      modifiers: ["command"]
    ,
      kind: "key"
      key: "Right"
    ,
      kind: "key"
      key: "Return"
    ,
      kind: "key"
      key: "V"
      modifiers: ["command"]
    ]
  "streak":
    kind: "action"
    description: "expand selection to block"
    grammarType: "individual"
    contextSensitive: true
    tags: ["text-manipulation"]
    actions: [
      kind: "script"
      script: (value) ->
        Scripts.selectBlock()
    ]
  "spando":
    kind: "action"
    description: "expand selection symmetrically (horizontally)"
    grammarType: "numberCapture"
    contextSensitive: true
    tags: ["text-manipulation"]
    actions: [
      kind: "script"
      script: (value) ->
        Scripts.symmetricSelectionExpansion(value or 1)
    ]
  "bloxy":
    kind: "action"
    description: "expand selection vertically, symmetrically"
    grammarType: "numberCapture"
    contextSensitive: true
    tags: ["text-manipulation"]
    actions: [
      kind: "script"
      script: (value) ->
        Scripts.verticalSelectionExpansion(value or 1)
    ]


