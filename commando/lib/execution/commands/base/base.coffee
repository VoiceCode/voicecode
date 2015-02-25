@Commands ?= {}
Commands.mapping = {}
Commands.history = []
Commands.context = "global"

class Commands.Base
  constructor: (@namespace, @input) ->
    @info = Commands.mapping[@namespace] 
    @kind = @info.kind
    @repeatable = @info.repeatable
    @actions = @info.actions
  transform: ->
    Transforms[@info.transform]
  generate: ->
    if @repeatable
      @generateRepeating(@repeatCount())
    else
      @generateBaseCommand()
  generateBaseCommand: ->
    switch @kind
      when "text"
        if @input?.length
          transformed = @applyTransform(@input)
          preCommand = if @info.padLeft
            Scripts.spacePad()
          else
            ""
          [preCommand, Scripts.makeTextCommand(transformed)].join("\n")
        else
          if @info.fallbackService?
            Scripts.clickServiceItem(@info.fallbackService)
      when "number"
        preCommand = if @info.padLeft
          Scripts.spacePad()
        else
          ""
        [preCommand, Scripts.makeTextCommand "#{@input}"].join("\n")
      when "action"
        if @info.contextualActions?
          scopeCases = []
          _.each @info.contextualActions, (scenarioInfo, scenarioName) ->
            scopeCases.push(
              requirements: scenarioInfo.requirements
              generated: Scripts.joinActionCommands(scenarioInfo.actions, @input)
            )
          fallback = if @actions
            Scripts.joinActionCommands(@actions, @input)
          else
            Scripts.outOfContext(@namespace)
            
          Scripts.applicationScope scopeCases, fallback
        else
          if @actions?.length
            Scripts.joinActionCommands(@actions, @input)
      when "word"
        transformed = Transforms.identity([@info.word].concat(@input or []))
        Scripts.makeTextCommand(transformed)
      # when "modifier"
      #   @makeModifierCommand @input
  applyTransform: (textArray) ->
    transform = @transform()
    @transform()(textArray)
  repeatCount: ->
    n = parseInt(@input)
    if n? and n > 1
      n
    else
      1
  # makeModifierCommand: (input) ->
  #   string = input.toString()
  #   if string.length
  #     code = ModifierTargets[string] or ModifierTargets[string.charAt(0)]
  #     if code?
  #       ms = Scripts.makeModifierString(@info.modifiers)
  #       kc = Scripts.makeKeycode(code, ms)
  #       Scripts.makeSystemEventsCommand kc
  #     else
  #       ""
  #   else
  #     ""
  generateRepeating: (number) ->
    """
    repeat #{number} times
    #{@generateBaseCommand()}
    end repeat
    """
  getTriggerPhrase: () ->
    @info.triggerPhrase or @namespace
  generateFullCommand: () ->
    commandText = @generateBaseCommand()
    space = @info.namespace or @namespace
    if @info.contextSensitive
      """
      on srhandler(vars)
        set dictatedText to (varText of vars)
        set encodedText to (do shell script "/usr/bin/python -c 'import sys, urllib; print urllib.quote(sys.argv[1],\\"\\")' " & quoted form of dictatedText)
        set space to "#{space}"
        set toExecute to "curl http://commando:5000/parse/" & space & "/" & encodedText
        do shell script toExecute
      end srhandler
      """
    else
      """
      on srhandler(vars)
        set dictatedText to (varText of vars)
        if dictatedText = "" then
        #{commandText}
        set toExecute to "curl http://commando:5000/parse/miss/#{space}"
        do shell script toExecute
        else
        set encodedText to (do shell script "/usr/bin/python -c 'import sys, urllib; print urllib.quote(sys.argv[1],\\"\\")' " & quoted form of dictatedText)
        set space to "#{space}"
        set toExecute to "curl http://commando:5000/parse/" & space & "/" & encodedText
        do shell script toExecute
        end if
      end srhandler
      """
  generateFullShellCommand: () ->
    space = @info.namespace or @namespace
    if @info.contextSensitive
      """
      curl http://commando:5000/parse/command --data-urlencode spoken="${varText}" --data-urlencode space="#{space}"
      """
    else
      """
      if [ -z $varText ]
      then
        osascript ~/voicecode/applescripts/#{space}.scpt
        curl http://commando:5000/parse/miss space="#{space}"
      else
        curl http://commando:5000/parse/command --data-urlencode spoken="${varText}" --data-urlencode space="#{space}"
      fi
      """
  generateDragonCommandName: () ->
    "#{@getTriggerPhrase()} /!Text!/"