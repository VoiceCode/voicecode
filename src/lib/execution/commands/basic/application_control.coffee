Commands.createDisabled
  'applicationControl.switchToPrevious':
    spoken: 'swick'
    description: 'Switch to most recent application'
    tags: ['application', 'tab', 'recommended']
    action: ->
      @switchApplication()
      @delay(250)
  'applicationControl.openLauncher':
    spoken: 'launcher'
    description: 'open application launcher'
    tags: ['application', 'system', 'launching', 'alfred']
    action: ->
      @key 'space', 'option'
      @delay 100
  'applicationControl.openSearch':
    spoken: 'spotty'
    description: 'open spotlight'
    tags: ['application', 'system', 'launching']
    action: ->
      @key ' ', 'command'
      @delay 100
  'applicationControl.openApplicationSwitcher':
    spoken: 'foxwitch'
    description: 'open application switcher'
    tags: ['application', 'system', 'launching', 'tab', 'recommended']
    action: ->
      @keyDown 'command', 'command'
      @keyDown 'tab', 'command'
      @keyUp 'tab', 'command'
      @delay 10000
      @keyUp 'tab', 'command'
      @keyUp 'command'
  'applicationControl.openBrowser':
    spoken: 'webseek'
    description: 'open a new browser tab (from anywhere)'
    tags: ['system', 'launching', 'recommended']
    action: ->
      @openBrowser()
      @newTab()
      @delay 200
  'applicationControl.openApplication':
    spoken: 'fox'
    description: 'open application'
    tags: ['application', 'system', 'launching', 'recommended']
    grammarType: 'custom'
    rule: '<name> (applications)'
    variables:
      applications: -> Settings.applications
    action: ({applications}) ->
      if applications?
        @openApplication applications
      else
        @do 'launcher'
  'applicationControl.nextWindow':
    spoken: 'gibby'
    description: 'Switch to next window in same application'
    tags: ['application', 'window', 'recommended']
    repeatable: true
    action: (input) ->
      @key '`', 'command'
  'applicationControl.previousWindow':
    spoken: 'shibby'
    description: 'Switch to previous window in same application'
    tags: ['application', 'window', 'recommended']
    repeatable: true
    action: (input) ->
      @key '`', 'command shift'
