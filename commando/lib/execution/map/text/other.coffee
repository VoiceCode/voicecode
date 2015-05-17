Commands.createDisabled
  "snitch":
    kind: "text"
    grammarType: "textCapture"
    tags: ["text"]
    description: "captures the first letter from each word and joins them"
    transform: "firstLetters"
  "thrack":
    kind: "text"
    grammarType: "oneArgument"
    tags: ["text"]
    description: "captures the first 3 letters of the next word spoken"
    transform: "pluckThree"
