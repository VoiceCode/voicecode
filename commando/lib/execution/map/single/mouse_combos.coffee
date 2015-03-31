_.extend Commands.mapping,
  "chibble":
    kind: "action"
    grammarType: "individual"
    description: "selects the entire line of text cursor hovers over"
    tags: ["mouse", "combo"]
    actions: [
      kind: "key"
      key: "I"
      modifiers: ["command", "option", "control", "shift"]
      delay: 0.1
    ,
      kind: "key"
      key: "Left"
      modifiers: ["command"]
    ,
      kind: "key"
      key: "Right"
      modifiers: ["command", "shift"]
    ]
  "dookoosh":
    kind: "combo"
    grammarType: "individual"
    description: "mouse double click, then copy"
    tags: ["mouse", "combo"]
    combo: ["duke", "stoosh"]
  "doopark":
    kind: "combo"
    grammarType: "individual"
    description: "mouse double click, then paste"
    tags: ["mouse", "combo"]
    combo: ["duke", "spark"]
  "chiffpark":
    kind: "combo"
    grammarType: "individual"
    description: "mouse single click, then paste"
    tags: ["mouse", "combo"]
    combo: ["chiff", "spark"]
  "shackloosh":
    kind: "combo"
    grammarType: "individual"
    description: "select entire line, then copy"
    tags: ["selection", "copy-paste", "combo"]
    combo: ["shackle", "stoosh"]
  "shacklark":
    kind: "combo"
    grammarType: "individual"
    description: "select entire line, then paste"
    tags: ["selection", "copy-paste", "combo"]
    combo: ["shackle", "spark"]
  "chibloosh":
    kind: "combo"
    grammarType: "individual"
    description: "select entire line, then copy"
    tags: ["selection", "copy-paste", "combo"]
    combo: ["chibble", "stoosh"]
  "chiblark":
    kind: "combo"
    grammarType: "individual"
    description: "select entire line, then paste"
    tags: ["selection", "copy-paste", "combo"]
    combo: ["chibble", "spark"]
  "chiffacoon":
    kind: "combo"
    grammarType: "individual"
    description: "click, then insert new line below"
    tags: ["mouse", "combo"]
    combo: ["chiff", "shockoon"]
  "chiffkoosh":
    kind: "combo"
    grammarType: "individual"
    description: "click, then insert a space"
    tags: ["mouse", "combo", "space"]
    combo: ["chiff", "skoosh"]
  "sappy":
    kind: "combo"
    grammarType: "individual"
    aliases: ["sapi"]
    description: "click, then delete entire line"
    tags: ["mouse", "combo"]
    combo: ["chiff", "snipline"]
  "sapper":
    kind: "combo"
    grammarType: "individual"
    description: "click, then delete line to the right"
    tags: ["mouse", "combo"]
    combo: ["chiff", "snipper"]
  "sapple":
    kind: "combo"
    grammarType: "individual"
    description: "click, then delete line to the left"
    tags: ["mouse", "combo"]
    combo: ["chiff", "snipple"]

