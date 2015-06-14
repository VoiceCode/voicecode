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
      result.push item
    result.join('')
  parse: ->
    Parser.parse @phrase
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
