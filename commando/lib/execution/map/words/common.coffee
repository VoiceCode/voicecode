singleWords = [
  "null"
  "true"
  "false"
  "if"
  "else"
  "and"
  "or"
  "not"
  "end"
  "each"
  "while"
  "length"
  "undefined"
]

_.each singleWords, (word) ->
  Commands.mapping["word-#{word}"] = 
    kind: "word"
    grammarType: "textCapture"
    description: "insert the word '#{word}'"
    tags: ["user", "word"]
    triggerPhrase: word
    word: word