Function::property = (prop, desc) ->
  Object.defineProperty @prototype, prop, desc

class Commands
  history = {}
  constructor: ->
    # Events.on 'chainPreprocessed', (commands) => @history commands
    @mapping = {}
    @renamings = []
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

  initialize: () ->
    @performCommandEdits()
    @initialized = true
  @historyTypes: -> ['global']
  @property 'history',
    get: =>
      types = {}
      console.error @historyTypes
      _.each @historyTypes, (type) =>
        Object.defineProperty types, type,
          get: =>
            history[type]
          set: (commands) =>
            history[type] ?= []
            unless history is 'global'
              history[type] = []
            _.each commands, (command) ->
              history[type].push command
            history[type] = history[type][-10..]
      types

  getCurrentNameFor: (commandName) ->
    (_.pluck @renamings, {from: commandName})?.to || commandName

  validate: (name, options) ->
    if typeof name is "object"
      _.each name, (options, name) =>
        @validate name, options
      return
    if @mapping[name]?
      warning 'commandOverwritten', name, "Command #{name} overridden by command with a same name"
    if options.rule?.match(/\(.*?\d+.*?\)/g)?
      error 'commandValidationError', name, 'Please don\'t use integers in list names'

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
      options.namespace = name
      options.enabled ?= true
      options.grammarType ?= 'individual'
      options.kind ?= 'action'
      @mapping[name] = options
      if options.enabled is true
        @enable name
    else if typeof name is "object"
      _.each name, (options, name) =>
        @create name, options

  createWithDefaults: (defaults, options) ->
    _.each options, (value, key) =>
      command = _.extend {}, defaults, value
      command.enabled = true
      @create key, command

  createDisabled: (name, options) ->
    if typeof name is "string"
      options.enabled = false
      @create name, options
    else if typeof name is "object"
      _.each name, (value, key) =>
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
    isRenamed = _.findWhere @renamings, {from: name}
    if isRenamed?
      # log 'commandRenamedReference', isRenamed
      return @mapping[isRenamed.to]
    @mapping[name]


  performCommandEdits: ->
    _.each @delayedEditFunctions, ({name, callback, editType}) =>
      command = @get name
      if command?
        result = callback command

        isRenamed = _.findWhere @renamings, {from: name}
        if isRenamed?
          name = isRenamed.to

        if _.isObject result
          @mapping[name] = @prepareCommand name, result
        emit editType, !!result, name
      else
        emit editType, false, name
        emit 'commandNotFound', name
    @delayedEditFunctions = []

  override: (name, action) ->
    error 'deprecation', "Failed overriding '#{name}'. \n
    Commands.override is deprecated. Use Commands.extend"

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
      # if @renamings[name]? and @renamings[name] is newName
      if _.findWhere(@renamings, {to: newName})?
        # console.error "Won't rename #{name} #{newName} once more"
        return false
      if _.findWhere(@renamings, {to: name})?
        # renaming something that has already been renamed
        # removing previous renaming reference, allowing swapping command names
        warning 'commandOverwritten', name, "Command #{name} overridden by renaming twice"
        @renamings = _.reject @renamings, ({to}) -> to is name

      if @mapping[newName]?
        warning 'commandOverwritten', newName, "Command #{newName} overridden by renaming"

      command.namespace = newName
      command.misspellings = []
      @mapping[newName] = command
      @renamings.push {from: name, to: newName}
      delete @mapping[name]
      true

  prepareCommand: (name, command) ->
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

Meteor.methods
  "Commands.getMapping": (name) -> Commands.mapping
