class OSX.displayActions
  constructor: () ->
  reset: () ->
    @result = ""
  key: (key, modifiers) ->
    r = modifierCodes[key]
    base = if r
      r
    else
      key
    mods = @makeModifierText(modifiers or [])
    @result += "<code>#{mods}#{base}</code>"
  string: (string) ->
    s = string.replace(/\s/g, "&nbsp;")
    @result += "<code>#{s}</code>"
  keyDown: (key, modifiers) ->
    ""
  keyUp: (key, modifiers) ->
    ""
  click: ->    
    @result += "click"
  doubleClick: ->
    @result += "double-click"
  tripleClick: ->
    @result += "triple-click"
  rightClick: ->    
    @result += "right-click"
  shiftClick: ->    
    @result += "shift-click"
  commandClick: ->    
    @result += "command-click"
  optionClick: ->    
    @result += "option-click"
  applescript: (content) ->
    @result += "applescript: #{content}"
  openMenuBarItem: (item) ->
    @result += "openMenuBarItem(#{item})"
  scrollUp: (amount) ->
    @result += "scrollUp"
  openApplication: (name) ->
    @result += "openApplication(#{name})"
  openBrowser: ->
    @result += "openBrowser"
  openURL: (url) ->
    @result += "openURL"
  delay: (ms) ->
    ""
  currentApplication: ->
    ""
  setGlobalContext: (context) ->
    @result += "setGlobalContext"
  revealFinderDirectory: (directory) ->
    @result += "revealFinderDirectory"
  setVolume: (volume) ->
    @result += "setVolume(volume)"
  clickServiceItem: (item) ->
    @result += "clickServiceItem(item)"
  getClipboard: ->
    ""
  verticalSelectionExpansion: (number) ->
    ""
  makeModifierText: (modifiers) ->
    r = _.map modifiers, (m) ->
      modifierCodes[m]
    r.join('')

