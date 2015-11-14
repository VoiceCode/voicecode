pack = Packages.register
  name: 'iterm'
  description: 'iTerm integration'
  triggerScopes: ['iTerm']
  tags: ['iterm']


pack.after
  'git.status': (input, context) ->
    @enter()

pack.before
  'combo.copyUnderMouseAndInsertAtCursor': (input, context) ->
    @rightClick()
    @rightClick()
    @paste()
    @stop()
 'shell.directory.change.predefined': (input, context) ->
   # TODO figure out how to handle 'before' functions that are global like this
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
