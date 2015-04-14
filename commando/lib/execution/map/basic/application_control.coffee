Commands.create
  "swick":
    kind: "action"
    description: "Switch to most recent application"
    grammarType: "individual"
    tags: ["application", "tab", "recommended"]
    action: ->
      @key "Tab", ['command']
      @delay(150)
  "launcher":
    kind: "action"
    description: "open application launcher"
    grammarType: "individual"
    tags: ["application", "system", "launching", "alfred"]
    action: ->
      @key " ", ['option']
      @delay 100
  "foxwitch":
    kind: "action"
    description: "open application switcher"
    grammarType: "individual"
    tags: ["application", "system", "launching", "tab", "recommended"]
    action: ->
      @keyDown "Command"
      @keyDown "Tab", ["command"]
      @keyUp "Tab"
      @delay 10000
      @keyUp "Tab", ["command"]
      @keyUp "Command"
  "webseek":
    kind: "action"
    description: "open a new browser tab (from anywhere)"
    grammarType: "individual"
    tags: ["system", "launching", "recommended"]
    action: ->
      @openBrowser()
      @key "T", ['command']
  "fox":
    kind: "action"
    description: "open application"
    tags: ["application", "system", "launching", "recommended"]
    grammarType: "oneArgument"
    action: (name) ->
      if name?.length
        application = Scripts.fuzzyMatch Settings.applications, name
        @openApplication application

