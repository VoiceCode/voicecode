_.extend Commands.mapping,
  "swash":
    kind: "action"
    grammarType: "oneArgument"
    description: "opens drop-down menu by name"
    tags: ["application", "system"]
    action: (input) ->
      menuItem = CommandoSettings.menuItemAliases[input] or input
      @openMenuBarItem menuItem
      
  "blerch":
    kind: "action"
    grammarType: "individual"
    description: "search the menubar items (opens help menu)"
    tags: ["application", "system"]
    action: ->
      @openMenuBarItem "help"

  "system-volume":
    kind: "action"
    grammarType: "numberCapture"
    description: "adjust the system volume [0-100]"
    triggerPhrase: "volume"
    tags: ["system"]
    action: (input) ->
      @setVolume(input)