Package = require './package'
semver = require 'semver'

class Packages
  instance = null
  constructor: ->
    return instance if instance?
    instance = @
    @packages = {}
    Events.on 'commandCreated', (command, name) =>
      @get(command.packageId)._commands[name] = command
    # Events.on 'packageRemoved', (name) =>
    #   @remove name
    Events.on 'packageRepoStatusUpdated'
    , ({repoName, status}) =>
      if pack = @get(repoName)
        pack.options.repoStatus = status
        # emit 'packageUpdated', {pack}
    Events.on 'packageRepoLogUpdated'
    , ({repoName, log}) =>
      if pack = @get(repoName)
        pack.options.repoLog = log
        # emit 'packageUpdated', {pack}

  register: (options) ->
    options.installed ?= true
    # validate the options
    # instantiate the package, add it to our internal list of packages
    # I'm sure we will think of more things to be done here
    return false unless @validatePackage options

    # only flies while we develop...
    # otherwise need 2 cleanup and re-instantiate
    if @packages[options.name]?
      emit 'packageCreated', {pack: @packages[options.name]}
      return @packages[options.name]
    options = mutate 'willCreatePackage', options
    instantiated = new Package options
    @packages[options.name] = instantiated
    emit 'packageCreated', {pack: instantiated}
    unless options.name is global.platform
      Events.once "assetEvaluated", =>
        unless instantiated.hasDeferred
          @emitReady instantiated
    else
      @emitReady instantiated
    instantiated

  emitReady: (instantiated) ->
    emit "#{instantiated.name}PackageReady"
    , {pack: instantiated}
    emit 'packageReady', {pack: instantiated}
    , "Package ready: #{instantiated.name}"

  await: (packageName, callback) ->
    if pack = @get packageName
      callback {pack}
    else
      Events.once "#{packageName}PackageReady", callback

  get: (name) ->
    @packages[name]

  resetAll: ->
    _.each @packages, (pack, name) ->
      pack.remove()
    @packages = {}

  validatePackage: (options) ->
    invalid = []
    unless options.name?.length
      invalid.push "Package [name] is required"

    warning = []
    if @packages[options.name]?
      warning.push "Package with name [#{options.name}] is already registered"
    unless options.description?.length
      warning.push "Package [description] is a sign of good manners"
      options.description = 'Even the author of this package
       is unsure of what it does.'

    _.every warning, (w) ->
      Events.warning 'packageValidationWarning', options, w
      true

    if invalid.length
      error 'packageValidationError', options, invalid.join('\n')
      false
    else
      true

  remove: (name) ->
    # TODO: fix
    delete @packages[name]

module.exports = new Packages
