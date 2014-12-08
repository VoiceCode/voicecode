# BrowserPolicy.content.allowEval()
# BrowserPolicy.content.allowConnectOrigin("http://grammar.voicecode.io")
# BrowserPolicy.content.allowConnectOrigin("http://commando:5000/")

Meteor.methods
	parseGeneratorString: ->
		ParseGenerator.string

	execute: (phrase) ->
		chain = new Commands.Chain(phrase)
		results = chain.execute(true)