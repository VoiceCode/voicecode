packageInfo =
  name: 'skype'
  description: 'Skype integration'
  triggerScopes: ['Skype']

Commands.before 'object.next', packageInfo, (input, context) ->
  @key 'right', 'command option'
  @stop()

Commands.before 'object.previous', packageInfo, (input, context) ->
  @key 'left', 'command option'
  @stop()
