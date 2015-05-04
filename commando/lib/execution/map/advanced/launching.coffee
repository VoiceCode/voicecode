Commands.createDisabled
  "webs":
    grammarType: "textCapture"
    description: "opens a website by name"
    tags: ["system", "launching"]
    action: (input) ->
      if input?.length
        address = Scripts.fuzzyMatch Settings.websites, (input or []).join(" ")
        @openURL address
      else
        @openBrowser()
        @delay(50)
        @key "T", ['command']
  "dears":
    grammarType: "textCapture"
    description: "opens a directory in the finder"
    tags: ["system", "launching"]
    action: (input) ->
      if input?.length
        directory = Scripts.fuzzyMatch Settings.directories, input.join(' ')
        @revealFinderDirectory directory
  "sispref":
    grammarType: "textCapture"
    description: "opens a specific system preference item (if no argument given, just opens System Preferences)"
    tags: ["system", "launching"]
    action: (input) ->
      if input?.length
        preference = Scripts.fuzzyMatch Settings.systemPreferences, input.join(' ')
        @applescript """
        tell application "System Preferences"
          activate
          reveal pane "#{preference}"
        end tell
        """
      else
        @openApplication "System Preferences"