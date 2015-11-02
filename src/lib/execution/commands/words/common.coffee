singleWords = [
  'and'
  'right'
  'left'
  'class'
  'each'
  'else'
  'end'
  'error'
  'false'
  'if'
  'length'
  'new'
  'not'
  'null'
  'or'
  'true'
  'height'
]

wordsWithTriggerPhrase =
  'id': 'ID'

_.each singleWords, (word) ->
  Commands.createDisabled word,
    kind: 'word'
    grammarType: 'none'
    description: "insert the word {#{word}}"
    tags: ['words']
    continuous: false

_.each wordsWithTriggerPhrase, (trigger, word) ->
  Commands.createDisabled word,
    kind: 'word'
    grammarType: 'none'
    description: "insert the word {#{word}}"
    tags: ['words']
    triggerPhrase: trigger
    continuous: false
