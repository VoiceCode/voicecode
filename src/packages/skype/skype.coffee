pack = Packages.register
  name: 'skype'
  description: 'Skype integration'
  triggerScopes: ['Skype']

pack.before
  'object.next': ->
    @key 'right', 'command option'
    @stop()
  'object.previous': ->
    @key 'left', 'command option'
    @stop()
