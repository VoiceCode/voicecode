packageInfo = {
  name: 'Safari'
  description: 'Safari integration'
  triggerScopes: ['Safari']
}

Commands.before 'object.forwards', packageInfo, (input, context) ->
  @key ']', 'command'
  @stop()

Commands.before 'object.backwards', packageInfo, (input, context) ->
  @key '[', 'command'
  @stop()

Commands.before 'object.refresh', packageInfo, (input, context) ->
  @key 'R', 'command'
  @stop()
