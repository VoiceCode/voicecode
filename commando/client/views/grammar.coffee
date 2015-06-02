Template.Grammar.helpers
  grammar: ->
    unless Session.get("loading")
      Grammar.build()
