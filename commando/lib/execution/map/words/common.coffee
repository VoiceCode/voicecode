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
  "yes"
  "class"
  "new"
]

wordsWithTriggerPhrase =
  # "word": "trigger"
  "id": "ID"

_.each singleWords, (word) ->
  Commands.mapping["word-#{word}"] = 
    kind: "word"
    grammarType: "textCapture"
    description: "insert the word '#{word}'"
    tags: ["word"]
    triggerPhrase: word
    word: word

_.each wordsWithTriggerPhrase, (trigger, word) ->
  Commands.mapping["word-#{word}"] = 
    kind: "word"
    grammarType: "textCapture"
    description: "insert the word '#{word}'"
    tags: ["word"]
    triggerPhrase: trigger
    word: word
