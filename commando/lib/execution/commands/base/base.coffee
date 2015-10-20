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

Commands.validate = (name, options) ->
  if typeof name is "object"
    _.each name, (options, name) ->
      Commands.validate name, options
    return
  if options.triggerPhrase?
    if options.triggerPhrase.match(/\(.*?\d+.*?\)/g)?
      console.error "Error in command creation: #{name}"
      console.error 'Please don\'t use integers in triggerPhrase'

Commands.create = (name, options) ->
  Commands.validate name, options
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
    Commands.validate key, command
    Commands.mapping[key] = command

Commands.createDisabled = (name, options) ->
  if typeof name is "string"
    Commands.mapping[name] = options
  else if typeof name is "object"
    Commands.validate name
    _.extend Commands.mapping, name

Commands.createDisabledWithDefaults = (defaults, options) ->
  for key, value of options
    command = _.extend {}, defaults, value
    Commands.validate key, command
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
  Commands.delayedEditFunctions = []

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
  console.log "Error adding aliases to '#{name}'. 'addAliases' has been renamed to 'addMisspellings'. Don't worry, it is still being added, but in the next release 'addAliases' will mean something different."
  Commands.addMisspellings(name, aliases)

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


class @Command
  constructor: (@namespace, @input, @context={}) ->
    @info = Commands.mapping[@namespace]
    @kind = @info.kind or "action"
    @grammarType = @info.grammarType or "individual"
    @normalizeInput()
    @lists = {}
    @variableNames = {}
    if @isDynamicTriggerPhrase()
      @variableNames = @parseVariableNames()
      @lists = @generateLists()

  normalizeInput: ->
    switch @info.grammarType
      when "textCapture"
        @input = Actions.normalizeTextArray @input
      when "numberRange"
        @input = @normalizeNumberRange(@input)
  transform: ->
    Transforms[@info.transform]
  generate: ->
    input = @input
    context = @generateContext()
    funk = switch @kind
      when "action"
        action = @info.action
        -> action.call(@, input, context)
    # if @info.override?
    #   override = @info.override
    #   input = @input
    #   -> override.call(@, input, funk)
    core = if @info.extensions?
      extensions = []
      extensions.push funk
      _.each @info.extensions, (e) ->
        extensions.push ->
          e.call(@, input, context)
      ->
        @extensionsStopped = false
        for callback in extensions.reverse()
          unless @extensionsStopped
            callback.call(@, input, context)
    else
      funk

    segments = []

    # before actions
    if @info.before?
      beforeList = []
      _.each @info.before, (e) ->
        beforeList.push ->
          e.call(@, input, context)
      segments.push ->
        for callback in beforeList.reverse()
          callback.call(@)

    # core actions
    segments.push core

    # after actions
    if @info.after?
      afterList = []
      _.each @info.after, (e) ->
        afterList.push ->
          e.call(@, input, context)
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
    context.chain = Commands.lastParsing
    if @info.historic
      _.extend context,
        lastFullCommand: Commands.lastFullCommand
        lastIndividualCommand: Commands.lastIndividualCommand
        repetitionIndex: Commands.repetitionIndex
    context

  # DEPRECATED
  listNames: ->
    _.collect @info.customGrammar, (item) ->
      item.list if item.list?

  normalizeNumberRange: (input) ->
    if typeof input is "object"
      input
    else
      if input?
        {first: parseInt(input)}
      else
        {first: null, last: null}

  getTriggerPhrase: ->
    triggerPhrase = @info.namespace or @namespace
    if @info.triggerPhrase?
      triggerPhrase = @info.triggerPhrase
    triggerPhrase

  isDynamicTriggerPhrase: ->
    @getTriggerPhrase().match(/\(/)?

  # variables do not get `beautified` here.
  # (some/thing else) will result in 'some/thing else'
  # @getAllVariableNames() will make it into 'somethingelse'
  parseVariableNames: ->
    return [] unless @info.triggerPhrase?
    optional = @info.triggerPhrase.match(/\([a-zA-Z/\s]+\)(?=\*)/g)
    mandatory = @info.triggerPhrase.match(/\([a-zA-Z/\s]+\)(?!\*)/g)
    return [] unless mandatory? or optional?
    variables = {}
    variables.mandatory = _.map mandatory, (v) -> v.replace /[()]/g, ''
    variables.optional = _.map optional, (v) -> v.replace /[()]/g, ''
    return variables

  getAllVariableNames: ->
    _.chain(@parseVariableNames()).flatten().map((v) -> v.replace /[\W/\s]/g, '').value()

  getVariableValuesFor: (variableName) ->
    if @info.variables?[variableName]?
      if _.isArray @info.variables[variableName]
        @info.variables[variableName]
      else if _.isObject @info.variables[variableName]
        _.flatten _.map @info.variables[variableName].mapping, (v) -> v
    else
      variableName = variableName.split '/'
      _.unique _.flatten _.map variableName, (v) -> v.split ' '

  generateLists: ->
    variableNames = @getAllVariableNames()
    # console.log variableNames
    occurrenceCount = _.countBy(variableNames, (v) -> v)
    variableValues = {}
    _.each _.unique(variableNames), (variableName) =>
      variableValues[variableName] = @getVariableValuesFor variableName

    # console.error occurrenceCount
    # console.error variableNames
    # console.error variableValues
    lists = {}
    maximumTokenCount = {}
    _.each _.unique(variableNames), (variableName) ->
      lists[variableName] ?= {}
      maximumTokenCount[variableName] ?= []
      # breaking up each value into tokens and counting how many sublists
      # this list will need to be split into
      variableValues[variableName] = _.map variableValues[variableName], (value, index) ->
        value = value.split ' '
        if maximumTokenCount[variableName] < value.length
          maximumTokenCount[variableName] = value.length
        value
    # console.error variableValues
    # console.error maximumTokenCount

    _.each _.unique(variableNames), (variableName) ->
      _.each [1..occurrenceCount[variableName]], (occurrence) ->
        lists[variableName][occurrence] ?= {}
        _.each [1..maximumTokenCount[variableName]], (sublistIndex) ->
          lists[variableName][occurrence][sublistIndex] =
          _.compact(_.map variableValues[variableName], (tokens) -> tokens[(sublistIndex-1)] || null)
    # console.error lists
    lists
