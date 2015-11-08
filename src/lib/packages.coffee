class Packages
  instance = null
  constructor: ->
    return instance if instance?
    instance = @
    @packages = {}
  create: (options) ->
    # validate the options
    # instantiate the package, add it to our internal list of packages
    # I'm sure we will think of more things to be done here
    instantiated = new Package options
    @packages[options.name] = instantiated
    instantiated

module.exports = new Packages
