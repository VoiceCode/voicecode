_.extend Commands.mapping,
  "swick":
    kind: "action"
    description: "Switch to most recent application"
    grammarType: "individual"
    tags: ["application", "Tab"]
    actions: [
      kind: "script"
      script: () ->
        """
        tell application "System Events"
          key code "48" using {command down}
        end tell
        delay 0.15
        """
    ]
  "launcher":
    kind: "action"
    description: "open application launcher"
    grammarType: "individual"
    tags: ["application", "system", "launching"]
    actions: [
      kind: "key"
      key: "Space"
      modifiers: ["option"]
      delay: 0.1
    ]
  "foxwitch":
    kind: "action"
    description: "open application switcher"
    grammarType: "individual"
    tags: ["application", "system", "launching"]
    actions: [
      kind: "key"
      key: "E"
      modifiers: ["option", "control", "shift", "command"]
    ]
  "webseek":
    kind: "action"
    description: "open a new browser tab (from anywhere)"
    grammarType: "individual"
    tags: ["system", "launching"]
    contextSensitive: true
    actions: [
      kind: "script"
      script: () ->
        Scripts.openWebTab()
      delay: 0.3
    ]
  "fox":
    kind: "action"
    description: "open application"
    tags: ["application", "system", "launching"]
    grammarType: "oneArgument"
    contextSensitive: true
    actions: [
      kind: "script"
      script: (value) ->
        Scripts.openApplication(value)
    ]

