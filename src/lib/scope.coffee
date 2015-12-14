# this class simply encapsulates the concept of commands or command extensions only applying in certain
# scenarios such as when a certain application is active, or an arbitrary function evaluates to true

class Scope
  @instances = {}

  # applications: list of applications where this scope is valid
  # condition: a function that returns true or false whether or not this scope is valid
  constructor: ({@name, applications, @condition}) ->
    @_applications = applications

  @register: (options) ->
    if @instances[options.name]?
      warning 'scopeCollision', options, "scope: [#{options.name}] overridden by new values"
    @instances[options.name] = new Scope(options)

  @get: (name) ->
    @instances[name]

  @resetAll: ->
    @instances = {}

  @active: (options) ->
    if typeof options is 'string'
      @get(options)?.active()
    else if options.scope?
      @get(options.scope)?.active()
    else
      @checkApplications(options.applications) and
      @checkCondition(options.condition)

  active: ->
    Scope.active
      applications: @applications()
      condition: @condition

  # allow lazy resolving of an application list
  applications: ->
    if _.isFunction @_applications
      @_applications() or []
    else
      @_applications or []

  @applications: (scope) ->
    @get(scope)?.applications() or []

  @checkApplications: (applications) ->
    apps = if applications?
      if _.isFunction applications
        applications()
      else
        applications
    if apps?
      switch global.platform
        when 'darwin'
          Actions.currentApplication().bundleId in apps
        # windows, linux
    else
      true

  @checkCondition: (condition) ->
    if condition?
      condition.call(Actions)
    else
      true

# this is just for easy access to a global version
Scope.global = Scope.register
  name: 'global'

# abstract scope is used for commands that are shared across multiple other scopes, but should not be global
# for example maybe 'selcrew'
Scope.abstract = Scope.register
  name: 'abstract'


module.exports = Scope
