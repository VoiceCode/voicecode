pack = Packages.register
  name: 'launcher'
  description: 'Open/launch various types of things'

pack.commands
  grammarType: "textCapture"
  inputRequired: true
  tags: ["system", "launching"]
,
  "open-website":
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
  "open-directory":
    spoken: 'dears'
    description: "Open a directory in file browser"
    action: (input) ->
      if input?.length
        directory = @fuzzyMatch Settings.directories, input.join(' ')
        @revealFinderDirectory directory
