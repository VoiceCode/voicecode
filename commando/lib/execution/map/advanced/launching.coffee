Commands.createDisabledWithDefaults
  grammarType: "textCapture"
  tags: ["system", "launching"]
,
  "webs":
    description: "opens a website by name"
    action: (input) ->
      if input?.length
        address = @fuzzyMatch Settings.websites, (input or []).join(" ")
        @openURL address
      else
        @openBrowser()
        @delay(50)
        @newTab()
  "dears":
    description: "opens a directory in the finder"
    action: (input) ->
      if input?.length
        directory = @fuzzyMatch Settings.directories, input.join(' ')
        @revealFinderDirectory directory
  "sispref":
    tags: ["system", "launching"]
    action: (input) ->
      if input?.length
        preference = @fuzzyMatch Settings.systemPreferences, input.join(' ')
        @applescript """
        tell application "System Preferences"
          activate
          reveal pane "#{preference}"
        end tell
        """
      else
        @openApplication "System Preferences"
