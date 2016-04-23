Package = require './package'

class Packages
  instance = null
  constructor: ->
    return instance if instance?
    instance = @
    @packages = {}
  register: (options) ->
    # validate the options
    # instantiate the package, add it to our internal list of packages
    # I'm sure we will think of more things to be done here
    return false unless @validatePackage options
    if @packages[options.name]?
      return @packages[options.name]

    instantiated = new Package options
    @packages[options.name] = instantiated
    log 'packageCreated', instantiated, "Package registered: #{options.name}"
    instantiated

  get: (name) ->
    @packages[name]

  resetAll: ->
    _.each @packages, (pack, name) ->
      pack.remove()
    @packages = {}

  validatePackage: (options) ->
    invalid = unless options.name?.length
      "Package [name] is required"
    else unless options.description?.length
      "Package [description] is required"

    warning = if @packages[options.name]?
      "Package with name [#{options.name}] is already registered"

    if warning?
      Events.warning 'packageValidationWarning', options, warning

    if invalid?
      error 'packageValidationError', options, invalid
      false
    else
      true

  remove: (name) ->
    delete @packages[name]



module.exports = new Packages
