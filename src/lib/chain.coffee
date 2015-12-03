class Chain
  preprocessors = []
  constructor: (@phrase = null) ->

  @preprocess: (identity, callback) ->
    preprocessors = _.reject preprocessors, _.matchesProperty 'identity.name', identity.name
    preprocessors.push {identity, callback}

  parse: ->
    if ParserController.isInitialized()
      parsed = ParserController.parse(@phrase)
      parsed = _.map parsed, (parsedCommand) ->
        _.extend parsedCommand,
          command: Commands.getBySpoken(parsedCommand.command)?.id
          spoken: parsedCommand.command
      parsed = @normalizeStructure parsed
      @applyMouseLatency parsed
      log 'chainParsed', parsed, JSON.stringify parsed
      parsed
    else
      error 'chainMissingParser', null, "The parser is not initialized -
      probably a problem with the license code, email, or internet connection"

  execute: (chain = null, shouldAutoSpace = true, shouldPreprocess = true) ->
    unless chain?
      chain = @parse()

    # if shouldPreprocess
    #   chain = _.reduce preprocessors, (chain, {identity, callback}) ->
    #     if Scope.active identity
    #       chain = callback chain
    #     chain
    #   , chain
    #   log 'chainPreprocessed', chain, JSON.stringify chain

    # if shouldAutoSpace and Settings.autoSpacingEnabled.call(Actions)
    #   chain = @applyAutoSpacing chain

    unless _.isEmpty chain
      Commands.monitoringMouseToCancelSpacing = false
      emit 'chainExecutionStart', chain
      _.each chain, (link) ->
        chainLinkIndex = HistoryController.getChainLength()
        link.context ?= {}
        _.extend link.context,
            chainLinkIndex: ++chainLinkIndex
            chain: _.cloneDeep chain
        emit 'chainLinkWillExecute', {link, chain}
        try
          new Command(
            link.command
            link.arguments
            link.context
          ).generate().call Actions
          emit 'chainLinkExecuted', {link, chain}
          return true
        catch e
          if e.name is 'breakChain'
            log 'chainBroken', chain, "#{link.command} broke the chain: #{e.message}"
          else
            error 'chainExecutionError', chain, e
          return false

      emit 'chainExecutionEnd', chain
      setTimeout ->
        Commands.monitoringMouseToCancelSpacing = true
      , 150

  generateNestedInterpretation: ->
    results = @parse()
    if results?
      combined = _.map(results, (result) ->
        command = new Command(result.command, result.arguments)
        command.generate()
      )
      combined

  normalizeStructure: (commands) ->
    results = []
    _.each commands, (current) =>
      command = Commands.mapping[current.command]
      previous = _.last(results)
      if @needsCustomScope(command)
        if Scope.active(command)
          if Actions.commandPermitted current.command
            results.push current
        else
          if previous
            if previous.command is "core:literal" or
            Commands.mapping[previous.command].grammarType is "textCapture"
              @mergeTextualCommands(previous, current)
            else
              results.push {command: "core:literal", arguments: [current.spoken]}
          else
            results.push {command: "core:literal", arguments: [current.spoken]}
      else if current.command is "core:literal" and previous?.command is "core:literal"
        @mergeLiteralCommands(previous, current)
      else
        if Actions.commandPermitted current.command
          results.push current
    results

  needsCustomScope: (command) ->
    command.applications?.length or command.when? or command.scope?

  mergeTextualCommands: (previous, current) ->
    previous.arguments ?= []
    previous.arguments.push current.spoken
    if Object.prototype.toString.call(current.arguments) is '[object Array]'
      #concat arrays
      previous.arguments = previous.arguments.concat(current.arguments)
    else
      # if any arg, push it
      previous.arguments.push current.arguments
    previous.arguments = _.compact(previous.arguments)

  mergeLiteralCommands: (previous, current) ->
    previous.arguments = previous.arguments.concat(current.arguments)

  applyMouseLatency: (commands) ->
    latencyIndex = 0
    for current in commands by -1
      command = Commands.mapping[current.command]
      if command.mouseLatency
        current.context ?= {}
        current.context.mouseLatencyIndex = latencyIndex
        latencyIndex += 1
    commands

  applyAutoSpacing: (commands) ->
    results = []
    for current, index in commands
      if index is 0
        previous = HistoryController.getCommands().pop()
        connector = @determineCommandConnector
          previous: previous
          current: current
          multiPhrase: true
      else
        previous = commands[index - 1]
        connector = @determineCommandConnector
          previous: previous
          current: current
          multiPhrase: false
      if connector?
        results.push
          command: connector
      results.push current
    # apply the last element
    connector = @determineCommandConnector
      previous: _.last(commands)
      current: null
      multiPhrase: false

    if connector?
      results.push
        command: connector
    results

  determineCommandConnector: ({previous, current, multiPhrase}) ->
    left = 'undefined'
    right = 'undefined'
    if previous?
      spacing = @getAutoSpacingFromCommand previous, multiPhrase
      if spacing?
        left = spacing.split(' ')[1]
    if current?
      spacing = @getAutoSpacingFromCommand current, multiPhrase
      if spacing?
        right = spacing.split(' ')[0]
    combined = [left, right].join ' '
    if combined.indexOf('never') != -1
      null
    else if combined.indexOf('always') != -1
      'symbol.space'
    else
      switch combined
        when 'normal normal'
          'symbol.space'
        when 'soft normal', 'normal soft'
          'symbol.space'

  getAutoSpacingFromCommand: (command, multiPhrase) ->
    info = Commands.get command.command
    spacing = if multiPhrase
      info.multiPhraseAutoSpacing
    else
      info.autoSpacing
    if spacing?
      if typeof spacing is 'function'
        spacing.call(Actions, command.arguments, command.context)
      else
        spacing

module.exports = Chain
