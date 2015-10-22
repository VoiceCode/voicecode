class Commands
  constructor: ->
    @mapping = {}
    @history = []
    @context = "global"
    @initialized = false
    @conditionalModules = {}
    @lastIndividualCommand = null
    @lastFullCommand = null
    @subcommandIndex = 0
    @repetitionIndex = 0
    @currentUndoByDeletingCount = 0
    @aggregateUndoByDeletingCount = 0
    @previousUndoByDeletingCount = 0
    @primaryGrammarTypes = [
      "numberCapture"
      "numberRange"
      "textCapture"
      "individual"
      "singleSearch"
      "oneArgument"
      "custom"
    ]
    @keys =
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
    @delayedEditFunctions = []
    @monitoringMouseToCancelSpacing = true

  initialize: ->
    @performCommandEdits()
    @initialized = true

  validate: (name, options) ->
    if typeof name is "object"
      _.each name, (options, name) ->
        @validate name, options
      return
    if options.rule?.match(/\(.*?\d+.*?\)/g)?
      console.error "Error in command creation: #{name}"
      console.error 'Please don\'t use integers in list names'

  enable: (name) ->
    @edit name, 'commandEnabled', (command) ->
      command.enabled = true
      command

  disable: (name) ->
    @edit name, 'commandDisabled', (command) ->
      command.enabled = false
      command

  create: (name, options) ->
    @validate name, options
    if typeof name is "string"
      options.enabled ?= false
      @mapping[name] = options
      if options.enabled is true
        @enable name
    else if typeof name is "object"
      _.extend @mapping, name
      for name, options in name
        options.enabled ?= false
        if options.enabled is true
          @enable name

  createWithDefaults: (defaults, options) ->
    for key, value of options
      command = _.extend {}, defaults, value
      command.enabled = true
      @create key, command

  createDisabled: (name, options) ->
    if typeof name is "string"
      options.enabled = false
      @create name, options
    else if typeof name is "object"
      for key, value of name
        value.enabled = false
        @create key, value

  createDisabledWithDefaults: (defaults, options) ->
    for key, value of options
      command = _.extend {}, defaults, value
      command.enabled = false
      @create key, command

  # queues all the command edits until sometime in the future, where they are all called at once
  edit: (name, editType, callback) ->
    @delayedEditFunctions.push {name, editType, callback}
    if @initialized
      @performCommandEdits()

  get: (name) ->
    @mapping[name]

  performCommandEdits: ->
    _.each @delayedEditFunctions, ({name, callback, editType}) =>
      command = @get name
      if command?
        result = callback command
        if not result?
          delete @mapping[name]
        else
          @mapping[name] = result
        Events.emit editType, name
      else
        console.error "#{editType} failed: '#{name}' was not found"
    @loadConditionalModules @delayedEditFunctions
    @delayedEditFunctions = []

  override: (name, action) ->
    console.error "Failed overriding '#{name}'. Commands.override is deprecated. Use Commands.extend"

  extend: (name, extension) ->
    @edit name, 'commandExtended', (command) ->
      command.extensions ?= []
      command.extensions.push extension
      command

  before: (name, extension) ->
    @edit name, 'commandBeforeAdded', (command) ->
      command.before ?= []
      command.before.push extension
      command

  after: (name, extension) ->
    @edit name, 'commandAfterAdded', (command) ->
      command.after ?= []
      command.after.push extension
      command

  addMisspellings: (name, misspellings) ->
    @edit name, 'commandMisspellingsAdded', (command) ->
      command.misspellings ?= []
      command.misspellings = command.misspellings.concat misspellings
      command

  addAliases: (name, aliases) ->
    console.error "Failed adding aliases to '#{name}'. 'addAliases' has been renamed to 'addMisspellings'. "

  changeName: (name, newName) ->
    @edit name, 'commandNameChanged', (command) =>
      @mapping[newName] = command
      null

  loadConditionalModules: (enabledCommands) ->
    for key, value of @mapping
      enabled = enabledCommands[key]
      @mapping[key].enabled = @mapping[key].enabled or enabled

      type = value.grammarType or "individual"

      if type in @primaryGrammarTypes
        @keys[type].push key
        unless value.continuous is false
          @keys[type + "Continuous"].push key

      if value.findable?
        @keys.findable.push key

      if value.repeater?
        @keys.repeater.push key

      if type is "custom"
        # try
        @mapping[key].grammar = new CustomGrammar(value.rule, value.variables)
        # catch e
        #   console.log "error parsing custom grammar for command: #{key}"
        #   console.log e

@Commands = new Commands
