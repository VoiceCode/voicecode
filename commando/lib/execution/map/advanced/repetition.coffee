Commands.createDisabled
  "creek":
    kind: "historic"
    grammarType: "numberCapture"
    description: "repeat last complete spoken phrase [n] times (default 1)"
    tags: ["voicecode", "repetition", "recommended"]
    action: (context, input) ->
      previous = context.lastFullCommand
      if previous
        for i in [1..(input or 1)]
          _.each previous, (command) =>
            command.call(@)
  "repple":
    kind: "historic"
    grammarType: "numberCapture"
    repeater: "variable"
    description: "Repeats an individual command component. Right after any command say [repple X] to repeat it X times"
    tags: ["voicecode", "repetition", "recommended"]
    ignoreHistory: true
    action: (context, input) ->
      times = parseInt(input)
      if times?
        times = if context.repetitionIndex is 0
          times or 1
        else
          (times or 1) - 1
        if times > 0 and times < (Settings.maximumRepetitionCount or 100)
          for i in [1..times]
            context.lastIndividualCommand.call(@)

class @Repetition
  constructor: ->
    @words = Settings.repetitionWords
    @build()
  build: ->
    _.each @words, (value, key) ->
      Commands.createDisabled key,
        kind: "historic"
        repeater: value
        description: "repeat last individual command times [#{value.times}]"
        ignoreHistory: true
        tags: ["voicecode", "repetition", "recommended"]
        aliases: value.aliases or []
        action: (context, input) ->
          times = if context.repetitionIndex is 0
            value.times
          else
            Math.max(value.times - 1, 1)
          for i in [1..times]
            context.lastIndividualCommand.call(@)
