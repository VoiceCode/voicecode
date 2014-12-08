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

  addAliases: (key, aliases) ->
    Commands.mapping[key].aliases ?= []
    Commands.mapping[key].aliases.concat aliases

  changeName: (old, newName) ->
    Commands.mapping[newName] = Commands.mapping[old]
    delete Commands.mapping[old]
