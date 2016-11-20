class Package
  constructor: (options) ->
    @options = mutationNotifier options
    , 'packageUpdated', {pack: @}, true
    @name = @options.name
    # these are key for keeping track of this package's changes
    @_commands = {}
    @_actions = {}
    @_apis = {}
    @_before = {}
    @_after = {}
    @_implementations = {}
    @_settings = mutationNotifier (@options.settings or {})
    , 'packageSettingsChanged', {pack: @}, true
    if @options.installed
      @registerScope()
      @setDefaultCommandOptions()
      @setDefaultEditOptions()

  api: (actions) ->
    @actions actions, 'api'

  actions: (actions, type = 'action') ->
    _.each actions, (value, name) =>
      if _.isFunction value
        method = value
        value = {}
      else
        method = value.action
        delete value.action
      value.name = name
      @["_#{type}s"][name] = value
      if Actions[name]?
        warning 'packageOverwritesAction', name,
        "Package '#{@name}' has overwritten Actions.#{name}"
      Actions[name] = method.bind Actions
      emit "#{type}Created", {packageId: @name, "#{type}": value}
      true

  commands: ->
    if arguments[1]?
      defaults = arguments[0]
      commands = arguments[1]
    else
      defaults = {}
      commands = arguments[0]

    _.each commands, (options, id) =>
      if _.isFunction options
        options = {action: options}
      @command id, _.defaultsDeep(options, defaults, @defaultCommandOptions)

  command: (id, options) ->
    if options.action?
      funk = options.action
      delete options.action
    id = @normalizeId(id)
    commandOptions = _.defaultsDeep options, @defaultCommandOptions
    packageOptions = _.defaultsDeep options, @defaultEditOptions
    Commands.create id, commandOptions
    if funk?
      @implement packageOptions, {"#{id}": funk}

  implement: ->
    if arguments[1]?
      packageOptions = _.defaultsDeep arguments[0], @defaultEditOptions
      commands = arguments[1]
    else
      packageOptions = @defaultEditOptions
      commands = arguments[0]

    _.extend @_implementations, commands

    _.each commands, (extension, id) =>
      Commands.implement @normalizeId(id), packageOptions, extension

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
      if _.isFunction options
        do options.bind @
      else
        _.deepExtend @_settings, options
      @_settings
    else
      @_settings

  # called after user code has been evaluated
  # (so a user can change package settings that
  # this package's commands depend on)
  defer: (callback) ->
    @hasDeferred = true
    Events.once 'userAssetsLoaded', =>
      do callback.bind @
      emit "#{@name}PackageReady", {pack: @}
      emit 'packageReady', {pack: @}, "Package ready: #{@name}"

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
      scope: @options.scope
      packageId: @name

  registerScope: ->
    if @shouldCreateScope()
      Scope.register @options
      @options.scope = @name
    else
      @options.scope ?= 'global'

  shouldCreateScope: ->
    # if it uses a scope already declared return false
    return false if @options.scope

    @options.applications? or
    @options.conditions? or
    @options.application? or
    @options.condition

  active: ->
    Scope.active @options.scope

  applications: ->
    Scope.get(@options.scope).applications()

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
