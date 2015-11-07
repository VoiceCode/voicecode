packageInfo = {
  name: 'iterm'
  description: 'iTerm integration'
  triggerScopes: ['iTerm']
}

Commands.after 'git.status', packageInfo, (input, context) ->
  @enter()

Commands.before 'combo.copyUnderMouseAndInsertAtCursor', packageInfo, (input, context) ->
  @rightClick()
  @rightClick()
  @paste()
  @stop()
