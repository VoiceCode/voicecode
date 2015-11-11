packageInfo =
  name: 'Safari'
  description: 'Safari integration'
  triggerScopes: ['Safari']

Commands.before 'object.forwards', packageInfo, (input, context) ->
  @key ']', 'command'
  @stop()

Commands.before 'object.backwards', packageInfo, (input, context) ->
  @key '[', 'command'
  @stop()

Commands.before 'object.refresh', packageInfo, (input, context) ->
  @key 'R', 'command'
  @stop()

Commands.createDisabled
  'safari.show.tabs':
    spoken: 'show tabs'
    description: 'show all the tabs open in safari'
    tags: ['safari']
    triggerScopes: ['Safari']
    action: (input) ->
      @key '\\', 'command shift'
