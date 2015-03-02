Commands.registerConditionalModuleCommands "smartnav",
  "mousy":
    kind: "action"
    grammarType: "individual"
    description: "center the mouse in the middle of the screen (requires smartnav)"
    tags: ["smartnav", "mouse"]
    actions: [
      kind: "key"
      key: "S"
      modifiers: ["command", "option", "control", "shift"]
    ]