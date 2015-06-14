Commands.createDisabled
  "chibble":
    description: "selects the entire line of text cursor hovers over"
    tags: ["mouse", "combo", "recommended"]
    action: ->
      @click()
      @key "Left", 'command'
      @key "Right", 'command shift'
  "dookoosh":
    grammarType: "oneArgument"
    description: "mouse double click, then copy"
    tags: ["mouse", "combo", "recommended"]
    action: (input) ->
      @do "duke"
      @do "stoosh", input
  "doopark":
    grammarType: "oneArgument"
    description: "mouse double click, then paste"
    tags: ["mouse", "combo"]
    action: (input) ->
      @do "duke"
      @do "spark", input
  "chiffpark":
    grammarType: "oneArgument"
    description: "mouse single click, then paste"
    tags: ["mouse", "combo", "recommended"]
    action: (input) ->
      @do "chiff"
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
    action: (input) ->
      @do "chibble"
      @do "stoosh", input
  "chiblark":
    grammarType: "oneArgument"
    description: "select entire line, then paste"
    tags: ["selection", "copy-paste", "combo"]
    action: (input) ->
      @do "chibble"
      @do "spark", input
  "chiffacoon":
    description: "click, then insert new line below"
    tags: ["mouse", "combo"]
    action: ->
      @do "chiff"
      @do "shockoon"
  "chiffkoosh":
    description: "click, then insert a space"
    tags: ["mouse", "combo", "space"]
    action: ->
      @do "chiff"
      @do "skoosh"
  "sappy":
    aliases: ["sapi"]
    description: "click, then delete entire line"
    tags: ["mouse", "combo"]
    action: ->
      @do "chiff"
      @do "snipline"
  "sapper":
    description: "click, then delete line to the right"
    tags: ["mouse", "combo"]
    action: ->
      @do "chiff"
      @do "snipper"
  "sapple":
    description: "click, then delete line to the left"
    tags: ["mouse", "combo"]
    action: ->
      @do "chiff"
      @do "snipple"
