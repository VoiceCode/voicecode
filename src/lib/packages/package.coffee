class Package
  constructor: (@options) ->
    # these are key for keeping track of this package's changes
    @_commands = {}
    @_before = {}
    @_after = {}

    @_settings = @options.settings or {}

    {@name, @description, @scope} = @options
    @setDefaultCommandOptions()
    @setDefaultEditOptions()

  commands: () ->
    if arguments[1]?
      defaults = arguments[0]
      commands = arguments[1]
    else
      defaults = {}
      commands = arguments[0]

    _.extend @_commands, commands
    packageOptions = @defaultCommandOptions
    _.each commands, (options, id) =>
      Commands.createDisabled @normalizeId(id), _.extend({}, packageOptions, defaults, options)

  command: (id, options) ->
    Commands.createDisabled @normalizeId(id), _.extend({}, @defaultCommandOptions, options)

  before: () ->
    if arguments[1]?
      scope = arguments[0]
      commands = arguments[1]
    else
      scope = @scope
      commands = arguments[0]

    _.extend @_before, commands

    packageOptions = @defaultEditOptions
    _.each commands, (extension, id) ->
      Commands.before id, packageOptions, extension

  after: () ->
    if arguments[1]?
      scope = arguments[0]
      commands = arguments[1]
    else
      scope = @scope
      commands = arguments[0]

    _.extend @_after, commands

    packageOptions = @defaultEditOptions
    _.each commands, (extension, id) ->
      Commands.after id, packageOptions, extension

  settings: (options) ->
    if options?
      _.extend @_settings, options
    else
      @_settings

  # called after user code has been evaluated (so a user can change package settings that this package's commands depend on)
  ready: (callback) ->
    Events.once 'userAssetsLoaded', callback.bind(@)

  # the instance should automatically add its package name at the beginning of all commands it creates
  normalizeId: (id) ->
    [@name, ':', id].join('')

  setDefaultCommandOptions: ->
    @defaultCommandOptions = _.pick @options, [
      'scope'
      'tags'
      'notes'
    ]
    @defaultCommandOptions.packageId = @name
    @defaultCommandOptions.applications = @applications()

  setDefaultEditOptions: ->
    @defaultEditOptions = _.pick @options, [
      'scope'
    ]
    @defaultEditOptions.packageId = @name
    @defaultEditOptions.applications = @applications()

  applications: ->
    @_scope ?= Scope.get @scope
    @_scope?.applications or []

  remove: ->
    # TODO track commands that were added, and before/after - basically all changes, and then undo them

    _.each @_commands, (options, id) =>
      Commands.remove @normalizeId(id)

    packageOptions = @defaultEditOptions

    _.each @_before, (extension, id) =>
      Commands.removeBefore id, packageOptions

    _.each @_after, (extension, id) =>
      Commands.removeAfter id, packageOptions

    # commit changes
    Commands.performCommandEdits()

    Packages.remove @name


module.exports = Package
