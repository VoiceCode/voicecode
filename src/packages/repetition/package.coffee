pack = Packages.register
  name: 'repetition'
  description: 'Repetition of current or previous commands or phrases'

# TODO - give an easy way for packages to create vocabulary terms

pack.settings
  chainRepetitionSuffix: 'way'
  maxRepetitionCount: 100
  values:
    # you can add more repetition commands like this
    wink: 1
    soup: 2
    trace: 3
    quarr: 4
    fypes: 5

# If repetition.chain is followed by repetition.command || repetition.X
# replace repetition.command with appropriate repetition.X.inline
Chain.preprocess {
  scope: 'global'
  name: 'normalize-chain-repetition'
  }, (chain) ->
    _.each chain, (command, index) ->
      return true unless command?
      command = command.command
      if command is 'repetition.chain'
        if chain[index+1]?.command.match(/^repetition.command$/)?
          times = parseInt(chain[index+1].arguments) or 1
          chain[index].context ?= {}
          chain[index].context.repeat = times
          delete chain[index+1]

        if chain[index+1]?.command.match(/^repetition\.\d$/)?
          chain[index+1].command = chain[index+1].command + '.inline'
    _.compact chain

pack.commands
  'chain':
    spoken: 'creek'
    grammarType: "integerCapture"
    description: "Repeat N-th complete spoken phrase in history. Defaults to previous."
    tags: ["voicecode", "repetition", "recommended"]
    bypassHistory: (context) -> true
    action: (offset = 1, context) ->
      if context.chain.length is 1
        HistoryController.hasAmnesia yes
      chain = HistoryController.getChain offset
      if context.repeat?
        chain = _.fill Array(context.repeat), chain
        chain = _.flatten chain
      chain = new Chain().execute chain, false
      HistoryController.hasAmnesia no

  'command':
    spoken: 'repple'
    grammarType: "integerCapture"
    repeater: "variable"
    description: "Repeats an individual command component.
    Right after any command say [repple X] to repeat it X times"
    tags: ["voicecode", "repetition", "recommended"]
    bypassHistory: (context) -> true
    action: (input, context) ->
      times = parseInt(input) or 1
      if times isnt 1 and context.chainLinkIndex > 1
        times--
      if times > 0 and times < (pack.settings().maxRepetitionCount or 100)
        commands = HistoryController.getCommands()
        new Chain().execute (_.fill Array(times), commands.pop()), false


# individual repetition commands
_.each pack.settings().values, (repetitionCount, word) ->
  pack.command "command-#{repetitionCount}",
    spoken: word
    repeater: repetitionCount
    bypassHistory: (context) -> true
    description: "Repeat previous individual command #{repetitionCount} times"
    tags: ["recommended"]
    action: (input, context) ->
      @do "repetition:command", repetitionCount, context

# full chain repetition commands
_.each pack.settings().values, (repetitionCount, word) ->
  pack.command "chain-#{repetitionCount}-inline",
    spoken: [word, pack.settings().chainRepetitionSuffix].join ' '
    repeater: repetitionCount
    bypassHistory: (context) -> true
    description: "Repeat previous phrase #{repetitionCount} times"
    tags: ["recommended"]
    action: (input, context) ->
      context.repeat = repetitionCount
      if context.chainLinkIndex > 1 and repetitionCount isnt 1
        context.repeat = repetitionCount - 1
      @do "repetition:chain", 0, context
