Commands.createDisabled
  'swick':
    description: 'Switch to most recent application'
    tags: ['application', 'tab', 'recommended']
    action: ->
      @switchApplication()
      @delay(250)
  'launcher':
    description: 'open application launcher'
    tags: ['application', 'system', 'launching', 'alfred']
    action: ->
      @key 'space', 'option'
      @delay 100
  'spotty':
    description: 'open spotlight'
    tags: ['application', 'system', 'launching']
    action: ->
      @key ' ', 'command'
      @delay 100
  'foxwitch':
    description: 'open application switcher'
    tags: ['application', 'system', 'launching', 'tab', 'recommended']
    action: ->
      @keyDown 'command', 'command'
      @keyDown 'tab', 'command'
      @keyUp 'tab', 'command'
      @delay 10000
      @keyUp 'tab', 'command'
      @keyUp 'command'
  'webseek':
    description: 'open a new browser tab (from anywhere)'
    tags: ['system', 'launching', 'recommended']
    action: ->
      @openBrowser()
      @newTab()
      @delay 200
  'fox':
    description: 'open application'
    tags: ['application', 'system', 'launching', 'recommended']
    grammarType: 'custom'
    rule: '(applications)'
    action: ({applications}) ->
      if applications?
        @openApplication applications
      else
        @do 'launcher'
