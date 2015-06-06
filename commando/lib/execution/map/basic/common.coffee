Commands.createDisabled
  "shock":
    aliases: ["shocked", "shox", "chalk"]
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
  "sparky":
    description: "paste the alternate clipboard"
    tags: ["copy-paste"]
    action: ->
      @key "V", "command shift"
  "allspark":
    description: "select all then paste the clipboard"
    tags: ["copy-paste", "selection", "recommended"]
    action: ->
      @key "A", "command"
      @key "V", "command"
  "spark":
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
          @key "V", "command"
      else
        @key "V", "command"
  "sparshock":
    description: "paste the clipboard then press enter"
    tags: ["copy-paste", "combo", "return"]
    action: ->
      @key "V", "command"
      @key "Return"
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
  "stooshwick":
    description: "copy whatever is selected then switch applications"
    tags: ["copy-paste", "application", "system", "combo", "recommended"]
    action: ->
      @key "C", "command"
      @key "Tab", "command"
      @delay 250
  "stoosh":
    grammarType: "oneArgument"
    description: "copy whatever is selected (if an argument is given whatever is copied is stored with that name and can be pasted via `spark [name]`)"
    tags: ["copy-paste", "recommended"]
    action: (input) ->
      @key "C", "command"
      if input?
        @waitForClipboard()
        @storeCurrentClipboardWithName(input)
  "allstoosh":
    description: "select all then copy whatever is selected"
    tags: ["copy-paste", "selection", "recommended"]
    action: ->
      @key "A", "command"
      @key "C", "command"
  "snatch":
    description: "cut whatever is selected"
    tags: ["copy-paste", "recommended"]
    aliases: ["snatched"]
    action: ->
      @key "X", "command"
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
    action: ->
      @key "T", "command"
  "randall":
    description: "press escape"
    tags: ["escape", "recommended"]
    action: ->
      @key "Escape"
