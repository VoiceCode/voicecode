Context.register
  name: 'safari'
  applications: ['Safari']

pack = Packages.register
  name: 'safari'
  description: 'Safari integration'
  context: 'safari'

pack.before
  'object.forward': ->
    @key ']', 'command'
    @stop()
  'object.backward': ->
    @key '[', 'command'
    @stop()
  'object.refresh': ->
    @key 'R', 'command'
    @stop()

pack.commands
  'show-tabs':
    spoken: 'show tabs'
    description: 'show all the tabs open in safari'
    action: (input) ->
      @key '\\', 'command shift'
