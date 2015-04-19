Commands.create
  "duke":
    kind: "action"
    grammarType: "individual"
    description: "double click"
    tags: ["mouse", "recommended"]
    action: ->
      @doubleClick()
  "chipper":
    kind: "action"
    grammarType: "individual"
    description: "right click"
    tags: ["mouse", "recommended"]
    action: ->
      @rightClick()
  "chiff":
    kind: "action"
    grammarType: "individual"
    description: "left click"
    tags: ["mouse", "recommended"]
    action: ->
      @click()
  "triplick":
    kind: "action"
    grammarType: "individual"
    description: "left click"
    tags: ["mouse", "recommended"]
    action: ->
      @tripleClick()
  "shicks":
    kind: "action"
    grammarType: "individual"
    description: "shift+click"
    tags: ["mouse", "recommended"]
    aliases: ["chicks"]
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
  "pretzel":
    kind: "action"
    grammarType: "individual"
    description: "press down mouse and hold"
    tags: ["mouse"]
    action: ->
      @mouseDown()
  "relish":
    kind: "action"
    grammarType: "individual"
    description: "release the mouse after press and hold"
    tags: ["mouse"]
    action: ->
      @mouseUp()
