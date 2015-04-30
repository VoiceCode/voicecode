Commands.create
  "switchy":
    kind: "action"
    grammarType: "individual"
    description: "move current line up"
    tags: ["sublime", "xcode"]
    triggerScopes: ["Sublime Text", "Xcode"]
    action: (input) ->
      switch @currentApplication()
        when "Sublime Text"
          @key "Up", ['control', 'command']
        when "Xcode"
          @key "[", ['command', 'option']

  "switcho":
    kind: "action"
    grammarType: "individual"
    description: "move current line down"
    tags: ["sublime", "xcode"]
    triggerScopes: ["Sublime Text", "Xcode"]
    action: (input) ->
      switch @currentApplication()
        when "Sublime Text"
          @key "Down", ['control', 'command']
        when "Xcode"
          @key "]", ['command', 'option']

  "spring":
    kind: "action"
    grammarType: "numberCapture"
    description: "go to line number."
    tags: ["sublime", "xcode"]
    triggerScopes: ["Sublime Text", "Xcode"]
    action: (input) ->
      switch @currentApplication()
        when "Sublime Text"
          if input
            @exec "subl --command 'goto_line {\"line\": #{input}}'"
          else
            @key "G", ['control']
        when "Xcode"
          @key "L", ['command']
          if input?
            @delay 200
            @string input
            @delay 100
            @key "Return"

  "sprinkler":
    kind: "action"
    grammarType: "numberCapture"
    description: "go to line number then position cursor at end of line."
    tags: ["sublime", "xcode"]
    triggerScopes: ["Sublime Text", "Xcode"]
    action: (input) ->
      @do "spring", input
      if input?
        @do "ricky"

  "sprinkle":
    kind: "action"
    grammarType: "numberCapture"
    description: "go to line number then position cursor at end of line."
    tags: ["xcode"]
    triggerScopes: ["Xcode"]
    action: (input) ->
      @do "spring", input
      if input?
        @do "lefty"

  "sprinkoon":
    kind: "action"
    grammarType: "numberCapture"
    description: "go to line number then insert a new line below."
    tags: ["sublime", "xcode"]
    triggerScopes: ["Sublime Text", "Xcode"]
    action: (input) ->
      @do "spring", input
      if input?
        @do "shockoon"

  "spackle":
    kind: "action"
    grammarType: "numberCapture"
    description: "go to line number then select entire line."
    tags: ["sublime"]
    triggerScopes: ["Sublime Text"]
    action: (input) ->
      @do "spring", input
      if input?
        @do "shackle"
      # @exec """
      # subl --command 'goto_line {"line": #{input}}' \
      # --command 'expand_selection {"to": "line"}'
      # """
