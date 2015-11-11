packageInfo =
  name: 'iterm'
  description: 'iTerm integration'
  triggerScopes: ['iTerm']

Commands.after 'git.status', packageInfo, (input, context) ->
  @enter()

Commands.before 'combo.copyUnderMouseAndInsertAtCursor', packageInfo, (input, context) ->
  @rightClick()
  @rightClick()
  @paste()
  @stop()

Commands.before 'shell.directory.change.predefined', packageInfo, (input, context) ->
  if input?.length
    current = @currentApplication()
    directory = @fuzzyMatch Settings.directories, input.join(' ')
    if current is 'iTerm'
      @string "cd #{directory} ; ls \n"
      @stop()
    else if Settings.defaultTerminal is 'iTerm'
      @openApplication('iTerm')
      @newTab()
      @delay 200
      @string "cd #{directory} ; ls"
      @enter()
      @stop()
