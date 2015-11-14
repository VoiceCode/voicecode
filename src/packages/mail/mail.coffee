pack = Packages.register
  name: 'mail'
  description: 'Mail integration'
  triggerScopes: ['Mail']

pack.before
  'object.next': (input, context) ->
    @key 'down', 'command'
    @stop()
  'object.previous': (input, context) ->
    @key 'up', 'command'
    @stop()
