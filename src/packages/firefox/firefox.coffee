pack = Packages.register
  name: 'firefox'
  description: 'Firefox integration'
  triggerScopes: ['Firefox']

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
