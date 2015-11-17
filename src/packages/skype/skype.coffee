Context.register
  name: 'skype'
  applications: ['Skype']

pack = Packages.register
  name: 'skype'
  description: 'Skype integration'
  context: 'skype'

pack.before
  'object.next': ->
    @key 'right', 'command option'
    @stop()
  'object.previous': ->
    @key 'left', 'command option'
    @stop()
