packageInfo = {
  name: 'mail'
  description: 'Mail integration'
  triggerScopes: ['Mail']
}

Commands.before 'object.next', packageInfo, (input, context) ->
  @key 'down', 'command'
  @stop()

Commands.before 'object.previous', packageInfo, (input, context) ->
  @key 'up', 'command'
  @stop()
