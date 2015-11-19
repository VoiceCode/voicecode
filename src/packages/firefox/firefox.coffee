Settings.browserApplications.push 'Firefox'
me =
  name: 'firefox'
  applications: ['Firefox']
  description: 'Firefox integration'
  scope: 'firefox'

Scope.register me
pack = Packages.register me
pack.before
  'object.forward': (input, context) ->
    @key ']', 'command'
    @stop()
  'object.backward': (input, context) ->
    @key '[', 'command'
    @stop()
  'object.refresh': (input, context) ->
    @key 'R', 'command'
    @stop()
