singleWords = [
  "text"
  "height"
  "width"
  "bottom"
  "top"
  "left"
  "right"
  "font"
  "padding"
  "margin"
]

_.each singleWords, (word) ->
  Commands.create "word-#{word}",
    kind: "word"
    grammarType: "textCapture"
    description: "insert the word '#{word}'"
    tags: ["words"]
    triggerPhrase: word
    word: word