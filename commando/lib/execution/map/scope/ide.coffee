Commands.createDisabled
  "spring":
    grammarType: "numberCapture"
    description: "go to line number."
    tags: ["sublime", "xcode"]
    triggerScopes: ["Sublime Text", "Xcode", "Atom"]
    action: (input) ->
      switch @currentApplication()
        when "Sublime Text"
          if input
            @exec "subl --command 'goto_line {\"line\": #{input}}'"
          else
            @key "G", ['control']
        when "Atom"
          @key "G", ['control']
          if input
            @string input
            @key "Return"
        when "Xcode"
          @key "L", ['command']
          if input?
            @delay 200
            @string input
            @delay 100
            @key "Return"

  "sprinkler":
    grammarType: "numberCapture"
    description: "go to line number then position cursor at end of line."
    tags: ["sublime", "xcode"]
    triggerScopes: ["Sublime Text", "Xcode", "Atom"]
    action: (input) ->
      @do "spring", input
      if input?
        @do "ricky"

  "sprinkle":
    grammarType: "numberCapture"
    description: "go to line number then position cursor at beginning of line."
    tags: ["xcode"]
    triggerScopes: ["Sublime Text", "Xcode", "Atom"]
    action: (input) ->
      @do "spring", input
      if input?
        @do "lefty"

  "sprinkoon":
    grammarType: "numberCapture"
    description: "go to line number then insert a new line below."
    tags: ["sublime", "xcode"]
    triggerScopes: ["Sublime Text", "Xcode", "Atom"]
    action: (input) ->
      @do "spring", input
      if input?
        @do "shockoon"

  "spackle":
    grammarType: "numberCapture"
    description: "go to line number then select entire line."
    tags: ["sublime"]
    triggerScopes: ["Sublime Text", "Xcode", "Atom"]
    action: (input) ->
      @do "spring", input
      if input?
        @do "shackle"
      # @exec """
      # subl --command 'goto_line {"line": #{input}}' \
      # --command 'expand_selection {"to": "line"}'
      # """
