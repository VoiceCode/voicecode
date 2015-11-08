packageInfo =
  name: 'firefox'
  description: 'Firefox integration'
  triggerScopes: ['Firefox']

Commands.before 'object.forwards', packageInfo, (input, context) ->
  @key ']', 'command'
  @stop()

Commands.before 'object.backwards', packageInfo, (input, context) ->
  @key '[', 'command'
  @stop()

Commands.before 'object.refresh', packageInfo, (input, context) ->
  @key 'R', 'command'
  @stop()
