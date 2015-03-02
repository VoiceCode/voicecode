@ParseGenerator = {}

Meteor.startup ->
  @Grammar = new Grammar()
  Commands.loadConditionalModules()
  
  Meteor.call "parseGeneratorString", (error, results) ->
    ParseGenerator.string = results
    @Parser = eval(ParseGenerator.string)

  # console.log parseGeneratorString.content