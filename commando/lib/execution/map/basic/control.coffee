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
      @space()
  "sky koosh":
    description: "press shift+space (useful for scrolling up, or other random purposes in certain applications)"
    vocabulary: true
    tags: ["space"]
    repeatable: true
    action: ->
      @key 'space', 'shift'
  "shockoon":
    description: "Inserts a new line below the current line"
    tags: ["return", "combo", "recommended"]
    repeatable: true
    action: ->
      console.log "running base command"
      if @currentApplication() is "sublime"
        @key "return", "command"
      else
        @key "right", "command"
        @enter()
  "shockey":
    description: "Inserts a new line above the current line"
    aliases: ["chalky", "shocking", "shocky"]
    tags: ["return", "combo", "recommended"]
    repeatable: true
    action: ->
      if @currentApplication() is "sublime"
        @key "return", "command shift"
      else
        @key "last", "command"
        @enter()
        @up()
