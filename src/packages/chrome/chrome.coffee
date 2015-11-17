Scope.register
  name: 'chrome'
  applications: ['Chrome']

pack = Packages.register
  name: 'chrome'
  description: 'Google Chrome integration'
  scope: 'chrome'

pack.before
  'object.refresh': ->
    @key 'R', 'command'
    @stop()
  'object.forward': ->
    @key ']', 'command'
    @stop()
  'object.backward': ->
    @key '[', 'command'
    @stop()
