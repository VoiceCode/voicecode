Commands.createDisabledWithDefaults
  grammarType: "textCapture"
  inputRequired: true
  tags: ["system", "launching"]
,
  "core.openWebsite":
    spoken: 'webs'
    description: "Open a website by name"
    action: (input) ->
      if input?.length
        address = @fuzzyMatch Settings.websites, (input or []).join(" ")
        @openURL address
      else
        @openBrowser()
        @delay(50)
        @newTab()
  "core.openDirectory":
    spoken: 'dears'
    description: "Open a directory in file browser"
    action: (input) ->
      if input?.length
        directory = @fuzzyMatch Settings.directories, input.join(' ')
        @revealFinderDirectory directory
  "core.openSystemPreferences":
    spoken: 'sispref'
    description: 'Open system preferences'
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
