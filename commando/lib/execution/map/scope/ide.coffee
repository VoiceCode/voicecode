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
          if input
            @runAtomCommand "goToLine", input
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

  "bracken":
    description: "expand selection to quotes, parens, braces, or brackets"
    tags: ["sublime"]
    triggerScopes: ["Atom", "Sublime Text"]
    action: (input) ->
      switch @currentApplication()
        when "Sublime Text"
          @key "S", 'control command option'
        when "Atom"
          @runAtomCommand "trigger", "expand-selection:expand"

  "selrang":
    grammarType: "numberCapture"
    description: "selects text in a line range: selrang ten twenty."
    tags: ["atom", "sublime"]
    triggerScopes: ["Atom", "Sublime Text"]
    action: (input) ->
      if input?
        number = input.toString()
        length = Math.floor(number.length / 2)
        first = number.substr(0, length)
        last = number.substr(length, length + 1)
        first = parseInt(first)
        last = parseInt(last)
        if last < first
          temp = last
          last = first
          first = temp
        last += 1
        switch @currentApplication()
          when "Sublime Text"
            script = """
            subl --command 'goto_line {"line": #{first}}' \
            --command 'set_mark' \
            --command 'goto_line {"line": #{last}}' \
            --command 'select_to_mark' \
            --command 'clear_bookmarks {"name": "mark"}'
            """
            @exec script
          when "Atom"
            @runAtomCommand "selectLineRange",
              from: first
              to: last

  "seltil":
    grammarType: "numberCapture"
    description: "selects text from current position through ('til) spoken line number: seltil five five."
    tags: ["atom", "sublime"]
    triggerScopes: ["Atom", "Sublime Text"]
    action: (input) ->
      if input?
        switch @currentApplication()
          when "Sublime Text"
            script = """
            subl --command 'set_mark' \
            --command 'goto_line {"line": #{input}}' \
            --command 'select_to_mark' \
            --command 'clear_bookmarks {"name": "mark"}'
            """
            @exec script
          when "Atom"
            @runAtomCommand "extendSelectionToLine", input
