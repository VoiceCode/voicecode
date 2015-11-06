packageInfo = {
  name: 'mail'
  description: 'Mail integration'
  triggerScopes: ['Mail']
}

Commands.before 'core.object.next', packageInfo, (index, context) ->
  switch @currentApplication()
    when 'Mail'
      @key 'down', 'command'
      @stop()

Commands.before 'core.object.previous', packageInfo, (index, context) ->
  switch @currentApplication()
    when 'Mail'
      @key 'up', 'command'
      @stop()
