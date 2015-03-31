_.extend Commands.mapping,
  "webs":
    kind: "action"
    grammarType: "textCapture"
    description: "opens a website by name"
    tags: ["system", "launching"]
    actions: [
      kind: "script"
      script: (input) ->
        Scripts.openWebsite((input or []).join(" "))
    ]
  "dears":
    kind: "action"
    grammarType: "textCapture"
    description: "opens a directory in the finder"
    tags: ["system", "launching"]
    contextSensitive: true
    actions: [
      kind: "script"
      script: (input) ->
        if input?.length
          directory = Scripts.levenshteinMatch CommandoSettings.directories, input.join(' ')
          """
          do shell script "open #{directory}"
          """
    ]
  "sispref":
    kind: "action"
    grammarType: "textCapture"
    description: "opens a specific system preference items (or none if no input)"
    tags: ["system", "launching"]
    actions: [
      kind: "script"
      script: (input) ->
        if input?.length
          preference = Scripts.levenshteinMatch CommandoSettings.systemPreferences, input.join(' ')
          """
          tell application "System Preferences"
            activate
            reveal pane "#{preference}"
          end tell
          """
        else
          """
          tell application "System Preferences" to activate
          """
    ]
