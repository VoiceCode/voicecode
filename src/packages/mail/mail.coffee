pack = Packages.register
  name: 'mail'
  platforms: ['darwin']
  applications: ['com.apple.mail']
  description: 'Apple Mail integration'
  createScope: true

pack.before
  'object.next': ->
    @key 'down', 'command'
  'object.previous': ->
    @key 'up', 'command'
