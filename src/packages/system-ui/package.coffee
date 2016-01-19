pack = Packages.register
  name: 'system-ui'
  description: 'Interact with system user interface elements'

pack.commands
  'open-drop-down':
    spoken: 'swash'
    grammarType: 'oneArgument'
    description: 'opens drop-down menu by name. A few special arguments are also allowed: [bluetooth, wi-fi, clock, battery]'
    tags: ['application', 'system', 'recommended']
    inputRequired: true
  'open-help-drop-down':
    spoken: 'blerch'
    description: 'search the menubar items (opens help menu)'
    tags: ['application', 'system', 'recommended']


# TODO move this into darwin.coffe, but how do we reference 'pack' from there?
if global.platform is 'darwin'
  pack.commands
    "open-system-preferences":
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

require "./#{global.platform}"
