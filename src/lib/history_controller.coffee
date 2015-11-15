class HistoryController
  previousContext = null
  amnesia = false
  greedy = false
  timeDilation = 0

  constructor: ->
    @history = {}

    Events.on 'chainExecutionStart', =>
      context = @getCurrentContext()
      unless greedy
        @startNewChain()

    Events.on 'chainExecutionEnd', =>
      @history[previousContext][0] = _.compact @history[previousContext][0]
      if _.isEmpty @history[previousContext][0]
        @forgetChain 0

    Events.on 'chainLinkExecuted', ({link}) =>
      command = Commands.get link.command
      unless command.bypassHistory?(link.context)
        currentContext = @getCurrentContext()
        if previousContext isnt currentContext
          @startNewChain currentContext
        unless amnesia
          @history[currentContext][0].push _.pick link, ['command', 'arguments']
        else
          delete link.context

  forgetChain: (offset) ->
    delete @history[previousContext][offset]
    @history[previousContext] = _.values _.compact @history[previousContext]

  getCommands: (offset = 0, count = 1, context = null) ->
    context ?= @getCurrentContext()

  getChain: (offset = 0, context = null) ->
    context ?= @getCurrentContext()
    @history[context][timeDilation + offset]

  hasAmnesia: (yesNo) ->
    amnesia = yesNo

  isGreedy: (yesNo) ->
    greedy = yesNo

  startNewChain: (context = null) ->
    context ?= @getCurrentContext()
    @history[context] ?= []
    @history[context].unshift []
    previousContext = context

  travelInTime: (amount) ->
    timeDilation += amount

  doChainMaintenance: ->
    # delete old stuff
    # dump to disk?

  getCurrentContext: ->
    Actions.currentApplication()

  getChainLength: (offset = 0) ->
    _.size @history[@getCurrentContext()][offset]

module.exports = new HistoryController
