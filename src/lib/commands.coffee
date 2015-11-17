CustomGrammar = require './parser/customGrammar'

class Commands
  instance = null
  history = {}
  constructor: ->
    return instance if instance?
    instance = @
    # Events.on 'chainPreprocessed', (commands) => @history commands
    @mapping = {}
    @renamings = []
    @context = "global"
    @initialized = false
    @commandEditsFrom = 'code'
    @conditionalModules = {}
    @lastIndividualCommand = null
    @lastFullCommand = null
    @subcommandIndex = 0
    @repetitionIndex = 0
    @currentUndoByDeletingCount = 0
    @aggregateUndoByDeletingCount = 0
    @previousUndoByDeletingCount = 0
    @primaryGrammarTypes = [
      "integerCapture"
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
      integerCapture: []
      integerCaptureContinuous: []
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
    @spokenToCommandLookupTable = {}
    Events.on 'commandNameChanged', (properties, name) =>
      target = null
      _.each @spokenToCommandLookupTable, (commandName, spoken) ->
        if commandName is name
          target = spoken
          return false
        return true
      if target?
        delete @spokenToCommandLookupTable[target]
      @spokenToCommandLookupTable[properties.spoken] = name

    Events.on 'commandEnabled', (command, name) =>
      @spokenToCommandLookupTable[command.spoken] = name


  initialize: () ->
    @performCommandEdits() # codeCommandEditsPerformed

    Events.on 'userAssetsLoaded', =>
      @commandEditsFrom = 'user'
      @performCommandEdits() # userCommandEditsPerformed

    Events.on 'enableCommand', (commandName) => @enable commandName
    Events.on 'disableCommand', (commandName) => @disable commandName
    Events.on 'EnabledCommandsManagerSettingsProcessed', =>
      @commandEditsFrom = 'settings'
      @performCommandEdits() # settingsCommandEditsPerformed

  validate: (command, options, editType) ->
    validated = true
    switch editType
      when 'commandCreated'
        validated = @validate command, options, 'commandNameChanged'
        if not options.spoken?
          unless options.needsParsing is false or options.rule?
            error 'commandValidationError', command,
            "Please provide a 'spoken' parameter for command '#{command}'"
            validated = false
        if @mapping[command]?
          if options.action?
            if options.action.toString() is @mapping[command].action.toString()
              validated = false # action is the same
              break
          else
            warning 'commandHasNoAction', command, "Command #{command} has no action."
          #   validated = false
          warning 'commandOverwritten', command,
          "Command '#{command}' overwritten by a command with a same name"
        if options.rule?.match(/\(.*?\d+.*?\)/g)?
          error 'commandValidationError', command, 'Please don\'t use integers in list names'
          validated = false
      when 'commandMisspellingsAdded'
        if _.isEmpty _.difference options, command.misspellings
          validated = false
      # when 'commandBeforeAdded'
      # when 'commandAfterAdded'
      when 'commandEnabled'
        if command.enabled is true
          validated = false
      when 'commandNameChanged'
        if _.findWhere(Commands.mapping, {spoken: options})?
          warning 'commandSpokenOverwritten', command,
          "Command #{options}`s spoken parameter overwritten by command with a same name"

    if not validated and @shouldEmitValidationFailed(editType, command)
      emit 'commandValidationFailed', {command, options, editType}

    return validated

  enable: (name) ->
    @edit name, 'commandEnabled', null, (command) ->
      command.enabled = true
      command

  disable: (name) ->
    @edit name, 'commandDisabled', null, (command) ->
      return false if command.enabled is false
      command.enabled = false
      command

  create: (name, options) ->
    if typeof name is "object"
      _.each name, (options, name) =>
        @create name, options
      return

    validated = @validate name, options, 'commandCreated'
    return if not validated
    @mapping[name] = @normalizeOptions name, options
    emit 'commandCreated', options, name
    if options.enabled is true
      @enable name

  createWithDefaults: (defaults, options) ->
    _.each options, (value, key) =>
      command = _.extend {}, defaults, value
      command.enabled = true
      @create key, command

  createDisabled: (name, options) ->
    if typeof name is "object"
      _.each name, (value, key) =>
        @create key, value
      return
    options.enabled = false
    @create name, options

  createDisabledWithDefaults: (defaults, options) ->
    for key, value of options
      command = _.extend {}, defaults, value
      command.enabled = false
      @create key, command

  edit: (name, editType, edition, callback) ->
    @delayedEditFunctions.push {name, editType, callback, edition}

  remove: (name) ->
    # TODO what else needs to be done to clean up?
    @edit name, 'commandDisabled', null, (command) =>
      delete @mapping[name]

  removeBefore: (name, edition) ->
    # TODO

  removeAfter: (name, edition) ->
    # TODO

  getBySpoken: (spoken) ->
    # @spokenToCommandLookupTable[spoken]
    _.findWhere @mapping, {spoken}

  get: (name) ->
    command = @mapping[name]
    # unless command?
      # error 'commandNotFound', name
    command

  getEnabled: ->
    _.pluck (_.where @mapping, {enabled: true}), 'id'

  shouldEmitValidationFailed: (editType, command) ->
    if editType is 'commandEnabled'
      return false
    return true

  performCommandEdits: (invokedBy = null) ->
    invokedBy ?= @commandEditsFrom
    delayedEditFunctions = _.clone @delayedEditFunctions
    @delayedEditFunctions = []
    _.each delayedEditFunctions, ({name, callback, editType, edition}) =>
      command = @get name
      if command?
        return if not @validate command, edition, editType
        try
          resultingCommand = callback command
        catch e
          debug {command, editType, edition, e}
          return true
        if _.isObject resultingCommand
          @mapping[name] = @normalizeOptions name, resultingCommand
        emit editType, resultingCommand, name
      else
        ###
          Allow addressing nonexistent commands while loading from settings
          as we are not fully initialized yet
          scenario: user has a package with createDisabled commands.
          user enabled some of them.
          EnabledCommandsManager tries to enableCommand a nonexistent(yet)
          command from the package. Next time we performCommandEdits,
          those commands will exist
        ###
        if @commandEditsFrom is 'settings'
          # let us try again in the next performCommandEdits()
          @edit name, editType, edition, callback
        else
          error 'commandNotFound', name, editType
      return true
    emit "#{invokedBy}CommandEditsPerformed"
    emit 'commandEditsPerformed', invokedBy


  override: (name, action) ->
    error 'deprecation', "Failed overriding '#{name}'.
    Commands.override is deprecated. Use Commands.extend"

  extend: (name, edition) ->
    warning 'deprecation', "Failed extending '#{name}'.
    Commands.extend is deprecated. Use Commands.before"
    @before name, edition

  before: (commandName, info, action) ->
    if _.isFunction info
      error 'commandValidationFailed', commandName,
      "Commands.before API changed.\n
      Please provide a unique identifier for your method as the second parameter: \n
      Commands.before '#{commandName}', 'my-#{commandName}-before', (input, context) -> doMagic()"
      return
    @edit commandName, 'commandBeforeAdded', {info, action}, (command) ->
      command.before ?= {}
      command.before["#{info.packageId}"] = {info, action}
      if command.context is 'abstract'
        command.applications = _.union(command.applications or [], info.applications)
      command

  after: (commandName, info, action) ->
    if _.isFunction info
      error 'commandValidationFailed', commandName,
      "Commands.after API changed.\n
      Please provide a unique identifier for your method as the second parameter: \n
      Commands.after '#{commandName}', 'my-#{commandName}-after', (input, context) -> doMagic()"
      return
    @edit commandName, 'commandAfterAdded', {info, action}, (command) ->
      command.after ?= {}
      command.after["#{info.packageId}"] = {info, action}
      if command.context is 'abstract'
        command.applications = _.union(command.applications or [], info.applications)
      command

  addMisspellings: (name, edition) ->
    @edit name, 'commandMisspellingsAdded', edition, (command) ->
      command.misspellings ?= []
      command.misspellings = command.misspellings.concat edition
      command

  addAliases: (name, aliases) ->
    error 'deprecation',
    "Failed adding aliases to '#{name}'.
    'addAliases' has been renamed to 'addMisspellings'. "

  changeName: (name, newName) ->
    @edit name, 'commandNameChanged', newName, (command) ->
      command.spoken = newName
      command

  normalizeOptions: (name, options) ->
    options.id = name
    options.enabled ?= true
    options.grammarType ?= 'individual'
    options.kind ?= 'action'

    unless options.spoken?
      options.spoken = options.id

    type = options.grammarType
    if type in @primaryGrammarTypes
      unless name in @keys[type]
        @keys[type].push name
      unless options.continuous is false
        unless name in @keys[type + "Continuous"]
          @keys[type + "Continuous"].push name

    if options.findable?
      @keys.findable.push name

    if options.repeater?
      @keys.repeater.push name

    if options.rule?
      # try
      options.grammar = new CustomGrammar(options.rule, options.variables)
      # catch e
      #   console.log "error parsing custom grammar for command: #{key}"
      #   console.log e
    options

module.exports = new Commands
