Commands.create
  "bracken":
    kind: "action"
    grammarType: "individual"
    description: "expand selection to brackets"
    tags: ["sublime"]
    triggerScopes: ["Sublime Text"]
    action: (input) ->
      @key "S", ['control', 'command', 'option']

  "selrang":
    kind: "action"
    grammarType: "numberCapture"
    description: "selects text in a line range: selrang ten twenty. Requires subl - https://github.com/VoiceCode/docs/wiki/Sublime-Text-Setup"
    tags: ["domain-specific", "sublime"]
    triggerScope: "Sublime Text"
    action: (input) ->
      if input
        number = input.toString()
        length = Math.floor(input.length / 2)
        first = number.substr(0, length)
        last = number.substr(length, length + 1)
        first = parseInt(first)
        last = parseInt(last)
        if last < first
          temp = last
          last = first
          first = temp
        last += 1
        script = """
        subl --command 'goto_line {"line": #{first}}' \
        --command 'set_mark' \
        --command 'goto_line {"line": #{last}}' \
        --command 'select_to_mark' \
        --command 'clear_bookmarks {"name": "mark"}'
        """
        @exec script
  
  "seltil":
    kind: "action"
    grammarType: "numberCapture"
    description: "selects text from current position through ('til) spoken line number: seltil five five. Requires subl - https://github.com/VoiceCode/docs/wiki/Sublime-Text-Setup"
    tags: ["domain-specific", "sublime"]
    triggerScope: "Sublime Text"
    action: (input) ->
      if input?
        script = """
        subl --command 'set_mark' \
        --command 'goto_line {"line": #{input}}' \
        --command 'select_to_mark' \
        --command 'clear_bookmarks {"name": "mark"}'
        """
        @exec script
