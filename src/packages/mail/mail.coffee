Scope.register
  name: 'mail'
  applications: ['Mail']

pack = Packages.register
  name: 'mail'
  description: 'Apple Mail integration'
  scope: 'mail'

pack.before
  'object.next': ->
    @key 'down', 'command'
    @stop()
  'object.previous': ->
    @key 'up', 'command'
    @stop()
