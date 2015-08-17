Commands.createDisabled
  "snitch":
    grammarType: "textCapture"
    tags: ["text"]
    description: "captures the first letter from each word and joins them"
    action: (input) ->
      if input
        @string Transforms.firstLetters(input)
  "thrack":
    grammarType: "oneArgument"
    tags: ["text"]
    description: "captures the first 3 letters of the next word spoken"
    action: (input) ->
      if input
        @string Transforms.pluckThree(input)
  "cyclom":
    grammarType: "oneArgument"
    tags: ["text"]
    description: "if text is selected, will rotate through homonyms. If argument is spoken, will print next homonym of argument"
    action: (input) ->
      if input
        other = Homonyms.next input
        if other?
          @string other
      else
        if @isTextSelected()
          contents = @getSelectedText()?.toLowerCase()
          if contents?.length
            transformed = Homonyms.next contents
            if transformed?
              @string transformed
              for i in [1..transformed.length]
                @key 'Left', 'shift'
