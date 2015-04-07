class Commands.Chain
  constructor: (phrase) ->
    @phrase = @normalizePhrase phrase
  normalizePhrase: (phrase) ->
    phrase.toLowerCase()#.replace(/\s\./g, ".")
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

      # appleScript = @makeAppleScriptCommand combined
      if shouldInvoke
        pool = $.NSAutoreleasePool('alloc')('init')
        _.each combined, (callback) ->
          if callback?
            callback.call(Actions)
        pool('release')

        # @invokeShell appleScript

      if Meteor.isServer
        Commands.lastFullCommand = combined
        inserted = PreviousCommands.insert
          createdAt: new Date()
          interpretation: results
          spoken: @phrase
          # generated: combined
        # console.log "result is #{inserted}"

      # {interpretation: results, generated: combined}
    null

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
