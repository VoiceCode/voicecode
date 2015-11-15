# Chain.preprocess 'inline-repetitors', (chain) ->
#   newChain = []
#   repetitionWords = _.map Settings.repetitionWords, (howMany, name) ->
#     name = "#{name} way" #TODO: make way a variable
#     {name, howMany}
#   _.each chain, (command) ->
#     newChain.push command
#     if command.command in _.pluck repetitionWords, 'name'
#       howMany = (_.findWhere repetitionWords, {name: command.command}).howMany
#       newChain.pop()
#       newChain = _.times howMany, -> newChain
#       newChain = _.flatten newChain
#   newChain

Commands.createDisabled
  'repetition.chain':
    spoken: 'creek'
    grammarType: "integerCapture"
    description: "Repeat N-th complete spoken phrase in history. Defaults to previous."
    tags: ["voicecode", "repetition", "recommended"]
    repeatable: true
    bypassHistory: (context) ->
      # return true if context.chainLinkIndex is 0
      # return false
      return true

    action: (offset, context) ->
      offset = offset or 1
      if offset is 1 and context.chain.length is 1
        HistoryController.hasAmnesia yes
      else
        HistoryController.isGreedy yes
      chain = HistoryController.getChain offset
      chain = new Chain().execute chain
      HistoryController.hasAmnesia no
      HistoryController.isGreedy no

  'repetition.command':
    spoken: 'repple'
    grammarType: "integerCapture"
    repeater: "variable"
    description: "Repeats an individual command component.
    Right after any command say [repple X] to repeat it X times"
    tags: ["voicecode", "repetition", "recommended"]
    bypassHistory: true
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

class Repetition
  constructor: ->
    @words = _.clone Settings.repetitionWords
    _.each @words, (repetitionCount, word) =>
      @words["#{word} way"] = repetitionCount #TODO: make way a variable
    @build()
  build: ->
    _.each @words, (value, key) ->
      suffix = ''
      if key.match(/way/)?
        suffix = '.inline'
      Commands.createDisabled "repetition.#{value}#{suffix}",
        spoken: key
        repeater: value
        repeatable: true
        description: "repeat last individual command times [#{value}]"
        bypassHistory: true
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

module.exports = new Repetition
