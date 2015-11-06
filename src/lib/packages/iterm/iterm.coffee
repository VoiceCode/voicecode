packageInfo = {
  name: 'iterm'
  description: 'iTerm integration'
  triggerScopes: ['iTerm']
}

# RENAMING ALERT
# should this be an extension of core? will there ever be a core function implementation?
Commands.before 'core.combo.copyUnderMouseAndInsertAtCursor', packageInfo, (index, context) ->
  @rightClick()
  @rightClick()
  @paste()
  @stop()
