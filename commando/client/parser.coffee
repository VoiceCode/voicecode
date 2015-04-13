@ParseGenerator = {}

@reloadGrammar = ->
	console.log "reloading grammar"
	Meteor.call "parseGeneratorString", (error, results) ->
	  ParseGenerator.string = results
	  @Parser = eval(ParseGenerator.string)

Meteor.startup ->
  @Grammar = new Grammar()
  # Commands.loadConditionalModules()
  reloadGrammar()

  # console.log parseGeneratorString.content