Commands.create
  "kef":
    kind: "action"
    grammarType: "individual"
    description: "press option-delete"
    tags: ["deleting", "recommended"]
    action: ->
      @key "Delete", ["option"]
  "steffi":
    kind: "action"
    grammarType: "individual"
    description: "delete a partial word at a time"
    tags: ["deleting"]
    action: ->
      current = @currentApplication()
      if current is "Sublime Text"
        @key "Delete", ["control"]
      else if current is "iTerm" and @mode is "vim"
        @key "Delete", ["option"]
      else if current is "Emacs" or (current is "iTerm" and @mode is "emacs")
        @key "Delete", ["option"]
      else
        @key "Delete", ["option"]
  "stippy":
    kind: "action"
    grammarType: "individual"
    description: "forward delete a partial word at a time"
    tags: ["deleting"]
    action: ->
      if @currentApplication() is "Sublime Text"
        @key "ForwardDelete", ["control"]
      else
        @key "ForwardDelete", ["option"]
  "kite":
    kind: "action"
    grammarType: "individual"
    description: "forward delete a word at a time"
    tags: ["deleting", "recommended"]
    action: ->
      @key "ForwardDelete", ['option']