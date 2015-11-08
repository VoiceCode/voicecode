class Package
  constructor: (@options) ->
    {@name, @description} =  @options
    @setDefaultCommandOptions()

  createCommands: (commands) ->
    packageOptions = @defaultCommandOptions
    _.each commands, (options, id) ->2
      Commands.createDisabled @normalizeId(id), _.extend({}, packageOptions, options)

  beforeCommands: (options) ->
  afterCommands: (options) ->

  @normalizeId: (id) ->
    [@name, ':', id].join('')

  @setDefaultCommandOptions: ->
    @defaultCommandOptions = _.pick @options, [
      'triggerScopes'
      'when'
      'tags'
    ]
    @defaultCommandOptions.package = @name


module.exports = Package
