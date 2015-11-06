packageInfo = {
  name: 'skype'
  description: 'Skype integration'
  triggerScopes: ['Skype']
}

Commands.before 'core.object.next', packageInfo, (index, context) ->
  switch @currentApplication()
    when 'Skype'
      @key 'right', 'command option'
      @stop()

Commands.before 'core.object.previous', packageInfo, (index, context) ->
  switch @currentApplication()
    when 'Skype'
      @key 'left', 'command option'
      @stop()
