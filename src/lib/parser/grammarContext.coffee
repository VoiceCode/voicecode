grammarTransforms =
  shrink: (args) ->
    Actions.fuzzyMatch Settings.abbreviations, args.join(' ')
  treemail: (args) ->
    Actions.fuzzyMatch Settings.emails, args.join(' ')
  trusername: (args) ->
    Actions.fuzzyMatch Settings.usernames, args.join(' ')
  trassword: (args) ->
    Actions.fuzzyMatch Settings.passwords, args.join(' ')
  champ: (word) ->
    Transforms.titleSentance([word])

module.exports =
  grammarTransform: (name, args) ->
    grammarTransforms[name](args)
  makeInteger: (textArray) ->
    parseInt textArray.join(''), 10
