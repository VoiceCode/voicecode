Commands.create
  "shock":
    kind: "action"
    grammarType: "individual"
    aliases: ["shocked", "shox", "chalk"]
    description: "press the return key"
    tags: ["return"]
    action: (input) ->
      @key "Return"
  "junk":
    kind: "action"
    grammarType: "individual"
    description: "press the delete key"
    aliases: ["junks", "junked"]
    tags: ["deleting"]
    action: (input) ->
      @key "Delete"
  "spunk":
    kind: "action"
    grammarType: "individual"
    description: "pressed the forward delete key"
    tags: ["deleting"]
    action: (input) ->
      @key "ForwardDelete"
  "dizzle":
    kind: "action"
    grammarType: "individual"
    description: "undo"
    tags: ["application"]
    action: (input) ->
      @key "Z", ["command"]
  "rizzle":
    kind: "action"
    grammarType: "individual"
    description: "redo"
    tags: ["application"]
    action: (input) ->
      @key "Z", ["command", "shift"]
  "tarp":
    kind: "action"
    grammarType: "individual"
    description: "inserts a tab"
    tags: ["tab"]
    action: (input) ->
      @key "Tab"
  "tarsh":
    kind: "action"
    grammarType: "individual"
    description: "inserts a shift + tab"
    tags: ["tab"]
    action: (input) ->
      @key "Tab", ["shift"]
  "gibby":
    kind: "action"
    description: "Switch to next window in same application"
    grammarType: "individual"
    tags: ["application", "window"]
    action: (input) ->
      @key "`", ["command"]
  "shibby":
    kind: "action"
    description: "Switch to previous window in same application"
    grammarType: "individual"
    tags: ["application", "window"]
    action: (input) ->
      @key "`", ["command", "shift"]
  "shompla":
    kind: "action"
    description: "zoom in"
    grammarType: "individual"
    tags: ["application", "plus"]
    action: (input) ->
      @key "=", ["command"]
  "shaman":
    kind: "action"
    description: "zoom out"
    grammarType: "individual"
    tags: ["application", "minus"]
    action: (input) ->
      @key "-", ["command"]
  "shabble":
    kind: "action"
    description: ""
    grammarType: "individual"
    tags: ["["]
    action: (input) ->
      @key "[", ["command"]
  "shabber":
    kind: "action"
    description: ""
    grammarType: "individual"
    aliases: ["shammar"]
    tags: ["]"]
    action: (input) ->
      @key "]", ["command"]
  "marneck":
    kind: "action"
    description: "find the next occurrence of a search term"
    grammarType: "individual"
    tags: ["application"]
    action: (input) ->
      @key "G", ["command"]
  "marpreev":
    kind: "action"
    description: "find the previous occurrence of a search term"
    grammarType: "individual"
    tags: ["application"]
    action: (input) ->
      @key "G", ["command", "shift"]
  "olly":
    kind: "action"
    grammarType: "individual"
    description: "select all"
    tags: ["selection"]
    action: ->
      @key "A", ["command"]
  "sparky":
    kind: "action"
    grammarType: "individual"
    description: "paste the alternate clipboard"
    tags: ["copy-paste"]
    action: ->
      @key "V", ["command", "shift"]
  "allspark":
    kind: "action"
    grammarType: "individual"
    description: "select all then paste the clipboard"
    tags: ["copy-paste", "selection"]
    action: ->
      @key "A", ["command"]
      @key "V", ["command"]
  "spark":
    kind: "action"
    grammarType: "individual"
    description: "paste the clipboard"
    aliases: ["sparked"]
    tags: ["copy-paste"]
    action: ->
      @key "V", ["command"]
  "sparshock":
    kind: "action"
    grammarType: "individual"
    description: "paste the clipboard then press enter"
    tags: ["copy-paste", "combo", "return"]
    action: ->
      @key "V", ["command"]
      @key "Return"
  "sage":
    kind: "action"
    grammarType: "individual"
    description: "file > save"
    tags: ["application"]
    action: ->
      @key "S", ["command"]
  "sagewick":
    kind: "action"
    grammarType: "individual"
    description: "file > save"
    tags: ["application", "combo"]
    action: ->
      @key "S", ["command"]
      @key "Tab", ["command"]
  "stooshwick":
    kind: "action"
    grammarType: "individual"
    description: "copy whatever is selected then switch applications"
    tags: ["copy-paste", "application", "system", "combo"]
    action: ->
      @key "C", ["command"]
      @key "Tab", ["command"]
  "stoosh":
    kind: "action"
    grammarType: "individual"
    description: "copy whatever is selected"
    tags: ["copy-paste"]
    action: ->
      @key "C", ["command"]
  "allstoosh":
    kind: "action"
    grammarType: "individual"
    description: "select all then copy whatever is selected"
    tags: ["copy-paste", "selection"]
    action: ->
      @key "A", ["command"]
      @key "C", ["command"]
  "snatch":
    kind: "action"
    grammarType: "individual"
    description: "cut whatever is selected"
    tags: ["copy-paste"]
    aliases: ["snatched"]
    action: ->
      @key "X", ["command"]
  "totch":
    kind: "action"
    grammarType: "individual"
    description: "close a window or tab"
    tags: ["application", "window"]
    action: ->
      @key "W", ["command"]
  "marco":
    kind: "action"
    grammarType: "individual"
    description: "find"
    tags: ["application"]
    action: ->
      @key "F", ["command"]
  "talky":
    kind: "action"
    grammarType: "individual"
    description: "open a new tab"
    tags: ["application", "window"]
    action: ->
      @key "T", ["command"]
  "randall":
    kind: "action"
    grammarType: "individual"
    description: "press escape"
    tags: ["escape"]
    action: ->
      @key "Escape"
