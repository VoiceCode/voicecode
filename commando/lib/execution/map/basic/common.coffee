Commands.create
  "shock":
    kind: "action"
    grammarType: "individual"
    aliases: ["shocked", "shox", "chalk"]
    description: "press the return key"
    tags: ["return", "recommended"]
    action: (input) ->
      @key "Return"
  "junk":
    kind: "action"
    grammarType: "individual"
    description: "press the delete key"
    aliases: ["junks", "junked"]
    tags: ["deleting", "recommended"]
    action: (input) ->
      @key "Delete"
  "spunk":
    kind: "action"
    grammarType: "individual"
    description: "pressed the forward delete key"
    tags: ["deleting", "recommended"]
    action: (input) ->
      @key "ForwardDelete"
  "dizzle":
    kind: "action"
    grammarType: "individual"
    description: "undo"
    tags: ["application", "recommended"]
    action: (input) ->
      @key "Z", ["command"]
  "rizzle":
    kind: "action"
    grammarType: "individual"
    description: "redo"
    tags: ["application", "recommended"]
    action: (input) ->
      @key "Z", ["command", "shift"]
  "tarp":
    kind: "action"
    grammarType: "individual"
    description: "inserts a tab"
    tags: ["tab", "recommended"]
    action: (input) ->
      @key "Tab"
  "tarsh":
    kind: "action"
    grammarType: "individual"
    description: "inserts a shift + tab"
    tags: ["tab", "recommended"]
    action: (input) ->
      @key "Tab", ["shift"]
  "gibby":
    kind: "action"
    description: "Switch to next window in same application"
    grammarType: "individual"
    tags: ["application", "window", "recommended"]
    action: (input) ->
      @key "`", ["command"]
  "shibby":
    kind: "action"
    description: "Switch to previous window in same application"
    grammarType: "individual"
    tags: ["application", "window", "recommended"]
    action: (input) ->
      @key "`", ["command", "shift"]
  "shompla":
    kind: "action"
    description: "zoom in"
    grammarType: "individual"
    tags: ["application", "plus", "recommended"]
    action: (input) ->
      @key "=", ["command"]
  "shaman":
    kind: "action"
    description: "zoom out"
    grammarType: "individual"
    tags: ["application", "minus", "recommended"]
    action: (input) ->
      @key "-", ["command"]
  "shabble":
    kind: "action"
    description: ""
    grammarType: "individual"
    tags: ["[", "recommended"]
    action: (input) ->
      @key "[", ["command"]
  "shabber":
    kind: "action"
    description: ""
    grammarType: "individual"
    aliases: ["shammar"]
    tags: ["]", "recommended"]
    action: (input) ->
      @key "]", ["command"]
  "marneck":
    kind: "action"
    description: "find the next occurrence of a search term"
    grammarType: "individual"
    tags: ["application", "recommended"]
    action: (input) ->
      @key "G", ["command"]
  "marpreev":
    kind: "action"
    description: "find the previous occurrence of a search term"
    grammarType: "individual"
    tags: ["application", "recommended"]
    action: (input) ->
      @key "G", ["command", "shift"]
  "olly":
    kind: "action"
    grammarType: "individual"
    description: "select all"
    tags: ["selection", "recommended"]
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
    tags: ["copy-paste", "selection", "recommended"]
    action: ->
      @key "A", ["command"]
      @key "V", ["command"]
  "spark":
    kind: "action"
    grammarType: "oneArgument"
    description: "paste the clipboard (or named item from stoosh command)"
    aliases: ["sparked"]
    tags: ["copy-paste", "recommended"]
    action: (input) ->
      if input?
        previous = @retrieveClipboardWithName(input)
        if previous?.length
          @setClipboard(previous)
          @delay 50
          @key "V", ["command"]
      else
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
    tags: ["application", "recommended"]
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
    tags: ["copy-paste", "application", "system", "combo", "recommended"]
    action: ->
      @key "C", ["command"]
      @key "Tab", ["command"]
  "stoosh":
    kind: "action"
    grammarType: "oneArgument"
    description: "copy whatever is selected (if an argument is given whatever is copied is stored with that name and can be pasted via `spark [name]`)"
    tags: ["copy-paste", "recommended"]
    action: (input) ->
      @key "C", ["command"]
      if input?
        @waitForClipboard()
        @storeCurrentClipboardWithName(input)
  "allstoosh":
    kind: "action"
    grammarType: "individual"
    description: "select all then copy whatever is selected"
    tags: ["copy-paste", "selection", "recommended"]
    action: ->
      @key "A", ["command"]
      @key "C", ["command"]
  "snatch":
    kind: "action"
    grammarType: "individual"
    description: "cut whatever is selected"
    tags: ["copy-paste", "recommended"]
    aliases: ["snatched"]
    action: ->
      @key "X", ["command"]
  "totch":
    kind: "action"
    grammarType: "individual"
    description: "close a window or tab"
    tags: ["application", "window", "recommended"]
    action: ->
      @key "W", ["command"]
  "marco":
    kind: "action"
    grammarType: "individual"
    description: "find"
    tags: ["application", "recommended"]
    action: ->
      @key "F", ["command"]
  "talky":
    kind: "action"
    grammarType: "individual"
    description: "open a new tab"
    tags: ["application", "window", "recommended"]
    action: ->
      @key "T", ["command"]
  "randall":
    kind: "action"
    grammarType: "individual"
    description: "press escape"
    tags: ["escape", "recommended"]
    action: ->
      @key "Escape"
