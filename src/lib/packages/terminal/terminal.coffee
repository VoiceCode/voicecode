packageInfo =
  name: 'terminal'
  description: 'Terminal integration'
  triggerScopes: ['Terminal']

Commands.before 'git.status', packageInfo, (input, context) ->
  @enter()

Commands.before 'shell.directory.change.predefined', packageInfo, (input, context) ->
  if input?.length
    current = @currentApplication()
    directory = @fuzzyMatch Settings.directories, input.join(' ')
    if current is 'Terminal'
      @string "cd #{directory} ; ls \n"
      @stop()
    else if Settings.defaultTerminal is 'Terminal'
      @openApplication('Terminal')
      @newTab()
      @delay 200
      @string "cd #{directory} ; ls"
      @enter()
      @stop()
