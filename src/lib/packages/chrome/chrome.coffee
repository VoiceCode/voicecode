packageInfo = {
  name: 'google.chrome'
  description: 'Google Chrome integration'
  triggerScopes: ['Google Chrome']
}

Commands.before 'object.refresh', packageInfo, (input, context) ->
  @key 'R', 'command'
  @stop()

Commands.before 'object.forwards', packageInfo, (input, context) ->
  @key ']', 'command'
  @stop()

Commands.before 'object.backwards', packageInfo, (input, context) ->
  @key '[', 'command'
  @stop()
