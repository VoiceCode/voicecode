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
  "numberRange"
  "textCapture"
  "individual"
  "singleSearch"
  "oneArgument"
  "custom"
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
  numberRange: []
  numberRangeContinuous: []
  textCapture: []
  textCaptureContinuous: []
  custom: []
  customContinuous: []
  repeater: []
  findable: []
Commands.delayedEditFunctions = []
Commands.monitoringMouseToCancelSpacing = true

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

# queues all the command edits until sometime in the future, where they are all called at once
Commands.edit = (name, callback) ->
  Commands.delayedEditFunctions.push
    name: name
    callback: callback

Commands.get = (name) ->
  Commands.mapping[name]

Commands.performCommandEdits = ->
  _.each Commands.delayedEditFunctions, (item) ->
    command = Commands.get item.name
    if command?
      item.callback(command)
    else
      console.log "Error editing command: '#{item.name}' was not found"

Commands.override = (name, action) ->
  console.log "ERROR: Commands.override is deprecated. Use Commands.extend"
#   Commands.mapping[name].override = action

Commands.extend = (name, extension) ->
  Commands.edit name, (command) ->
    command.extensions ?= []
    command.extensions.push extension

Commands.before = (name, extension) ->
  Commands.edit name, (command) ->
    command.before ?= []
    command.before.push extension
Commands.after = (name, extension) ->
  Commands.edit name, (command) ->
    command.after ?= []
    command.after.push extension

Commands.addMisspellings = (name, misspellings) ->
  Commands.edit name, (command) ->
    command.misspellings ?= []
    command.misspellings = command.misspellings.concat misspellings

Commands.addAliases = (name, aliases) ->
  console.log "Error adding aliases to '#{name}'. 'addAliases' has been renamed to 'addMisspellings'"

Commands.changeName = (name, newName) ->
  Commands.edit name, (command) ->
    Commands.mapping[newName] = command
    delete Commands.mapping[name]

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

    if type is "custom"
      try
        Commands.mapping[key].customGrammar = customGrammarParser.parse(value.rule)
      catch e
        console.log "error parsing custom grammar for command: #{key}"
        console.log e


class Commands.Base
  constructor: (@namespace, @input, @context={}) ->
    @info = Commands.mapping[@namespace]
    @kind = @info.kind or "action"
    @grammarType = @info.grammarType or "individual"
    @normalizeInput()
  normalizeInput: ->
    switch @info.grammarType
      when "textCapture"
        @input = Actions.normalizeTextArray @input
      when "numberRange"
        @input = @normalizeNumberRange(@input)
  transform: ->
    Transforms[@info.transform]
  generate: ->
    funk = switch @kind
      when "action"
        action = @info.action
        input = @input
        context = @generateContext()
        -> action.call(@, input, context)
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
        segment?.call(@)

  generateContext: ->
    context = {}
    _.extend context, @context
    context.subcommandIndex = Commands.subcommandIndex
    if @info.historic
      _.extend context,
        lastFullCommand: Commands.lastFullCommand
        lastIndividualCommand: Commands.lastIndividualCommand
        repetitionIndex: Commands.repetitionIndex
    context

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
    """
    on srhandler(vars)
      set dictatedText to (varText of vars)
      set toExecute to "curl http://commando:5000/parse --data-urlencode space=\\\"#{space}\\\"" & " --data-urlencode phrase=\\\"" & dictatedText & "\\\""
      do shell script toExecute
    end srhandler
    """
  generateFullCommandWithDigest: ->
    script = @generateFullCommand()
    digest = @digest()
    """
    -- #{digest}
    #{script}
    """

  generateStandaloneDragonBody: ->
    space = @info.namespace or @namespace
    """
    echo -e "#{space}" | nc -U /tmp/voicecode.sock
    """

  generateChainedDragonBody: ->
    space = @info.namespace or @namespace
    # """
    # curl http://commando:5000/parse --data-urlencode space="#{space}" --data-urlencode phrase="\\${varText}"
    # """
    variables = []
    if @grammarType is "custom"
      for item in @info.customGrammar
        if item.list?
          v = item.list.charAt(0).toUpperCase() + item.list.slice(1).toLowerCase()
          variables.push "${var#{v}}"
        else if item.text?
          variables.push item.text
    variables.push "${varText}"
    """
    echo -e "#{space} #{variables.join(' ')}" | nc -U /tmp/voicecode.sock
    """
  generateStandaloneDragonCommandName: ->
    if @grammarType is "custom"
      @generateCustomDragonCommandName(false)
    else
      @getTriggerPhrase()


  generateChainedDragonCommandName: ->
    if @grammarType is "custom"
      @generateCustomDragonCommandName()
    else
      _.compact([@getTriggerPhrase(), "/!Text!/"]).join(' ')
  generateCustomDragonCommandName: (appendVariable = true)->
    results = [@getTriggerPhrase()]
    for item in @info.customGrammar
      if item.list?
        if item.optional
          results.push "(//#{item.list}//)"
        else
          results.push "((#{item.list}))"
      else if item.text?
        if item.optional
          results.push "(//#{item.text}//)"
        else
          results.push item.text
    results.push "/!Text!/" if appendVariable
    results.join ' '


  digest: ->
    CryptoJS.MD5(@generateDragonBody()).toString()

  listNames: ->
    _.collect @info.customGrammar, (item) ->
      item.list if item.list?

  normalizeNumberRange: (input) ->
    if typeof input is "object"
      input
    else
      {first: parseInt(input)}
