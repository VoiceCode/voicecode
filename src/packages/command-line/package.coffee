pack = Packages.register
  name: 'command-line'
  description: 'General commands for shell / console usage'
  applications: -> Settings.terminalApplications

# TODO pack.ready here should not be necessary. It is currently necessary because the git module is loaded
# AFTER user settings, so this needs to be loaded afterwards as well because it's extending a command that might not exist yet
pack.ready ->
  @after
    'git:status': ->
      @enter()

pack.commands
  'change-directory':
    spoken: 'cd'
    description: 'change directory'
    continuous: false
    action: ->
      @string 'cd ; ls'
      @left 4

  'list-directories':
    spoken: 'shell list'
    grammarType: 'textCapture'
    description: 'list directory contents (takes dynamic arguments)'
    continuous: false
    action: (input) ->
      options = _.map((input or []), (item) ->
        " -#{item}"
      ).join(" ")
      @string "ls #{options}"
      @enter()

  'display-history':
    spoken: 'shell history'
    grammarType: 'integerCapture'
    description: 'display the last [n](default all) shell commands executed'
    continuous: false
    action: (input) ->
      @string "history #{input or ''}"
      @enter()

  'parent-directory':
    spoken: 'durrup'
    description: 'navigate to the parent directory'
    action: ->
      @string 'cd ..; ls'
      @enter()

# global
pack.commands
  scope: 'global'
,
  'open-directory':
    spoken: 'direct'
    grammarType: 'textCapture'
    description: 'changes directory to any directory in the predefined list'
    continuous: false
    inputRequired: true
    action: (input) ->
      if input?.length
        current = @currentApplication()
        directory = @fuzzyMatch Settings.directories, input.join(' ')
        if @inTerminal()
          @string "cd #{directory} ; ls \n"
        else
          @openDefaultTerminal()
          @newTab()
          @delay 200
          @string "cd #{directory} ; ls"
          @enter()

  'insert-common-command':
    spoken: 'shell'
    grammarType: 'custom'
    rule: '<spoken> (shellcommand)'
    description: 'insert a shell command from the predefined shell commands list'
    tags: ['text']
    misspellings: ['shall', 'chell']
    variables:
      shellcommand: -> _.keys Settings.shellCommands
    continuous: false
    inputRequired: true
    action: ({shellcommand}) ->
      text = @fuzzyMatch Settings.shellCommands, shellcommand
      @string text
