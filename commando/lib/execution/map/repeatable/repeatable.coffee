_.extend Commands.mapping,
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
  "scrodge":
    kind: "action"
    description: "scroll down"
    grammarType: "individual"
    tags: ["scroll", "down"]
    action: (input) ->
      @key "PageDown"
  "scroop":
    kind: "action"
    description: "scroll up"
    grammarType: "individual"
    tags: ["scroll", "up"]
    action: (input) ->
      @key "PageUp"
  "scrolltop":
    kind: "action"
    description: "scroll to top"
    grammarType: "individual"
    tags: ["scroll", "up"]
    action: (input) ->
      @key "Home"
  "scrollend":
    kind: "action"
    description: "scroll to bottom"
    grammarType: "individual"
    tags: ["scroll", "down"]
    action: (input) ->
      @key "End"



