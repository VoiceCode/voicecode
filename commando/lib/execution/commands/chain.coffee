class Commands.Chain
  constructor: (phrase) ->
    @phrase = @normalizePhrase phrase
  normalizePhrase: (phrase) ->
    result = []
    parts = phrase.toLowerCase().split('')
    for c, index in parts
      item = c
      # capitalize I's
      if c is "i" and (index is 0 or parts[index - 1] is " ") and (index is (parts.length - 1) or parts[index + 1] is " ")
        item = "I"
      else if c is "…"
        item = "ellipsis"
      else if c is "ï"
        item = "i"
      else if c is "–"
        item = "dash"
      else if c is ","
        item = "comma"
      result.push item
    result.join('')
  parse: ->
    if typeof Parser is 'undefined'
      console.log "ERROR: the parser is not initialized - probably a problem with the license code, email, or internet connection"
    else
      # try
      parsed = Parser.parse(@phrase)
      commands = @normalizeStructure parsed
      @applyMouseLatency commands
      if Settings.autoSpacingEnabled.call(Actions)
        commands = @applyAutoSpacing commands
      commands
      # catch e
      #   console.log e
      #   null
  execute: (shouldInvoke) ->
    Commands.subcommandIndex = 0
    Commands.repetitionIndex = 0
    results = @parse()
    console.log "parsed: #{JSON.stringify results}"
    if results?
      Commands.lastCommandOfPreviousPhrase = _.last(results)
      Commands.monitoringMouseToCancelSpacing = false
      combined = _.map(results, (result) ->
        command = new Commands.Base(result.command, result.arguments, result.context)
        individual = command.generate()
        if command.info.ignoreHistory
          Commands.repetitionIndex = 0
        else
          Commands.lastIndividualCommand = individual
          Commands.repetitionIndex += 1

        Commands.subcommandIndex += 1
        individual
      )

      Commands.previousUndoByDeletingCount = Commands.aggregateUndoByDeletingCount
      Commands.aggregateUndoByDeletingCount = 0
      if shouldInvoke
        _.each combined, (callback) ->
          if callback?
            Commands.currentUndoByDeletingCount = 0
            callback.call(Actions)
            if Commands.currentUndoByDeletingCount > 0
              Commands.aggregateUndoByDeletingCount += Commands.currentUndoByDeletingCount
            else
              Commands.aggregateUndoByDeletingCount = 0

      if Meteor.isServer
        Commands.lastFullCommand = combined
        inserted = PreviousCommands.insert
          createdAt: new Date()
          interpretation: results
          spoken: @phrase

      Meteor.setTimeout ->
        Commands.monitoringMouseToCancelSpacing = true
      , 150

      {interpretation: results, generated: combined}


  generateNestedInterpretation: ->
    results = @parse()
    if results?
      combined = _.map(results, (result) ->
        command = new Commands.Base(result.command, result.arguments)
        command.generate()
      )
      combined

  normalizeStructure: (commands) ->
    results = []
    _.each commands, (current) =>
      command = Commands.mapping[current.command]
      previous = _.last(results)
      if @needsCustomScope(command)
        if @customScopeActive(command)
          results.push current
        else
          if previous
            if previous.command is "vc-literal" or Commands.mapping[previous.command].grammarType is "textCapture"
              @mergeTextualCommands(previous, current)
            else
              results.push {command: "vc-literal", arguments: [current.command]}
          else
            results.push {command: "vc-literal", arguments: [current.command]}
      else if current.command is "vc-literal" and previous?.command is "vc-literal"
        @mergeLiteralCommands(previous, current)
      else
        if Actions.commandPermitted current.command
          results.push current
    results

  needsCustomScope: (command) ->
    command.triggerScopes?.length or command.when?

  customScopeActive: (command) ->
    active = true
    if command.triggerScopes?.length
      active = Actions.currentApplication() in command.triggerScopes
    if active
      if command.when?
        result = command.when.call(Actions)
        console.log result: result
        result
      else
        active
    else
      active

  mergeTextualCommands: (previous, current) ->
    previous.arguments ?= []
    previous.arguments.push current.command
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
        previous = Commands.lastCommandOfPreviousPhrase
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
      'skoosh'
    else
      switch combined
        when 'normal normal'
          'skoosh'
        when 'soft normal', 'normal soft'
          'skoosh'
      
  getAutoSpacingFromCommand: (command, multiPhrase) ->
    info = Commands.mapping[command.command]
    spacing = if multiPhrase
      info.multiPhraseAutoSpacing
    else
      info.autoSpacing
    if spacing?
      if typeof spacing is 'function'
        spacing.call(Actions, command.arguments, command.context)
      else
        spacing

  makeAppleScriptCommand: (content) ->
    """osascript <<EOD
    #{content}
    EOD
    """
  makeJavascriptCommand: (content) ->
    """osascript -l JavaScript <<EOD
    #{content}
    EOD
    """

  invokeShell: (command) ->
    console.log command
    if Meteor.isServer
      Shell.exec command, async: true
    else
      command
