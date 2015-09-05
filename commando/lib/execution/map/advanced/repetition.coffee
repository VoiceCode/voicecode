Commands.createDisabled
  "creek":
    grammarType: "numberCapture"
    description: "repeat last complete spoken phrase [n] times (default 1)"
    tags: ["voicecode", "repetition", "recommended"]
    repeatable: true
    historic: true
    action: (input, context) ->
      previous = context.lastFullCommand
      if previous
        @repeat input or 1, =>
          _.each previous, (command) =>
            command.call(@)
  "repple":
    grammarType: "numberCapture"
    repeater: "variable"
    description: "Repeats an individual command component. Right after any command say [repple X] to repeat it X times"
    tags: ["voicecode", "repetition", "recommended"]
    ignoreHistory: true
    historic: true
    action: (input, context) ->
      times = parseInt(input)
      if times?
        times = if context.repetitionIndex is 0
          times or 1
        else
          (times or 1) - 1
        if times > 0 and times < (Settings.maximumRepetitionCount or 100)
          @repeat times, =>
            context.lastIndividualCommand.call(@)

class @Repetition
  constructor: ->
    @words = Settings.repetitionWords
    @build()
  build: ->
    _.each @words, (value, key) ->
      Commands.createDisabled key,
        repeater: value
        repeatable: true
        description: "repeat last individual command times [#{value}]"
        ignoreHistory: true
        historic: true
        tags: ["voicecode", "repetition", "recommended"]
        action: (input, context) ->
          times = if context.repetitionIndex is 0
            value
          else
            value - 1
          if times > 0
            @repeat times, =>
              context.lastIndividualCommand.call(@)
