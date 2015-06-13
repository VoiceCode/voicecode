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
    repeatable: true
    action: ->
      @key " "
  "skoopark":
    description: "insert a space then paste the clipboard"
    tags: ["space", "combo", "copy-paste"]
    action: ->
      @key " "
      @key "V", "command"
  "shockoon":
    description: "Inserts a new line below the current line"
    tags: ["return", "combo", "recommended"]
    repeatable: true
    action: ->
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
