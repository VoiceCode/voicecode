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
      else if c is "–"
        item = "dash"
      else if c is ","
        item = "comma"
      result.push item
    result.join('')
  parse: ->
    @normalizeStructure Parser.parse(@phrase)
  execute: (shouldInvoke) ->
    Commands.subcommandIndex = 0
    Commands.repetitionIndex = 0
    results = @parse()
    console.log "parsed: #{JSON.stringify results}"
    if results?
      combined = _.map(results, (result) ->
        command = new Commands.Base(result.command, result.arguments)
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
      if command.triggerScopes?.length
        if Actions.currentApplication() in command.triggerScopes
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

  mergeTextualCommands: (previous, current) ->
    previous.arguments ?= []
    previous.arguments.push current.command
    if Object.prototype.toString.call(current.arguments) is '[object Array]'
      #concat arrays
      previous.arguments = previous.arguments.concat(current.arguments)
    else
      # if any arg, push it
      previous.arguments.push current.arguments

  mergeLiteralCommands: (previous, current) ->
    previous.arguments = previous.arguments.concat(current.arguments)

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
