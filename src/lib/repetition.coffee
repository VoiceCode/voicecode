Chain.preprocess 'normalize-chain-repetition', (chain) ->
  _.each chain, ({command}, index) ->
    if command is 'repetition.chain'
      if chain[index+1]?.command.match(/repetition\.\d$/)?
        chain[index+1].command = chain[index+1].command + '.inline'
  chain

Commands.createDisabled
  'repetition.chain':
    spoken: 'creek'
    grammarType: "integerCapture"
    description: "Repeat N-th complete spoken phrase in history. Defaults to previous."
    tags: ["voicecode", "repetition", "recommended"]
    bypassHistory: (context) -> true
    action: (offset, context) ->
      if _.isNaN offset
        offset = 1
      if context.chain.length is 1
        HistoryController.hasAmnesia yes
      chain = HistoryController.getChain offset
      if context.repeat?
        chain = _.fill Array(context.repeat), chain
        chain = _.flatten chain
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
      description = 'command'
      if key.match(/way/)?
        description = 'chain'
        suffix = '.inline'

      Commands.createDisabled "repetition.#{value}#{suffix}",
        spoken: key
        repeater: value
        bypassHistory: (context) -> true
        description: "Repeat previous in-line #{description} #{value} times"
        tags: ["voicecode", "repetition", "recommended"]
        action: (input, context) ->
          if key.match(/way/)?
            context.repeat = value
            if context.chainLinkIndex > 1 and value isnt 1
              context.repeat = value - 1
            @do "repetition.chain", 0, context
          else
            @do "repetition.command", value, context

module.exports = new Repetition
