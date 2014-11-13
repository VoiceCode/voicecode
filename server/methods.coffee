# BrowserPolicy.content.allowEval()
# BrowserPolicy.content.allowConnectOrigin("http://grammar.voicecode.io")
# BrowserPolicy.content.allowConnectOrigin("http://commando:5000/")

Meteor.methods
	parseGeneratorString: ->
		ParseGenerator.string