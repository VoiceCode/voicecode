class DragonCommand extends Command

  generateCommandBody: (hasChain = false)->
    variables = []
    if @grammarType is "custom"
      # don't need anything because status window is just as fast now
      "echo 'hello'"
    else
      variables.push @getTriggerPhrase()
      variables.push "${varText}" if hasChain
      """
      echo -e "#{variables.join(' ')}" | nc -U /tmp/voicecode.sock
      """
  generateCommandName: (hasChain = false)->
    trigger = if @rule?
      @generateCustomCommandName()
    else
      @getTriggerPhrase()
    trigger = "#{trigger} /!Text!/" if hasChain
    trigger

  generateCustomCommandName: ->
    results = []
    for token in @grammar.tokens
      switch token.kind
        when 'list', 'inlineList'
          if token.optional
            results.push "(//#{token.name}//)"
          else
            results.push "((#{token.name}))"
        when 'text'
          if token.optional
            # TODO make this work with multi-word segments
            results.push "(//#{token.text}//)"
          else
            results.push token.text
        when 'special'
          switch token.name
            when 'spoken'
              results.push @getTriggerPhrase()
    results.join ' '

  needsDragonCommand: ->
    return false if @needsCommand is false
    # TODO see if this is still right
    return false if @scope is 'abstract' and _.isEmpty(@getApplications())
    true

  dragonLists: ->
    @grammar.lists


module.exports = DragonCommand
