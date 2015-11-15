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
    bypassHistory: (context) -> true
    action: (offset, context) ->
      offset = offset or 1
      if context.chain.length is 1
        HistoryController.hasAmnesia yes
      chain = HistoryController.getChain offset
      chain = new Chain().execute chain, false
      HistoryController.hasAmnesia no

  'repetition.command':
    spoken: 'repple'
    grammarType: "integerCapture"
    repeater: "variable"
    description: "Repeats an individual command component.
    Right after any command say [repple X] to repeat it X times"
    tags: ["voicecode", "repetition", "recommended"]
    bypassHistory: (context) -> true
    action: (input = null, context) ->
      times = parseInt(input) or 1
      if times isnt 1 and context.chainLinkIndex > 1
        times--
      if times > 0 and times < (Settings.maximumRepetitionCount or 100)
        commands = HistoryController.getCommands()
        debug commands
        new Chain().execute (_.fill Array(times), commands.pop()), false


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
        bypassHistory: (context) -> true
        description: "repeat last individual command times [#{value}]"
        historic: true
        tags: ["voicecode", "repetition", "recommended"]
        action: (input, context) ->
          @do 'repetition.command', value, context

module.exports = new Repetition
