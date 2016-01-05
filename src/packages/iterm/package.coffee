pack = Packages.register
  name: 'iterm'
  platforms: ['darwin']
  description: 'iTerm integration'
  applications: ['com.googlecode.iterm2']

Settings.extend "terminalApplications", pack.applications()
Settings.extend "editorApplications", pack.applications()

pack.implement
  'mouse-combo:insert-hovered': ->
    @rightClick()
    @rightClick()
    @paste()

pack.commands
  'change-to-hovered-directory':
    spoken: 'engage'
    description: 'hover your mouse over a directory name output from a "ls"
    command in the terminal, and this command will "cd" to that directory'
    tags: ['domain-specific', 'shell']
    continuous: false
    action: ->
      @rightClick()
      @delay 50
      @string 'cd '
      @paste()
      @string '; ls'
      @enter()
  'execute-hovered-history-item':
    spoken: 'shell recall'
    description: 'hovering the mouse over the left-hand number of a result
    from the history output, this will re-execute the command'
    tags: ['domain-specific', 'shell']
    continuous: false
    action: ->
      @rightClick()
      @delay 50
      @key '!'
      @paste()
      @enter()
  'open-hovered-with-editor':
    spoken: 'shell edit'
    description: 'open file in editor'
    tags: ['domain-specific', 'shell']
    continuous: false
    action: ->
      @rightClick()
      @delay 50
      @key '$EDITOR '
      @paste()
      @enter()
