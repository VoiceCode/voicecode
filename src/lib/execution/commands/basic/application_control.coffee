Commands.createDisabled
  'core.applicationControl.switchToPrevious':
    spoken: 'swick'
    description: 'Switch to most recent application'
    tags: ['application', 'tab', 'recommended']
    action: ->
      @switchApplication()
      @delay(250)
  'core.applicationControl.openLauncher':
    spoken: 'launcher'
    description: 'open application launcher'
    tags: ['application', 'system', 'launching', 'alfred']
    action: ->
      @key 'space', 'option'
      @delay 100
  'core.applicationControl.openSearch':
    spoken: 'spotty'
    description: 'open spotlight'
    tags: ['application', 'system', 'launching']
    action: ->
      @key ' ', 'command'
      @delay 100
  'core.applicationControl.openApplicationSwitcher':
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
  'core.applicationControl.openBrowser':
    spoken: 'webseek'
    description: 'open a new browser tab (from anywhere)'
    tags: ['system', 'launching', 'recommended']
    action: ->
      @openBrowser()
      @newTab()
      @delay 200
  'core.applicationControl.openApplication':
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
  'core.applicationControl.nextWindow':
    spoken: 'gibby'
    description: 'Switch to next window in same application'
    tags: ['application', 'window', 'recommended']
    repeatable: true
    action: (input) ->
      @key '`', 'command'
  'core.applicationControl.previousWindow':
    spoken: 'shibby'
    description: 'Switch to previous window in same application'
    tags: ['application', 'window', 'recommended']
    repeatable: true
    action: (input) ->
      @key '`', 'command shift'
