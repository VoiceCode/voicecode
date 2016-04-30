class Package
  constructor: (@options) ->
    # these are key for keeping track of this package's changes
    @_commands = {}
    @_actions = {}
    @_apis = {}
    @_before = {}
    @_after = {}
    @_implementations = {}
    @_settings = @options.settings or {}
    {@name, @description, @scope} = @options


    @registerScope()
    @setDefaultCommandOptions()
    @setDefaultEditOptions()

  api: (actions) ->
    @actions actions, 'api'

  actions: (actions, type = 'action') ->
    _.each actions, (value, name) =>
      if _.isFunction value
        method = value
      else
        method = value.action

      delete value.action
      @["_#{type}s"][name] = value
      if Actions[name]?
        warning 'packageOverwritesAction', name,
        "Package '#{@name}' has overwritten Actions.#{name}"
      Actions[name] = method.bind Actions
      emit "#{type}Created", {name, package: @name}
      true

  commands: ->
    if arguments[1]?
      defaults = arguments[0]
      commands = arguments[1]
    else
      defaults = {}
      commands = arguments[0]

    _.extend @_commands, commands
    _.each commands, (options, id) =>
      if _.isFunction options
        options = {action: options}
      @command id, _.defaultsDeep(options, defaults)

  command: (id, options) ->
    if options.action?
      funk = options.action
      delete options.action
    id = @normalizeId(id)
    commandOptions = _.defaultsDeep(options, @defaultCommandOptions)
    Commands.createDisabled id, commandOptions
    if funk?
      @implement _.pick(commandOptions, 'packageId', 'scope'), {"#{id}": funk}

  implement: ->
    if arguments[1]?
      packageOptions = _.defaultsDeep arguments[0], @defaultEditOptions
      commands = arguments[1]
    else
      packageOptions = @defaultEditOptions
      commands = arguments[0]

    _.extend @_implementations, commands

    implementCommands = =>
      _.each commands, (extension, id) =>
        Commands.implement @normalizeId(id), packageOptions, extension
    unless Commands.immediateEdits
      Events.once 'commandEditsPerformed', implementCommands
    else
      implementCommands()

  before: ->
    if arguments[1]?
      packageOptions = _.defaultsDeep arguments[0], @defaultEditOptions
      commands = arguments[1]
    else
      packageOptions = @defaultEditOptions
      commands = arguments[0]

    _.extend @_before, commands

    _.each commands, (extension, id) ->
      Commands.before id, packageOptions, extension

  after: ->
    if arguments[1]?
      packageOptions = _.defaultsDeep arguments[0], @defaultEditOptions
      commands = arguments[1]
    else
      packageOptions = @defaultEditOptions
      commands = arguments[0]

    _.extend @_after, commands

    _.each commands, (extension, id) ->
      Commands.after id, packageOptions, extension

  settings: (options) ->
    if options?
      _.merge @_settings, options
      Events.once 'packageReady', => _.merge Settings, @_settings
    else
      @_settings

  # called after user code has been evaluated
  # (so a user can change package settings that
  # this package's commands depend on)
  ready: (callback) ->
    # Events.once 'userAssetsLoaded', callback.bind(@)
    unless _.isFunction callback
      Events.once 'commandEditsPerformed', callback.bind(@)
    emit 'packageReady', @

  # the instance should automatically add its
  # package name at the beginning of all commands it creates
  normalizeId: (id) ->
    if id.indexOf(':') >= 0
      id
    else
      [@name, ':', id].join('')

  setDefaultCommandOptions: ->
    @defaultCommandOptions =
      packageId: @name
      tags: @options.tags
      notes: @options.notes

  setDefaultEditOptions: ->
    @defaultEditOptions =
      scope: @scope
      packageId: @name

  registerScope: ->
    if @options.applications? or @options.condition?
      Scope.register @options
      @scope = @name

  applications: ->
    if @scope?
      @_scope ?= Scope.get @scope
      @_scope?.applications()

  condition: ->
    if @scope?
      @_scope ?= Scope.get @scope
      @_scope?.condition
    else
      @options.condition

  remove: ->
    # TODO track commands that were added, and before/after-
    # basically all changes, and then undo them

    _.each @_commands, (options, id) =>
      Commands.remove @normalizeId(id)

    packageOptions = @defaultEditOptions

    _.each @_before, (extension, id) ->
      Commands.removeBefore id, packageOptions

    _.each @_after, (extension, id) ->
      Commands.removeAfter id, packageOptions

    # commit changes
    Commands.performCommandEdits()

    Packages.remove @name


module.exports = Package
