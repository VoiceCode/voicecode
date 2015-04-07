_.extend Commands.mapping,
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
