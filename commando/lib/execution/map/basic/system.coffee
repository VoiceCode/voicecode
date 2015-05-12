Commands.createDisabled
  "swash":
    grammarType: "oneArgument"
    description: "opens drop-down menu by name"
    tags: ["application", "system", "recommended"]
    action: (input) ->
      menuItem = Settings.menuItemAliases[input] or input
      @openMenuBarItem menuItem
      
  "blerch":
    description: "search the menubar items (opens help menu)"
    tags: ["application", "system", "recommended"]
    action: ->
      @openMenuBarItem "help"

  "volume":
    grammarType: "numberCapture"
    description: "adjust the system volume [0-100]"
    tags: ["system", "recommended"]
    continuous: false
    action: (input) ->
      @setVolume(input)

  "windy":
    grammarType: "textCapture"
    description: "set the size of the current active window to one of the preset sizes"
    aliases: ["wendy"]
    tags: ["system", "window", "recommended"]
    action: (input) ->
      if input?.length      
        preset = Scripts.fuzzyMatch Settings.windowPositions, input.join(' ')
        screen = @getScreenInfo().currentFrame
        # console.log screen
        newWidth = if preset.width <= 1
          screen.size.width * preset.width
        else
          preset.width

        newHeight = if preset.height <= 1
          screen.size.height * preset.height
        else
          preset.height

        offsetX = if preset.x is "auto"
          (screen.size.width - newWidth) / 2
        else if preset.x <= 1
          screen.size.width * preset.x
        else
          preset.x

        offsetY = if preset.y is "auto"
          (screen.size.height - newHeight) / 2
        else if preset.y <= 1
          screen.size.height * preset.y
        else
          preset.y
        
        newOriginX = screen.origin.x + offsetX
        newOriginY = screen.origin.y + offsetY

        script = """
        tell application "System Events" to tell (process 1 whose frontmost is true)
          set position of window 1 to {#{newOriginX}, #{newOriginY}}
          set size of window 1 to {#{newWidth}, #{newHeight}}
        end tell
        """
        # console.log script
        @applescript(script, false)


      