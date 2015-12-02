pack = Packages.register
  name: 'mac-mail'
  platforms: ['darwin']
  applications: ['com.apple.mail']
  description: 'Apple Mail integration'

pack.before
  'object.next': ->
    @key 'down', 'command'
  'object.previous': ->
    @key 'up', 'command'
