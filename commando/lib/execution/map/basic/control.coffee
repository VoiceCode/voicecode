Commands.create
  "shin":
    kind: "action"
    grammarType: "individual"
    description: "does nothing, but enters into voice code"
    aliases: ["chin"]
    tags: ["text", "recommended"]
    action: -> 
      null
  "skoosh":
    kind: "action"
    grammarType: "individual"
    description: "insert a space"
    tags: ["space", "recommended"]
    action: ->
      @key " "
  "skoopark":
    kind: "action"
    grammarType: "individual"
    description: "insert a space then paste the clipboard"
    tags: ["space", "combo", "copy-paste"]
    action: ->
      @key " "
      @key "V", ["command"]
  "shockoon":
    kind: "action"
    description: "Inserts a new line below the current line"
    grammarType: "individual"
    tags: ["return", "combo", "recommended"]
    action: ->
      if @currentApplication() is "sublime"
        @key "Return", ["command"]
      else
        @key "Right", ["command"]
        @key "Return"
  "shocktar":
    kind: "action"
    description: "Inserts a new line then a tab"
    grammarType: "individual"
    tags: ["return", "tab", "combo"]
    action: ->
      @key "Return"
      @key "Tab"
  "shockey":
    kind: "action"
    description: "Inserts a new line above the current line"
    grammarType: "individual"
    aliases: ["chalky", "shocking"]
    tags: ["return", "combo", "recommended"]
    action: ->
      if @currentApplication() is "sublime"
        @key "Return", ["command", "shift"]
      else
        @key "Left", ["command"]
        @key "Return"
        @key "Up"