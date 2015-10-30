Chain.preprocess (chain) ->
  newChain = []
  repetitionWords = _.map Settings.repetitionWords, (howMany, name) ->
    name = Commands.getCurrentNameFor name
    name = "#{name} way" #TODO: make way a variable
    {name, howMany}
  _.each chain, (command) ->
    newChain.push command
    if command.command in _.pluck repetitionWords, 'name'
      howMany = (_.findWhere repetitionWords, {name: command.command}).howMany
      newChain.pop()
      newChain = _.times howMany, -> newChain
      newChain = _.flatten newChain
  newChain

Commands.createDisabled
  "creek":
    grammarType: "numberCapture"
    description: "repeat last complete spoken phrase [n] times (default 1)"
    tags: ["voicecode", "repetition", "recommended"]
    repeatable: true
    historic: true
    inputRequired: false
    action: (input, context) ->
      previous = context.lastFullCommand
      if previous
        @repeat input or 1, =>
          _.each previous, (command) =>
            command.call(@)
  "repple":
    grammarType: "numberCapture"
    repeater: "variable"
    description: "Repeats an individual command component.
    Right after any command say [repple X] to repeat it X times"
    tags: ["voicecode", "repetition", "recommended"]
    ignoreHistory: true
    historic: true
    inputRequired: false # is it really?
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
    @words = _.clone Settings.repetitionWords
    _.each @words, (repetitionCount, word) =>
      @words["#{word} way"] = repetitionCount #TODO: make way a variable
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
            last = context.lastIndividualCommand
            if last?
              @repeat times, =>
                last.call(@)
