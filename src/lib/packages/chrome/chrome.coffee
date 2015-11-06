packageInfo = {
  name: 'google.chrome'
  description: 'Google Chrome integration'
  triggerScopes: ['Google Chrome']
}

Commands.before 'core.object.refresh', packageInfo, (index, context) ->
  @key 'R', 'command'
  @stop()

Commands.before 'core.object.forwards', packageInfo, (index, context) ->
  @key ']', 'command'
  @stop()

Commands.before 'core.object.backwards', packageInfo, (index, context) ->
  @key '[', 'command'
  @stop()
