singleWords = [
  "and"
  "class"
  "each"
  "else"
  "end"
  "error"
  "false"
  "if"
  "length"
  "new"
  "not"
  "null"
  "or"
  "true"
  "undefined"
  "while"
  "yes"
]

wordsWithTriggerPhrase =
  # "word": "trigger"
  "id": "ID"

_.each singleWords, (word) ->
  Commands.mapping["word-#{word}"] = 
    kind: "word"
    grammarType: "textCapture"
    description: "insert the word '#{word}'"
    tags: ["words"]
    module: "words"
    triggerPhrase: word
    word: word

_.each wordsWithTriggerPhrase, (trigger, word) ->
  Commands.mapping["word-#{word}"] = 
    kind: "word"
    grammarType: "textCapture"
    description: "insert the word '#{word}'"
    tags: ["word"]
    module: "words"
    triggerPhrase: trigger
    word: word
