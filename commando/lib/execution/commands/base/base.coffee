@Commands ?= {}
Commands.mapping = {}
Commands.history = []
Commands.context = "global"
Commands.conditionalModules = {}
Commands.lastIndividualCommand = null
Commands.lastFullCommand = null
Commands.subcommandIndex = 0
Commands.repetitionIndex = 0
Commands.currentUndoByDeletingCount = 0
Commands.aggregateUndoByDeletingCount = 0
Commands.previousUndoByDeletingCount = 0
Commands.primaryGrammarTypes = [
  "numberCapture"
  "textCapture"
  "individual"
  "singleSearch"
  "oneArgument"
]
Commands.keys =
  oneArgument: []
  oneArgumentContinuous: []
  singleSearch: []
  singleSearchContinuous: []
  individual: []
  individualContinuous: []
  numberCapture: []
  numberCaptureContinuous: []
  textCapture: []
  textCaptureContinuous: []
  repeater: []
  findable: []

Commands.create = (name, options) ->
  if typeof name is "string"
    options.enabled = true
    Commands.mapping[name] = options
  else if typeof name is "object"
    _.extend Commands.mapping, name
    for key in _.keys(name)
      Commands.mapping[key].enabled = true

Commands.createWithDefaults = (defaults, options) ->
  for key, value of options
    command = _.extend {}, defaults, value
    command.enabled = true
    Commands.mapping[key] = command

Commands.createDisabled = (name, options) ->
  if typeof name is "string"
    Commands.mapping[name] = options
  else if typeof name is "object"
    _.extend Commands.mapping, name

Commands.createDisabledWithDefaults = (defaults, options) ->
  for key, value of options
    command = _.extend {}, defaults, value
    Commands.mapping[key] = command

Commands.override = (name, action) ->
  console.log "ERROR: Commands.override is deprecated. Use Commands.extend"
#   Commands.mapping[name].override = action

Commands.extend = (name, extension) ->
  Commands.mapping[name].extensions ?= []
  Commands.mapping[name].extensions.push extension
Commands.before = (name, extension) ->
  Commands.mapping[name].before ?= []
  Commands.mapping[name].before.push extension
Commands.after = (name, extension) ->
  Commands.mapping[name].after ?= []
  Commands.mapping[name].after.push extension

Commands.addAliases = (key, aliases) ->
  Commands.mapping[key].aliases ?= []
  Commands.mapping[key].aliases = Commands.mapping[key].aliases.concat aliases

Commands.changeName = (old, newName) ->
  Commands.mapping[newName] = Commands.mapping[old]
  delete Commands.mapping[old]

Commands.loadConditionalModules = (enabledCommands) ->
  for key, value of Commands.mapping
    enabled = enabledCommands[key]
    Commands.mapping[key].enabled = Commands.mapping[key].enabled or enabled

    type = value.grammarType or "individual"

    if type in Commands.primaryGrammarTypes
      Commands.keys[type].push key
      unless value.continuous is false
        Commands.keys[type + "Continuous"].push key

    if value.findable?
      Commands.keys.findable.push key

    if value.repeater?
      Commands.keys.repeater.push key


class Commands.Base
  constructor: (@namespace, @input) ->
    @info = Commands.mapping[@namespace]
    @kind = @info.kind or "action"
  transform: ->
    Transforms[@info.transform]
  generate: ->
    funk = switch @kind
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
          -> @string([prefix, transformed, suffix].join(''))
        else
          fallback = @info.fallbackService
          transform = @info.transform
          ->
            if fallback?
              switch @currentApplication()
                when "Atom"
                  @runAtomCommand "transformSelectedText", transform
                else
                  if @isTextSelected()
                    contents = @getSelectedText()
                    transformed = SelectionTransformer[transform](contents)
                    @string transformed
    # if @info.override?
    #   override = @info.override
    #   input = @input
    #   -> override.call(@, input, funk)
    core = if @info.extensions?
      input = @input
      extensions = []
      extensions.push funk
      _.each @info.extensions, (e) ->
        extensions.push ->
          e.call(@, input)
      ->
        @extensionsStopped = false
        for callback in extensions.reverse()
          unless @extensionsStopped
            callback.call(@)
    else
      funk

    segments = []

    # before actions
    if @info.before?
      input = @input
      beforeList = []
      _.each @info.before, (e) ->
        beforeList.push ->
          e.call(@, input)
      segments.push ->
        for callback in beforeList.reverse()
          callback.call(@)

    # core actions
    segments.push core

    # after actions
    if @info.after?
      input = @input
      afterList = []
      _.each @info.after, (e) ->
        afterList.push ->
          e.call(@, input)
      segments.push ->
        for callback in afterList.reverse()
          callback.call(@)

    # needs to return an executable function that can be called later.
    # context should be explicitly set to an 'Actions' instance when called
    ->
      for segment in segments
        segment.call(@)

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
    if @info.triggerPhrase is undefined
      @namespace
    else
      @info.triggerPhrase
  getTriggerScopes: ->
    @info.triggerScopes or [@info.triggerScope or "global"]
  needsDragonCommand: ->
    @info.needsDragonCommand != false
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
    _.compact([@getTriggerPhrase(), "/!Text!/"]).join(' ')
  digest: ->
    CryptoJS.MD5(@generateDragonBody()).toString()
