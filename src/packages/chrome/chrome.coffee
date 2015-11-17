Context.register
  name: 'chrome'
  applications: ['Chrome']

pack = Packages.register
  name: 'chrome'
  description: 'Google Chrome integration'
  context: 'chrome'

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
