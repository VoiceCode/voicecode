CustomGrammar = require './parser/customGrammar'
class Commands
  instance = null
  history = {}
  constructor: ->
    return instance if instance?
    instance = @
    @mapping = {}
    @context = "global"
    @immediateEdits = false
    @primaryGrammarTypes = [
      "custom"
      "textCapture"
      "singleSearch"
      "integerCapture"
      "numberRange"
      "individual"
      "oneArgument"
      "commandCapture"
      "unconstrainedText"
    ]
    @keys =
      # main command types
      custom: []
      textCapture: []
      singleSearch: []
      integerCapture: []
      numberRange: []
      individual: []
      oneArgument: []
      commandCapture: []
      unconstrainedText: []
      # extra facets to keep track of
      repeater: []
      findable: []

    @findableLookup = {}
    @repeaterLookup = {}

    @delayedEditFunctions = []
    # Events.once 'startupFlow:corePackagesLoaded', => @initialize()
    @initialize()

  initialize: () ->
    Events.once 'userAssetsLoaded', =>
      @performCommandEdits 'userCode' # userCodeCommandEditsPerformed

    Events.once 'packageAssetsLoaded', =>
      @performCommandEdits 'userPackages' # userPackagesCommandEditsPerformed

    Events.on 'enableCommand', (commandId) => @enable commandId
    Events.on 'disableCommand', (commandId) => @disable commandId
    Events.on 'EnabledCommandsManagerSettingsProcessed', =>
      # enabledCommandsCommandEditsPerformed
      @performCommandEdits 'enabledCommands'
    Events.on 'startupComplete', =>
      @immediateEdits = true
      Events.on 'packageSettingsChanged', ({pack}) ->
        _.each pack._commands, (command, id) ->
          if command.grammar?
            {spoken, rule, variables} = command
            command.grammar = new CustomGrammar spoken, rule, variables
            emit 'customGrammarUpdated', command

  validate: (command, options, editType) ->
    validated = true
    if options?.description?
      options.description = _.map(options.description.split('. ')
      , (sentence) -> _.capitalize sentence).join('. ')

    switch editType
      when 'commandCreated'
        validated = @validate command, options, 'commandSpokenChanged'
        if options.rule?.match(/\(.*?\d+.*?\)/g)?
          error 'commandValidationError',
           command, 'Please don\'t use integers in list names'
          validated = false
      when 'commandMisspellingsAdded'
        if _.isEmpty _.difference options, command.misspellings
          validated = false
      # when 'commandBeforeAdded'
      # when 'commandAfterAdded'
      # when 'commandEnabled'
      #   if command.enabled is true
      #     validated = false
      when 'commandSpokenChanged'
        if _.find(Commands.mapping, {spoken: options})?
          warning 'commandSpokenOverwritten', command,
          "Command #{options}`s spoken parameter overwritten"

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
    @mapping[name] ?= {}
    alreadyEnabled = @mapping[name].enabled
    _.deepExtend @mapping[name], @normalizeOptions name, options
    emit 'commandCreated', @mapping[name], name
    if (alreadyEnabled or options.enabled) is true
      @enable name

  createWithDefaults: (defaults, options) ->
    _.each options, (value, key) =>
      command = _.extend {}, defaults, value
      command.enabled ?= true
      @create key, command

  createDisabled: (name, options) ->
    if typeof name is "object"
      _.each name, (value, key) =>
        @createDisabled key, value
      return
    options.enabled ?= false
    @create name, options

  createDisabledWithDefaults: (defaults, options) ->
    for key, value of options
      command = _.extend {}, defaults, value
      command.enabled ?= false
      @create key, command

  edit: (name, editType, edition, callback) ->
    @delayedEditFunctions.push {name, editType, edition, callback}
    if @immediateEdits
      @performCommandEdits 'immediate'

  remove: (name) ->
    # TODO what else needs to be done to clean up?
    @edit name, 'commandDisabled', null, (command) =>
      delete @mapping[name]

  removeBefore: (name, edition) ->
    # TODO

  removeAfter: (name, edition) ->
    # TODO

  get: (name) ->
    command = @mapping[name]
    unless command?
      debug 'commandNotFound', name
    command

  getEnabled: ->
    _.map (_.filter @mapping, {enabled: true}), 'id'

  enableAll: ->
    _.each @mapping, (command, name) =>
      @enable name
    @performCommandEdits('slaveModeEnableAllCommands') # TODO change name of this

  enableAllByTag: (tag) ->
    _.each @mapping, (command, name) =>
      if tag in (command.tags or [])
        @enable name
    @performCommandEdits('slaveModeEnableAllCommands') # TODO change name of this



  shouldEmitValidationFailed: (editType, command) ->
    return true

  performCommandEdits: (invokedBy = null) ->
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
          emit 'commandNotFound', {name, editType}
      return true
    emit "#{invokedBy}CommandEditsPerformed"
    emit 'commandEditsPerformed', invokedBy

  implement: (commandName, info, action) ->
    @edit commandName, 'implementationCreated', {info, action},
    (command) ->
      command.implementations ?= {}
      command.implementations["#{info.packageId}"] = {info, action}
      command

  before: (commandName, info, action) ->
    @edit commandName, 'commandBeforeAdded', {info, action}, (command) ->
      command.befores ?= {}
      command.befores["#{info.packageId}"] = {info, action}
      command

  after: (commandName, info, action) ->
    @edit commandName, 'commandAfterAdded', {info, action}, (command) ->
      command.afters ?= {}
      command.afters["#{info.packageId}"] = {info, action}
      command

  addMisspellings: (name, edition) ->
    @edit name, 'commandMisspellingsAdded', edition, (command) ->
      command.misspellings ?= []
      command.misspellings = command.misspellings.concat edition
      command

  changeSpoken: (name, newName) ->
    @edit name, 'commandSpokenChanged', newName, (command) ->
      command.spoken = newName
      command

  getFindable: (spoken) ->
    @findableLookup[spoken]

  getRepeater: (spoken) ->
    @repeaterLookup[spoken]

  normalizeOptions: (name, options) ->
    options.id = name
    options.grammarType ?= 'individual'
    options.kind ?= 'action'

    type = options.grammarType
    if type in @primaryGrammarTypes
      unless options.needsParsing is false
        unless name in @keys[type]
          @keys[type].push name

    if options.findable?
      @keys.findable.push name
      @findableLookup[options.id] = options.findable

    if options.repeater?
      @keys.repeater.push name
      @repeaterLookup[options.id] = options.repeater

    options

module.exports = new Commands
