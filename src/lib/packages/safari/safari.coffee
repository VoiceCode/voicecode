packageInfo = {
  name: 'Safari'
  description: 'Safari integration'
  triggerScopes: ['Safari']
}

Commands.before 'core.object.forwards', packageInfo, (index, context) ->
  @key ']', 'command'
  @stop()

Commands.before 'core.object.backwards', packageInfo, (index, context) ->
  @key '[', 'command'
  @stop()

Commands.before 'core.object.refresh', packageInfo, (index, context) ->
  @key 'R', 'command'
  @stop()
