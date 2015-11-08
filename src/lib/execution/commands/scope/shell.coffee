Commands.createDisabled
  'shell.cd':
    spoken: 'cd'
    description: 'change directory'
    tags: ['domain-specific', 'shell']
    triggerScopes: ['iTerm', 'Terminal']
    continuous: false
    action: ->
      @string 'cd ; ls'
      @left 4
  'shell.enter-folder-under-mouse':
    spoken: 'engage'
    description: 'hover your mouse over a directory name output from a "ls" command in the terminal, and this command will "cd" to that directory'
    tags: ['domain-specific', 'shell']
    triggerScope: 'iTerm'
    continuous: false
    action: ->
      @rightClick()
      @delay 50
      @string 'cd '
      @paste()
      @string '; ls'
      @enter()
  'shell.ls':
    spoken: 'shell list'
    grammarType: 'textCapture'
    description: 'list directory contents (takes dynamic arguments)'
    tags: ['domain-specific', 'shell']
    triggerScopes: ['iTerm', 'Terminal']
    continuous: false
    inputRequired: false
    action: (input) ->
      options = _.map((input or []), (item) ->
        " -#{item}"
      ).join(" ")
      @string "ls #{options}"
      @enter()

  'shell.history.display':
    spoken: 'shell history'
    grammarType: 'numberCapture'
    description: 'display the last [n](default all) shell commands executed'
    tags: ['domain-specific', 'shell']
    triggerScopes: ['iTerm', 'Terminal']
    continuous: false
    inputRequired: false
    action: (input) ->
      @string "history #{input or ''}"
      @enter()
  'shell.history.execute-item-under-mouse':
    spoken: 'shell recall'
    description: 'hovering the mouse over the left-hand number of a result from the history output, this will re-execute the command'
    tags: ['domain-specific', 'shell']
    triggerScope: 'iTerm'
    continuous: false
    action: ->
      @rightClick()
      @delay 50
      @key '!'
      @paste()
      @enter()
  'shell.edit-file-under-mouse':
    spoken: 'shell edit'
    description: 'open file in editor'
    tags: ['domain-specific', 'shell']
    triggerScope: 'iTerm'
    continuous: false
    action: ->
      @rightClick()
      @delay 50
      @key '$EDITOR '
      @paste()
      @enter()
  'shell.navigation.parent-directory':
    spoken: 'durrup'
    description: 'navigate to the parent directory'
    tags: ['domain-specific', 'shell']
    triggerScopes: ['iTerm', 'Terminal']
    action: ->
      @string 'cd ..; ls'
      @enter()
  'shell.global.open-directory':
    spoken: 'direct'
    grammarType: 'textCapture'
    description: 'changes directory to any directory in the predefined list'
    tags: ['text', 'domain-specific', 'shell']
    continuous: false
    inputRequired: true
    action: (input) ->
      if input?.length
        current = @currentApplication()
        directory = @fuzzyMatch Settings.directories, input.join(' ')
        if current is 'iTerm' or current is 'Terminal'
          @string "cd #{directory} ; ls \n"
        else
          @openApplication('iTerm')
          @newTab()
          @delay 200
          @string "cd #{directory} ; ls"
          @enter()
  'shell.insert-common-command':
    spoken: 'shell'
    grammarType: 'custom'
    description: 'insert a shell command from the predefined shell commands list'
    tags: ['text', 'shell']
    misspellings: ['shall', 'chell']
    rule: '<name> (shellcommands)'
    triggerScopes: ['iTerm', 'Terminal']
    variables:
      shellcommands: -> _.keys Settings.shellCommands
    continuous: false
    inputRequired: true
    action: ({shellcommands}) ->
      text = @fuzzyMatch Settings.shellCommands, shellcommands
      @string text
