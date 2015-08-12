Commands.createDisabled
  "shin":
    description: "does nothing, but enters into voice code"
    aliases: ["chin"]
    tags: ["text", "recommended"]
    action: ->
      null
  "skoosh":
    description: "insert a space"
    findable: " "
    tags: ["space", "recommended"]
    aliases: ["skoo", "sku"]
    repeatable: true
    action: ->
      @key " "
  "sky koosh":
    description: "press shift+space (useful for scrolling up, or other random purposes in certain applications)"
    vocabulary: true
    tags: ["space"]
    repeatable: true
    action: ->
      @key 'Space', 'shift'
  "skoopark":
    grammarType: "oneArgument"
    description: "insert space then paste the clipboard (or named item from stoosh command)"
    tags: ["copy-paste", "recommended"]
    action: (input) ->
      @key "Space"
      @do "spark", input
  "shockoon":
    description: "Inserts a new line below the current line"
    tags: ["return", "combo", "recommended"]
    repeatable: true
    action: ->
      console.log "running base command"
      if @currentApplication() is "sublime"
        @key "Return", "command"
      else
        @key "Right", "command"
        @key "Return"
  "shockey":
    description: "Inserts a new line above the current line"
    aliases: ["chalky", "shocking", "shocky"]
    tags: ["return", "combo", "recommended"]
    repeatable: true
    action: ->
      if @currentApplication() is "sublime"
        @key "Return", "command shift"
      else
        @key "Left", "command"
        @key "Return"
        @key "Up"
