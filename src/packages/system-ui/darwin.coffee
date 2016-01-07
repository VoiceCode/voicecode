return unless pack = Packages.get 'darwin'

pack.implement
  'system-ui:open-drop-down': (input) ->
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

  'system-ui:open-help-drop-down': ->
    @openMenuBarItem 'help'
