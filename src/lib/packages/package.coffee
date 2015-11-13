class Package
  constructor: (@options) ->
    # these are key for keeping track of this package's changes
    @_commands = {}
    @_before = {}
    @_after = {}

    @settings = {}

    {@name, @description} = @options
    @setDefaultCommandOptions()

  commands: (commands) ->
    _.extend @_commands, commands
    packageOptions = @defaultCommandOptions
    _.each commands, (options, id) =>
      Commands.createDisabled @normalizeId(id), _.extend({}, packageOptions, options)

  before: (commands) ->
    _.extend @_before, commands
    packageOptions = @defaultCommandOptions
    _.each commands, (extension, id) ->
      Commands.before id, packageOptions, extension

  after: (commands) ->
    _.extend @_after, commands
    packageOptions = @defaultCommandOptions
    _.each commands, (extension, id) ->
      Commands.after id, packageOptions, extension

  # the instance should automatically add its package name at the beginning of all commands it creates
  normalizeId: (id) ->
    [@name, ':', id].join('')

  setDefaultCommandOptions: ->
    @defaultCommandOptions = _.pick @options, [
      'triggerScopes'
      'triggerScope'
      'when'
      'tags'
      'notes'
    ]
    @defaultCommandOptions.packageId = @name

  remove: ->
    # TODO track commands that were added, and before/after - basically all changes, and then undo them

    _.each @_commands, (options, id) =>
      Commands.remove @normalizeId(id)

    packageOptions = @defaultCommandOptions

    _.each @_before, (extension, id) =>
      Commands.removeBefore id, packageOptions

    _.each @_after, (extension, id) =>
      Commands.removeAfter id, packageOptions

    # commit changes
    Commands.performCommandEdits()

    Packages.remove @name


module.exports = Package
