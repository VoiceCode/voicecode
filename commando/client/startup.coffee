@ParseGenerator = {}

@reloadGrammar = ->
  console.log "reloading grammar"
  Meteor.call "parseGeneratorString", (error, results) ->
    ParseGenerator.string = results
    @Parser = eval(ParseGenerator.string)


# Meteor.subscribe "history"
# Meteor.subscribe "commandStatuses"
# Meteor.subscribe "parserCash"
# @enablesSubscription = Meteor.subscribe "enables"

@enabledCommands = {}

Meteor.startup ->
  Session.set("loading", true)
  @Grammar = new Grammar()
  @alphabet = new Alphabet()
  repetition = new Repetition()
  @modifiers = new Modifiers()
  reloadGrammar()
  Meteor.call "loadSettings", "enabled_commands", (error, result) =>
    if error
      console.log error
    else
      @enabledCommands = result
      Commands.loadConditionalModules(enabledCommands)
      Session.set("loading", false)
