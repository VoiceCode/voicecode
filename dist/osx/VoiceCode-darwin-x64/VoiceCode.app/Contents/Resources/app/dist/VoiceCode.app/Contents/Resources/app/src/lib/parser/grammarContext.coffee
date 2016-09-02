grammarTransforms =
  shrink: (args) ->
    Actions.fuzzyMatch Settings.insert.abbreviations, args.join(' ')
  treemail: (args) ->
    Actions.fuzzyMatch Settings.insert.emails, args.join(' ')
  trusername: (args) ->
    Actions.fuzzyMatch Settings.insert.usernames, args.join(' ')
  trassword: (args) ->
    Actions.fuzzyMatch Settings.insert.passwords, args.join(' ')
  champ: (word) ->
    Transforms.titleSentance([word])

module.exports =
  grammarTransform: (name, args) ->
    grammarTransforms[name](args)
  makeInteger: (textArray) ->
    parseInt textArray.join(''), 10
  flatten: (input) ->
    _.flatten input, true
