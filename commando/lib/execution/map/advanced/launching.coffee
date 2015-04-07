_.extend Commands.mapping,
  "webs":
    kind: "action"
    grammarType: "textCapture"
    description: "opens a website by name"
    tags: ["system", "launching"]
    action: (input) ->
      if input?.length
        address = Scripts.fuzzyMatch CommandoSettings.websites, (input or []).join(" ")
        @openURL address
      else
        @openBrowser()
        @delay(50)
        @key "T", ['command']
  "dears":
    kind: "action"
    grammarType: "textCapture"
    description: "opens a directory in the finder"
    tags: ["system", "launching"]
    action: (input) ->
      if input?.length
        directory = Scripts.fuzzyMatch CommandoSettings.directories, input.join(' ')
        @revealFinderDirectory directory
  "sispref":
    kind: "action"
    grammarType: "textCapture"
    description: "opens a specific system preference items (or none if no input)"
    tags: ["system", "launching"]
    action: (input) ->
      if input?.length
        preference = Scripts.fuzzyMatch CommandoSettings.systemPreferences, input.join(' ')
        @applescript """
        tell application "System Preferences"
          activate
          reveal pane "#{preference}"
        end tell
        """
      else
        @openApplication "System Preferences"