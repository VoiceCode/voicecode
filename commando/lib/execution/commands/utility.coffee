Commands.Utility =
  numberCaptureCommands: ->
    _.filter(_.keys(Commands.mapping), (key) ->
      Commands.mapping[key].grammarType is "numberCapture"
    )
  textCaptureCommands: ->
    _.filter(_.keys(Commands.mapping), (key) ->
      Commands.mapping[key].grammarType is "textCapture"
    )
  individualCommands: ->
    _.filter(_.keys(Commands.mapping), (key) ->
      Commands.mapping[key].grammarType is "individual"
    )
  oneArgumentCommands: ->
    _.filter(_.keys(Commands.mapping), (key) ->
      Commands.mapping[key].grammarType is "oneArgument"
    )
  numberCommands: ->
    _.filter(_.keys(Commands.mapping), (key) ->
      _.contains (Commands.mapping[key].tags or []), "number"
    )
  letterCommands: ->
    _.filter(_.keys(Commands.mapping), (key) ->
      _.contains (Commands.mapping[key].tags or []), "letter"
    )

  addAliases: (key, aliases) ->
    Commands.mapping[key].aliases ?= []
    Commands.mapping[key].aliases.push.apply(Commands.mapping[key].aliases, aliases)

  changeName: (old, newName) ->
    Commands.mapping[newName] = Commands.mapping[old]
    delete Commands.mapping[old]
