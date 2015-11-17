# this class simply encapsulates the concept of commands or command extensions only applying in certain
# scenarios such as when a certain application is active, or an arbitrary function evaluates to true

class Context
  @instances = {}

  # applications: list of applications where this context is valid
  # when: a function that returns true or false whether or not this context is valid
  constructor: ({@name, @applications, @when}) ->

  @register: (options) ->
    if @instances[options.name]?
      warning 'contextCollision', options, "context: [#{options.name}] overridden by new values"
    @instances[options.name] = new Context(options)

  @get: (name) ->
    @instances[name]

  @resetAll: ->
    @instances = {}

  active: ->
    @checkApplications() and @checkWhen()

  checkApplications: ->
    if @applications?
      Actions.currentApplication() in @applications
    else
      true
  checkWhen: ->
    if @when?
      @when.call(Actions)
    else
      true

# this is just for easy access to a global version
Context.global = new Context
  name: 'global'

# abstract context is used for commands that are shared across multiple other contexts, but should not be global
# for example maybe 'selcrew'
Context.abstract = new Context
  name: 'abstract'


module.exports = Context
