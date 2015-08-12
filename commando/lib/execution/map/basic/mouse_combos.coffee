Commands.createDisabled
  "chibble":
    description: "selects the entire line of text cursor hovers over"
    tags: ["mouse", "combo", "recommended"]
    mouseLatency: true
    action: (input, context) ->
      @do "chiff", input, context
      @key "Left", 'command'
      @key "Right", 'command shift'
  "dookoosh":
    grammarType: "oneArgument"
    description: "mouse double click, then copy"
    tags: ["mouse", "combo", "recommended"]
    mouseLatency: true
    action: (input, context) ->
      @do "duke", input, context
      @do "stoosh", input
  "doopark":
    grammarType: "oneArgument"
    description: "mouse double click, then paste"
    tags: ["mouse", "combo"]
    mouseLatency: true
    action: (input, context) ->
      @do "duke", input, context
      @do "spark", input
  "chiffpark":
    grammarType: "oneArgument"
    description: "mouse single click, then paste"
    tags: ["mouse", "combo", "recommended"]
    mouseLatency: true
    action: (input, context) ->
      @do "chiff", input, context
      @do "spark", input
  "shackloosh":
    grammarType: "oneArgument"
    description: "select entire line, then copy"
    tags: ["selection", "copy-paste", "combo"]
    action: (input) ->
      @do "shackle"
      @do "stoosh", input
  "shacklark":
    grammarType: "oneArgument"
    description: "select entire line, then paste"
    tags: ["selection", "copy-paste", "combo"]
    action: (input) ->
      @do "shackle"
      @do "spark", input
  "chibloosh":
    grammarType: "oneArgument"
    description: "select entire line, then copy"
    tags: ["selection", "copy-paste", "combo"]
    mouseLatency: true
    action: (input, context) ->
      @do "chibble", input, context
      @do "stoosh", input
  "chiblark":
    grammarType: "oneArgument"
    description: "select entire line, then paste"
    tags: ["selection", "copy-paste", "combo"]
    mouseLatency: true
    action: (input, context) ->
      @do "chibble", input, context
      @do "spark", input
  "chiffacoon":
    description: "click, then insert new line below"
    tags: ["mouse", "combo"]
    mouseLatency: true
    action: (input, context) ->
      @do "chiff", input, context
      @do "shockoon"
  "chiffkoosh":
    description: "click, then insert a space"
    tags: ["mouse", "combo", "space"]
    mouseLatency: true
    action: (input, context) ->
      @do "chiff", input, context
      @do "skoosh"
  "sappy":
    aliases: ["sapi"]
    description: "click, then delete entire line"
    tags: ["mouse", "combo"]
    mouseLatency: true
    action: (input, context) ->
      @do "chiff", input, context
      @do "snipline"
  "sapper":
    description: "click, then delete line to the right"
    tags: ["mouse", "combo"]
    mouseLatency: true
    action: (input, context) ->
      @do "chiff", input, context
      @do "snipper"
  "sapple":
    description: "click, then delete line to the left"
    tags: ["mouse", "combo"]
    mouseLatency: true
    action: (input, context) ->
      @do "chiff", input, context
      @do "snipple"
