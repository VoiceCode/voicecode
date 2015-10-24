class Commands
  constructor: ->
    @mapping = {}
    @renamings = {}
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
    if @mapping[name]?
      console.error "Overwritten '#{name}' command!"
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
    if typeof name is "string"
      @validate name, options
      # if @mapping[name]?
      #   console.error "Won't re-create command: #{name}"
      #   return false
      options.enabled ?= true
      options.grammarType ?= 'individual'
      options.kind ?= 'action'
      @mapping[name] = options
      if options.enabled is true
        @enable name
    else if typeof name is "object"
      for name, options in name
        @create name, options

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
    if @renamings[name]?
      console.error "Reference to a renamed command: #{name} => #{@renamings[name]}"
      return @mapping[@renamings[name]]
    @mapping[name]

  performCommandEdits: ->
    _.each @delayedEditFunctions, ({name, callback, editType}) =>
      command = @get name
      if command?
        result = callback command

        if @renamings[name]?
          name = @renamings[name]

        if _.isObject result
          @mapping[name] = @loadConditionalModules name, result
        Events.emit editType, name, !!result
      else
        console.error "#{editType} failed: '#{name}' was not found"
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
      command.misspellings = command.misspellings.concat _.difference misspellings, command.misspellings
      command

  addAliases: (name, aliases) ->
    console.error "Failed adding aliases to '#{name}'. 'addAliases' has been renamed to 'addMisspellings'. "

  changeName: (name, newName) ->
    @edit name, 'commandNameChanged', (command) =>
      # don't do anything if we have renamed like this already
      if @renamings[name]? and @renamings[name] is newName
        # console.error "Won't rename #{name} #{newName}"
        return false

      if @mapping[newName]?
        console.log "Overwritten '#{newName}' command by taking its name."

      @mapping[newName] = command
      @renamings[name] = newName
      delete @mapping[name]
      true

  loadConditionalModules: (name, command) ->
    type = command.grammarType
    if type in @primaryGrammarTypes
      unless name in @keys[type]
        @keys[type].push name
      unless command.continuous is false
        unless name in @keys[type + "Continuous"]
          @keys[type + "Continuous"].push name

    if command.findable?
      @keys.findable.push name

    if command.repeater?
      @keys.repeater.push name

    if command.rule?
      # try
      command.grammar = new CustomGrammar(command.rule, command.variables)
      # catch e
      #   console.log "error parsing custom grammar for command: #{key}"
      #   console.log e
    command
@Commands = new Commands
