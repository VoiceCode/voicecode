class Commands.Chain
  constructor: (phrase) ->
    @phrase = @normalizePhrase phrase
  normalizePhrase: (phrase) ->
    phrase.toLowerCase()#.replace(/\s\./g, ".")
  parse: ->
    Parser.parse @phrase
  execute: (shouldInvoke) ->
    results = @parse()
    console.log "parsed: #{JSON.stringify results}"
    if results?
      combined = _.map(results, (result) ->
        command = new Commands.Base(result.command, result.arguments)
        command.generate()
      ).join('\n')
      appleScript = @makeAppleScriptCommand combined
      if shouldInvoke
        @invokeShell appleScript

      if Meteor.isServer
        inserted = PreviousCommands.insert
          createdAt: new Date()
          interpretation: results
          spoken: @phrase
          generated: combined
        # console.log "result is #{inserted}"

      {interpretation: results, generated: combined}

  makeAppleScriptCommand: (content) ->
    """osascript <<EOD
    #{content}
    EOD
    """
  invokeShell: (command) ->
    console.log command
    if Meteor.isServer
      Shell.exec command, async: true
    else
      command


