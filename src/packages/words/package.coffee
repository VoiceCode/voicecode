pack = Packages.register
  name: 'words'
  description: 'Simple words or phrases that need a "boost" in recognition by creating a command in Dragon.
   These words are not added to or parsed in the VoiceCode grammar, but treated as if the command didn\'t
   exist and you just spoke the word or phrase. This is "stronger" than adding a vocabulary word or phrase,
   but also clutters the "first word" command scope.'

pack.settings
  words: [
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
  # alternatePronunciation:
  #   'id': 'ID'

pack.ready ->
  _.each @settings().words, (word) =>
    @command word,
      spoken: word
      needsParsing: false
      description: "insert the word {#{word}}"

# _.each wordsWithTriggerPhrase, (trigger, word) ->
#   Commands.createDisabled "word.#{word}",
#     spoken: word
#     kind: 'word'
#     grammarType: 'none'
#     description: "insert the word {#{word}}"
#     tags: ['words']
#     triggerPhrase: trigger
#     continuous: false
