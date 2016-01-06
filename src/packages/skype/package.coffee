pack = Packages.register
  name: 'skype'
  applications: ['com.skype.skype%']
  description: 'Skype integration'

pack.implement
  'object:next': ->
    @key 'right', 'command option'
  'object:previous': ->
    @key 'left', 'command option'
