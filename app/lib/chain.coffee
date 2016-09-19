Events.on 'chainShouldExecute', (phrase) ->
  if SlaveController.isActive()
    SlaveController.process phrase
  else
    Fiber(->
      HAS_FIBER = true
      new Chain(phrase).execute()
    ).run()

Events.on 'commandsShouldExecute', (chain) ->
  if SlaveController.isActive()
    # SlaveController.process phrase
    # FIXME
  else
    Fiber(->
      HAS_FIBER = true
      console.log 'commandsShouldExecute', chain
      new Chain().execute(chain, false, true)
    ).run()

class Chain
  preprocessors = []
  constructor: (@phrase = null) ->

  @preprocess: (identity, callback) ->
    preprocessors = _.reject preprocessors
    , _.matchesProperty 'identity.name', identity.name
    preprocessors.push {identity, callback}

  parse: ->
    if ParserController.isInitialized()
      parsed = ParserController.parse(@phrase)
      parsed = _.map parsed, (parsedCommand) ->
        parsedCommand.command = parsedCommand.c
        parsedCommand.arguments = parsedCommand.a
        delete parsedCommand.c
        delete parsedCommand.a
        parsedCommand
      @applyMouseLatency parsed
      log 'chainParsed', parsed, JSON.stringify parsed
      parsed
    else
      error 'chainMissingParser', null, "The parser is not initialized -
      probably a problem with the license code, email, or internet connection"

  execute: (chain = null, shouldAutoSpace = true, shouldPreprocess = true) ->
    return if _.isEmpty chain ?= @parse()
    if shouldPreprocess
      chain = _.reduce preprocessors, (chain, {identity, callback}) ->
        if Scope.active identity
          chain = callback chain
        chain
      , chain
      log 'chainPreprocessed', chain, JSON.stringify chain
    chainBroken = false
    comboBreaker = (reason) ->
      chainBroken = {reason}

    Events.once 'breakChain', comboBreaker
    Events.once 'chainDidExecute', ->
      Events.unsubscribe 'breakChain', comboBreaker

    passableChain = _.cloneDeep chain
    emit 'chainWillExecute', chain
    _.each chain, (link, index) ->
      chainLinkIndex = HistoryController.getChainLength()
      link.context ?= {}
      _.extend link.context,
          chainLinkIndex: chainLinkIndex++
          chain: passableChain
      emit 'commandWillExecute', {link, chain}
      try
        new Command(
          link.command
          link.arguments
          link.context
        ).execute()
        emit 'commandDidExecute', {link, chain}
      catch e
        error 'commandFailedExecute'
        , {link, chaine, stack: e.stack}
        , e.message or e
        chainBroken = {reason: e.message or e, error: e}
      finally
        if _.isObject chainBroken
          unless chainBroken.error?
            log 'chainBroken', {link, chain},
            "#{link.command} broke the chain:\n
            #{chainBroken.reason}"
          else
            error 'chainFailedExecute'
            , {link, chaine, stack: e.stack}
            , e.message or e
          return false
        return true

    unless chainBroken
      log 'chainDidExecute', chain

  generateNestedInterpretation: ->
    results = @parse()
    if results?
      combined = _.map(results, (result) ->
        command = new Command(result.command, result.arguments)
        command.generate()
      )
      combined

  applyMouseLatency: (commands) ->
    latencyIndex = 0
    for current in commands by -1
      command = Commands.mapping[current.command]
      if command.mouseLatency
        current.context ?= {}
        current.context.mouseLatencyIndex = latencyIndex
        latencyIndex += 1
    commands

module.exports = Chain
