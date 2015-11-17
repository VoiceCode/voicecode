Context.register
  name: 'iterm'
  applications: ['iTerm']

pack = Packages.register
  name: 'iterm'
  description: 'iTerm integration'
  context: 'iterm'
  tags: ['iterm']

pack.before
  'combo.copyUnderMouseAndInsertAtCursor': ->
    @rightClick()
    @rightClick()
    @paste()
    @stop()

pack.commands
  'change-to-directory-under-mouse':
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
  'execute-history-item-under-mouse':
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
  'open-with-editor':
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
