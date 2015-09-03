Commands.createDisabled
  "shock":
    aliases: ["shocked", "shox", "chalk", "schock"]
    description: "press the return key"
    tags: ["return", "recommended"]
    repeatable: true
    action: (input) ->
      @key "Return"
  "junk":
    description: "press the delete key"
    aliases: ["junks", "junked"]
    tags: ["deleting", "recommended"]
    repeatable: true
    action: (input) ->
      @key "Delete"
  "spunk":
    description: "pressed the forward delete key"
    tags: ["deleting", "recommended"]
    repeatable: true
    action: (input) ->
      @key "ForwardDelete"
  "dizzle":
    description: "undo"
    tags: ["application", "recommended"]
    repeatable: true
    action: (input) ->
      @key "Z", "command"
  "rizzle":
    description: "redo"
    tags: ["application", "recommended"]
    repeatable: true
    action: (input) ->
      @key "Z", "command shift"
  "tarp":
    description: "inserts a tab"
    tags: ["tab", "recommended"]
    repeatable: true
    action: (input) ->
      @key "Tab"
  "tarsh":
    description: "inserts a shift + tab"
    tags: ["tab", "recommended"]
    repeatable: true
    action: (input) ->
      @key "Tab", "shift"
  "gibby":
    description: "Switch to next window in same application"
    tags: ["application", "window", "recommended"]
    repeatable: true
    action: (input) ->
      @key "`", "command"
  "shibby":
    description: "Switch to previous window in same application"
    tags: ["application", "window", "recommended"]
    repeatable: true
    action: (input) ->
      @key "`", "command shift"
  "shompla":
    description: "zoom in"
    tags: ["application", "plus", "recommended"]
    repeatable: true
    action: (input) ->
      @key "=", "command"
  "shaman":
    description: "zoom out"
    tags: ["application", "minus", "recommended"]
    repeatable: true
    action: (input) ->
      @key "-", "command"
  "shabble":
    description: ""
    tags: ["[", "recommended"]
    repeatable: true
    action: (input) ->
      @key "[", "command"
  "shabber":
    description: ""
    aliases: ["shammar"]
    tags: ["]", "recommended"]
    repeatable: true
    action: (input) ->
      @key "]", "command"
  "marneck":
    description: "find the next occurrence of a search term"
    tags: ["application", "recommended"]
    repeatable: true
    action: (input) ->
      @key "G", "command"
  "marpreev":
    description: "find the previous occurrence of a search term"
    tags: ["application", "recommended"]
    repeatable: true
    action: (input) ->
      @key "G", "command shift"
  "olly":
    description: "select all"
    tags: ["selection", "recommended"]
    action: ->
      @key "A", "command"
  "sage":
    description: "file > save"
    tags: ["application", "recommended"]
    action: ->
      @key "S", "command"
  "sagewick":
    description: "file > save"
    tags: ["application", "combo"]
    action: ->
      @key "S", "command"
      @key "Tab", "command"
  "totch":
    description: "close a window or tab"
    tags: ["application", "window", "recommended"]
    repeatable: true
    action: ->
      @key "W", "command"
  "marco":
    description: "find"
    tags: ["application", "recommended"]
    action: ->
      @key "F", "command"
  "talky":
    description: "open a new tab"
    tags: ["application", "window", "recommended"]
    aliases: ["talkie"]
    action: ->
      @key "T", "command"
  "randall":
    description: "press escape"
    tags: ["key", "recommended"]
    action: ->
      @key "Escape"
  "prome":
    description: "press the home key"
    tags: ["recommended", "key"]
    action: ->
      @key "Home"
  "prend":
    description: "press the home key"
    tags: ["recommended", "key"]
    action: ->
      @key "End"
