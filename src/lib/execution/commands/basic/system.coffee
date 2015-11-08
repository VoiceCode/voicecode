Commands.createDisabled
  'open.drop-down':
    spoken: 'swash'
    grammarType: 'oneArgument'
    description: 'opens drop-down menu by name. A few special arguments are also allowed: [bluetooth, wi-fi, clock, battery]'
    tags: ['application', 'system', 'recommended']
    inputRequired: true
    action: (input) ->
      return unless input?.length
      specialItems = ['bluetooth', 'wi-fi', 'clock', 'battery', 'user']
      if input in specialItems
        @applescript """
        tell application "System Events" to tell process "SystemUIServer"
          click (first menu bar item whose value of attribute "AXDescription" contains "#{input}") of menu bar 1
        end tell
        """, false
      else if input is "apple"
        @applescript """
        tell application "System Events" to tell (process 1 where frontmost is true)
          click menu bar item 1 of menu bar 1
        end tell
        """, false
      else
        menuItem = Settings.menuItemAliases[input] or input
        @openMenuBarItem menuItem

  'open.help-drop-down':
    spoken: 'blerch'
    description: 'search the menubar items (opens help menu)'
    tags: ['application', 'system', 'recommended']
    action: ->
      @openMenuBarItem 'help'

  'volume.set':
    spoken: 'volume'
    grammarType: 'numberCapture'
    description: 'adjust the system volume [0-100]'
    tags: ['system', 'recommended']
    continuous: false
    inputRequired: true
    action: (input) ->
      @setVolume(input)

  'volume.increase':
    spoken: 'volume plus'
    grammarType: 'numberCapture'
    description: 'increase the system volume by [0-100] (default 10)'
    tags: ['system', 'recommended']
    continuous: false
    inputRequired: false
    action: (input) ->
      currentVolume = @getCurrentVolume() or 0
      @setVolume currentVolume + (input or 10)

  'volume.decrease':
    spoken: 'volume minus'
    grammarType: 'numberCapture'
    description: 'decrease the system volume by [0-100] (default 10)'
    tags: ['system', 'recommended']
    continuous: false
    inputRequired: false
    action: (input) ->
      currentVolume = @getCurrentVolume() or 0
      @setVolume currentVolume - (input or 10)


  'window.changeProperties':
    spoken: 'windy'
    grammarType: 'custom'
    rule: '<name> (digit)* (windowPosition)*'
    description: 'set the size/position of the frontmost window to one of the preset sizes/positions'
    misspellings: ['wendy']
    tags: ['system', 'window', 'recommended']
    variables:
      digit: -> Settings.digits
      windowPosition: -> Settings.windowPositions
    action: ({digit, windowPosition}) ->
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
