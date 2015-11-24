pack = Packages.register
  name: 'mail'
  applications: ['com.apple.mail']
  description: 'Apple Mail integration'
  createScope: true

pack.before
  'object.next': ->
    @key 'down', 'command'
    @stop()
  'object.previous': ->
    @key 'up', 'command'
    @stop()
