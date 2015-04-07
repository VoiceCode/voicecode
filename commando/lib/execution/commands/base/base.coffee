@Commands ?= {}
Commands.mapping = {}
Commands.history = []
Commands.context = "global"
Commands.conditionalModules = {}
Commands.lastIndividualCommand = null
Commands.lastFullCommand = null
Commands.subcommandIndex = 0
Commands.repetitionIndex = 0

Commands.registerConditionalModuleCommands = (moduleName, commands) ->
  Commands.conditionalModules[moduleName] ?= {}
  _.extend Commands.conditionalModules[moduleName], commands

Commands.loadConditionalModules = ->
  # _.each Commands.conditionalModules, (value, key) ->
  #   if CommandoSettings.modules[key] is true
  #     _.extend Commands.mapping, value
  _.each Commands.mapping, (value, key) ->
    enabled = !!Enables.findOne(name: key)?.enabled
    # enabled = true
    Commands.mapping[key].enabled = enabled

class Commands.Base
  constructor: (@namespace, @input) ->
    @info = Commands.mapping[@namespace] 
    @kind = @info.kind
    @repeatable = @info.repeatable
    @actions = @info.actions
  transform: ->
    Transforms[@info.transform]
  generate: ->
    switch @kind
      when "action"
        action = @info.action
        input = @input
        -> action.call(@, input)
      when "historic"
        action = @info.action
        input = @input
        context =
          lastFullCommand: Commands.lastFullCommand
          lastIndividualCommand: Commands.lastIndividualCommand
          repetitionIndex: Commands.repetitionIndex
        -> action.call(@, context, input)
      when "text"
        if @input?.length or @info.transformWhenBlank
          transformed = @applyTransform(@input)
          prefix = @info.prefix or ""
          suffix = @info.suffix or ""
          -> @string(transformed)
          # Scripts.makeTextCommand([prefix, transformed, suffix].join(''))
        else
          fallback = @info.fallbackService
          transform = @info.transform
          -> 
            if fallback?
              @key "C", ['command']
              @delay 200
              contents = @getClipboard()
              transformed = SelectionTransforms[transform](contents)
              @string transformed
            # Commands.incomingSelectionHandler = SelectionTransforms[transform]
            # @clickServiceItem("send-selection-to-voicecode")
              # @clickServiceItem(fallback)
      when "word"
        transformed = Transforms.identity([@info.word].concat(@input or []))
        -> @string(transformed)
      when "combo"
        combined = _.map(@info.combo, (subCommand) ->
          command = new Commands.Base(subCommand)
          command.generate()
        )
        ->
          _.each combined, (callback) ->
           if callback?
             callback.call(Actions)
      # when "number"
      #   preCommand = if @info.padLeft
      #     Scripts.spacePad()
      #   else
      #     ""
      #   [preCommand, Scripts.makeTextCommand "#{@input}"].join("\n")
      # when "action"
      #   if @info.contextualActions?
      #     scopeCases = []
      #     me = @
      #     _.each @info.contextualActions, (scenarioInfo, scenarioName) ->
      #       scopeCases.push(
      #         requirements: scenarioInfo.requirements
      #         generated: Scripts.joinActionCommands(scenarioInfo.actions, me.input)
      #       )
      #     fallback = if @actions
      #       Scripts.joinActionCommands(@actions, @input)
      #     else
      #       Scripts.outOfContext(@namespace)
            
      #     Scripts.applicationScope scopeCases, fallback
      #   else
      #     if @actions?.length
      #       Scripts.joinActionCommands(@actions, @input)

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
  getTriggerPhrase: () ->
    @info.triggerPhrase or @namespace
  getTriggerScope: ->
    @info.triggerScope or "Global"
  isSpoken: ->
    @info.isSpoken != false
  generateFullCommand: () ->
    space = @info.namespace or @namespace
    # if @info.contextSensitive
    """
    on srhandler(vars)
      set dictatedText to (varText of vars)
      set toExecute to "curl http://commando:5000/parse --data-urlencode space=\\\"#{space}\\\"" & " --data-urlencode phrase=\\\"" & dictatedText & "\\\""
      do shell script toExecute
    end srhandler
    """
    # else
    #   """
    #   on srhandler(vars)
    #     set dictatedText to (varText of vars)
    #     if dictatedText = "" then
    #     #{commandText}
    #     set toExecute to "curl http://commando:5000/miss --data-urlencode space=\\\"#{space}\\\""
    #     do shell script toExecute
    #     else
    #     set toExecute to "curl http://commando:5000/parse --data-urlencode space=\\\"#{space}\\\"" & " --data-urlencode phrase=\\\"" & dictatedText & "\\\""
    #     do shell script toExecute
    #     end if
    #   end srhandler
    #   """
  generateFullCommandWithDigest: ->
    script = @generateFullCommand()
    digest = @digest()
    """
    -- #{digest}
    #{script}
    """
  generateDragonBody: ->
    space = @info.namespace or @namespace
    # """
    # curl http://commando:5000/parse --data-urlencode space="#{space}" --data-urlencode phrase="\\${varText}"
    # """
    """
    echo -e "#{space} ${varText}" | nc -U /tmp/voicecode.sock
    """
  generateDragonCommandName: () ->
    "#{@getTriggerPhrase()} /!Text!/"
  digest: ->
    CryptoJS.MD5(@generateDragonBody()).toString()