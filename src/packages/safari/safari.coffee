pack = Packages.register
  name: 'safari'
  description: 'Safari integration'
  triggerScopes: ['Safari']

pack.before
  'object.forwards': ->
    @key ']', 'command'
    @stop()
  'object.backwards': ->
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
