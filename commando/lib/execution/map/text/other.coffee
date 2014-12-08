_.extend Commands.mapping,
  "snitch":
    kind: "text"
    grammarType: "textCapture"
    description: "captures the first letter from each word and joins them"
    transform: "firstLetters"
  "thrack":
    kind: "text"
    grammarType: "oneArgument"
    description: "captures the first 3 letters of the next word spoken"
    transform: "pluckThree"