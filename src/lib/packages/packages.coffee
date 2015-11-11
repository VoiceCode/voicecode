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
    return unless @validatePackage options

    instantiated = new Package options
    @packages[options.name] = instantiated
    instantiated

  get: (name) ->
    @packages[name]

  validatePackage: (options) ->
    invalid = unless options.name?.length
      "[name] is required"
    else unless options.description?.length
      "[description] is required"
    else if @packages[options.name]?
      "package with name [#{options.name}] is already taken"

    if invalid?
      error 'packageValidationError', options, invalid
      false
    else
      true


module.exports = new Packages
