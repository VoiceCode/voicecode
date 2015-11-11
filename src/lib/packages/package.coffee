class Package
  constructor: (@options) ->
    {@name, @description} =  @options
    @setDefaultCommandOptions()

  commands: (commands) ->
    packageOptions = @defaultCommandOptions
    _.each commands, (options, id) ->
      Commands.createDisabled @normalizeId(id), _.extend({}, packageOptions, options)

  before: (options) ->
    packageOptions = @defaultCommandOptions
    _.each commands, (extension, id) ->
      Commands.before id, packageOptions, extension

  after: (commands) ->
    packageOptions = @defaultCommandOptions
    _.each commands, (extension, id) ->
      Commands.after id, packageOptions, extension

  # the instance should automatically add its package name at the beginning of all commands it creates
  @normalizeId: (id) ->
    [@name, ':', id].join('')

  @setDefaultCommandOptions: ->
    @defaultCommandOptions = _.pick @options, [
      'triggerScopes'
      'triggerScope'
      'when'
      'tags'
      'notes'
    ]
    @defaultCommandOptions.package = @name


module.exports = Package
