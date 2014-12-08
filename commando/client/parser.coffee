@ParseGenerator = {}

Meteor.startup ->
  @Grammar = new Grammar()

  Meteor.call "parseGeneratorString", (error, results) ->
    ParseGenerator.string = results
    @Parser = eval(ParseGenerator.string)

  # console.log parseGeneratorString.content