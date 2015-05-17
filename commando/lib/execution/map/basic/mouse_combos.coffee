Commands.createDisabled
  "chibble":
    kind: "action"
    grammarType: "individual"
    description: "selects the entire line of text cursor hovers over"
    tags: ["mouse", "combo", "recommended"]
    action: ->
      @click()
      @key "Left", ['command']
      @key "Right", ['command', 'shift']
  "dookoosh":
    kind: "action"
    grammarType: "oneArgument"
    description: "mouse double click, then copy"
    tags: ["mouse", "combo", "recommended"]
    action: (input) ->
      @do "duke"
      @do "stoosh", input
  "doopark":
    kind: "action"
    grammarType: "oneArgument"
    description: "mouse double click, then paste"
    tags: ["mouse", "combo"]
    action: (input) ->
      @do "duke"
      @do "spark", input
  "chiffpark":
    kind: "action"
    grammarType: "oneArgument"
    description: "mouse single click, then paste"
    tags: ["mouse", "combo", "recommended"]
    action: (input) ->
      @do "chiff"
      @do "spark", input
  "shackloosh":
    kind: "action"
    grammarType: "oneArgument"
    description: "select entire line, then copy"
    tags: ["selection", "copy-paste", "combo"]
    action: (input) ->
      @do "shackle"
      @do "stoosh", input
  "shacklark":
    kind: "action"
    grammarType: "oneArgument"
    description: "select entire line, then paste"
    tags: ["selection", "copy-paste", "combo"]
    combo: ["shackle", "spark"]
    action: (input) ->
      @do "shackle"
      @do "spark", input
  "chibloosh":
    kind: "action"
    grammarType: "oneArgument"
    description: "select entire line, then copy"
    tags: ["selection", "copy-paste", "combo"]
    combo: ["chibble", "stoosh"]
    action: (input) ->
      @do "chibble"
      @do "stoosh", input
  "chiblark":
    kind: "action"
    grammarType: "oneArgument"
    description: "select entire line, then paste"
    tags: ["selection", "copy-paste", "combo"]
    combo: ["chibble", "spark"]
    action: (input) ->
      @do "chibble"
      @do "spark", input
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
