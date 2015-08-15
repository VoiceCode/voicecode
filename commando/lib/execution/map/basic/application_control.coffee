Commands.createDisabled
  "swick":
    description: "Switch to most recent application"
    tags: ["application", "tab", "recommended"]
    action: ->
      @key "Tab", 'command'
      @delay(250)
  "launcher":
    description: "open application launcher"
    tags: ["application", "system", "launching", "alfred"]
    action: ->
      @key " ", 'option'
      @delay 100
  "spotty":
    description: "open spotlight"
    tags: ["application", "system", "launching"]
    action: ->
      @key " ", 'command'
      @delay 100
  "foxwitch":
    description: "open application switcher"
    tags: ["application", "system", "launching", "tab", "recommended"]
    action: ->
      @keyDown "Command", "command"
      @keyDown "Tab", "command"
      @keyUp "Tab", "command"
      @delay 10000
      @keyUp "Tab", "command"
      @keyUp "Command"
  "webseek":
    description: "open a new browser tab (from anywhere)"
    tags: ["system", "launching", "recommended"]
    action: ->
      @openBrowser()
      @key "T", 'command'
      @delay 200
  "fox":
    description: "open application"
    tags: ["application", "system", "launching", "recommended"]
    grammarType: "custom"
    rule: '(applications)'
    action: ({applications}) ->
      if applications?
        @openApplication applications
      else
        @do "launcher"
