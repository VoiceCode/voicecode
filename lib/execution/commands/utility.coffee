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
