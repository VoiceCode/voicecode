return unless pack = Packages.get 'darwin'

pack.implement
  'window-manager:presets': ({digit, windowPosition}) ->
    if digit? or windowPosition?
      preset = windowPosition or Settings.windowPosition['middle']
      screenInfo = @getScreenInfo()
      screen = if digit?
        screenInfo.screens[digit - 1] or screenInfo.currentFrame
      else
        screenInfo.currentFrame

      # console.log screen
      newWidth = if preset.width <= 1
        screen.size.width * preset.width
      else
        preset.width

      newHeight = if preset.height <= 1
        screen.size.height * preset.height
      else
        preset.height

      offsetX = if preset.x is 'auto'
        (screen.size.width - newWidth) / 2
      else if preset.x <= 1
        screen.size.width * preset.x
      else
        preset.x

      offsetY = if preset.y is 'auto'
        (screen.size.height - newHeight) / 2
      else if preset.y <= 1
        screen.size.height * preset.y
      else
        preset.y

      newOriginX = screen.origin.x + offsetX
      newOriginY = screen.origin.y + offsetY + 27

      script = """
      tell application "System Events" to tell (process 1 whose frontmost is true)
        set position of window 1 to {#{newOriginX}, #{newOriginY}}
        set size of window 1 to {#{newWidth}, #{newHeight}}
      end tell
      """
      # console.log script
      @applescript(script, false)
