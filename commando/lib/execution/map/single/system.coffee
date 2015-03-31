_.extend Commands.mapping,
  "swash":
    kind: "action"
    grammarType: "oneArgument"
    description: "opens drop-down menu by name"
    tags: ["application", "system"]
    actions: [
      kind: "script"
      script: (input) ->
        menuItem = CommandoSettings.menuItemAliases[input] or input
        Scripts.openDropDown(menuItem)
    ]
  "system-volume":
    kind: "action"
    grammarType: "numberCapture"
    description: "adjust the system volume [0-100]"
    triggerPhrase: "volume"
    contextSensitive: true
    tags: ["system"]
    actions: [
      kind: "script"
      script: (input) ->
        Scripts.setVolume(input)
    ]
