Context.register
  name: 'firefox'
  applications: ['Firefox']

pack = Packages.register
  name: 'firefox'
  description: 'Firefox integration'
  context: 'firefox'

pack.before
  'object.forwards': (input, context) ->
    @key ']', 'command'
    @stop()
  'object.backwards': (input, context) ->
    @key '[', 'command'
    @stop()
  'object.refresh': (input, context) ->
    @key 'R', 'command'
    @stop()
