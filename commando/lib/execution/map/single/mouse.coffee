_.extend Commands.mapping,
  "duke":
    kind: "action"
    grammarType: "individual"
    description: "double click"
    tags: ["mouse"]
    action: ->
      @doubleClick()
  "chipper":
    kind: "action"
    grammarType: "individual"
    description: "right click"
    tags: ["mouse"]
    action: ->
      @rightClick()
  "chiff":
    kind: "action"
    grammarType: "individual"
    description: "left click"
    tags: ["mouse"]
    action: ->
      @click()
  "triplick":
    kind: "action"
    grammarType: "individual"
    description: "left click"
    tags: ["mouse"]
    action: ->
      @tripleClick()
  "shicks":
    kind: "action"
    grammarType: "individual"
    description: "shift+click"
    tags: ["mouse"]
    action: ->
      @shiftClick()
  "comlick":
    kind: "action"
    grammarType: "individual"
    description: "command+click"
    tags: ["mouse"]
    action: ->
      @commandClick()
  "croplick":
    kind: "action"
    grammarType: "individual"
    description: "option+click"
    tags: ["mouse"]
    action: ->
      @optionClick()
