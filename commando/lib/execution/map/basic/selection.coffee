Commands.createDisabled
  "shroomway":
    kind: "action"
    grammarType: "individual"
    description: "select all text downward"
    tags: ["selection", "recommended"]
    action: ->
      @key 'Down', ['shift', 'command']
  "shroom":
    kind: "action"
    grammarType: "individual"
    description: "shift down, select text by line downward"
    tags: ["selection", "recommended"]
    action: ->
      @key 'Down', ['shift']
  "shreepway":
    kind: "action"
    grammarType: "individual"
    description: "select all text upward"
    tags: ["selection", "recommended"]
    action: ->
      @key 'Up', ['shift', 'command']
  "shreep":
    kind: "action"
    grammarType: "individual"
    description: "shift up, select text by line upward"
    tags: ["selection", "recommended"]
    action: ->
      @key 'Up', ['shift']
  "shrim":
    kind: "action"
    grammarType: "individual"
    description: "extend selection by character to the left"
    tags: ["selection", "recommended"]
    action: ->
      @key 'Left', ['shift']
  "shrish":
    kind: "action"
    grammarType: "individual"
    description: "extend selection by character to the right"
    tags: ["selection", "recommended"]
    action: ->
      @key 'Right', ['shift']
  "scram":
    kind: "action"
    grammarType: "individual"
    description: "extend selection by word to the left"
    tags: ["selection", "recommended"]
    action: ->
      @key 'Left', ['option', 'shift']
  "scrish":
    kind: "action"
    grammarType: "individual"
    description: "extend selection by word to the right"
    tags: ["selection", "recommended"]
    action: ->
      @key 'Right', ['option', 'shift']
  "folly":
    kind: "action"
    description: "expand selection to block"
    grammarType: "individual"
    tags: ["text-manipulation"]
    aliases: ["foley"]
    action: ->
      if @currentApplication() is "Sublime Text"
        @key "L", ['command']
      else
        @selectBlock()
  "spando":
    kind: "action"
    description: "expand selection symmetrically (horizontally)"
    grammarType: "numberCapture"
    tags: ["text-manipulation"]
    action: (input) ->
      @symmetricSelectionExpansion(input or 1)

  "bloxy":
    kind: "action"
    description: "expand selection vertically, symmetrically"
    grammarType: "numberCapture"
    tags: ["text-manipulation"]
    action: (input) ->
      @verticalSelectionExpansion(input or 1)

  "kerleck":
    kind: "action"
    description: "With argument: [word], Will select the text [word] on the current line. With arguments: [word1], [word2], Will select the text starting with the first occurrence of [word1] and ending with the last occurrence of [word2] on the current line"
    grammarType: "textCapture"
    tags: ["text-manipulation", "cursor", "selection"]
    action: (input) ->
      @selectCurrentOccurrence(input)

  "jeepleck":
    kind: "action"
    description: "With argument: [word], Will select the text [word] previous to the cursor. With arguments: [word1], [word2], Will select the text starting with the last occurrence of [word1] and ending with the last occurrence of [word2] previous to the cursor"
    grammarType: "textCapture"
    tags: ["text-manipulation", "cursor", "selection"]
    action: (input) ->
      @selectPreviousOccurrence(input)

  "doomleck":
    kind: "action"
    description: "With argument: [word], Will select the text [word] after the cursor. With arguments: [word1], [word2], Will select the text starting with the first occurrence of [word1] and ending with the first occurrence of [word2] after the cursor"
    grammarType: "textCapture"
    tags: ["text-manipulation", "cursor", "selection"]
    action: (input) ->
      @selectFollowingOccurrence(input)

  "wordneck":
    kind: "action"
    description: "select the following whole word"
    grammarType: "numberCapture"
    tags: ["text-manipulation", "cursor", "selection"]
    action: (input) ->
      switch @currentApplication()
        when "Sublime Text"
          script = "subl"
          _(input or 1).times =>
            script += " --command 'select_next_word'"
          @exec script
        when "Atom"
          @runAtomCommand 
            command: "selectNextWord"
            options: input or 1
        else
          @selectContiguousMatching
            input: input
            expression: /\w/
            direction: 1

  "wordpreev":
    kind: "action"
    description: "select the previous whole word"
    grammarType: "numberCapture"
    tags: ["text-manipulation", "cursor", "selection"]
    action: (input) ->
      switch @currentApplication()
        when "Sublime Text"
          script = "subl"
          _(input or 1).times =>
            script += " --command 'select_previous_word'"
          @exec script
        when "Atom"
          @runAtomCommand
            command: "selectPreviousWord"
            options: input or 1
        else
          @selectContiguousMatching
            input: input
            expression: /\w/
            direction: -1

  # "fuzzneck"
  # "fuzzpreev": archbrov
  # "stringneck" => crew coif
  # "stringpreev" => trail coif

