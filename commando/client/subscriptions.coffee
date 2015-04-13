Meteor.subscribe "history"
Meteor.subscribe "commandStatuses"
Meteor.subscribe "parserCash"
@enablesSubscription = Meteor.subscribe "enables"

Tracker.autorun (t) ->
  if enablesSubscription.ready()
    t.stop()
    Commands.loadConditionalModules()

Meteor.startup ->
  Cashes.find().observe
    added: reloadGrammar
    removed: reloadGrammar
    changed: reloadGrammar
