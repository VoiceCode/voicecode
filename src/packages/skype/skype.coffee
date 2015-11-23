pack = Packages.register
  name: 'skype'
  applications: ['com.skype.skype%']
  description: 'Skype integration'
  scope: 'skype'

pack.before
  'object.next': ->
    @key 'right', 'command option'
    @stop()
  'object.previous': ->
    @key 'left', 'command option'
    @stop()
