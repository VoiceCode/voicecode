# this class simply encapsulates the concept of commands or command extensions only applying in certain
# scenarios such as when a certain application is active, or an arbitrary function evaluates to true

class Scope
  @instances = {}

  # applications: list of applications where this scope is valid
  # when: a function that returns true or false whether or not this scope is valid
  constructor: ({@name, @applications, @when}) ->

  @register: (options) ->
    if @instances[options.name]?
      warning 'scopeCollision', options, "scope: [#{options.name}] overridden by new values"
    @instances[options.name] = new Scope(options)

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
Scope.global = new Scope
  name: 'global'

# abstract scope is used for commands that are shared across multiple other scopes, but should not be global
# for example maybe 'selcrew'
Scope.abstract = new Scope
  name: 'abstract'


module.exports = Scope
