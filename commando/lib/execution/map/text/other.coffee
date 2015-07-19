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
