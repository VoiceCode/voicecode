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
    @result += "openMenuBarItem(#{item or ''})"
  scrollUp: (amount) ->
    @result += "scrollUp"
  openApplication: (name) ->
    @result += "openApplication(#{name or ''})"
  openBrowser: ->
    @result += "openBrowser"
  openURL: (url) ->
    @result += "openURL(#{url or ''})"
  delay: (ms) ->
    ""
  currentApplication: ->
    ""
  setGlobalContext: (context) ->
    @result += "setGlobalContext(#{context or ''})"
  revealFinderDirectory: (directory) ->
    @result += "revealFinderDirectory(#{directory or ''})"
  setVolume: (volume) ->
    @result += "setVolume(#{volume or ''})"
  clickServiceItem: (item) ->
    @result += "clickServiceItem(#{item or ''})"
  getClipboard: ->
    ""
  verticalSelectionExpansion: (number) ->
    ""
  positionMouse: (x, y) ->
    "positionMouse(#{x or ''}, #{y or ''})"
  mouseUp: ->
    "mouseUp"
  mouseDown: ->
    "mouseDown"
  symmetricSelectionExpansion: ->
    "symmetricSelectionExpansion()"
  selectCurrentOccurrence: ->
    "selectCurrentOccurrence()"
  selectPreviousOccurrence: ->
    "selectPreviousOccurrence()"
  selectFollowingOccurrence: ->
    "selectFollowingOccurrence()"
  makeModifierText: (modifiers) ->
    r = _.map modifiers, (m) ->
      modifierCodes[m]
    r.join('')
  scrollRight: ->
    "scrollRight()"
  scrollLeft: ->
    "scrollLeft()"
  scrollUp: ->
    "scrollUp()"
  scrollDown: ->
    "scrollDown()"
  getSelectedText: ->
    "getSelectedText()"
  canDetermineSelections: ->
    false
  isTextSelected: ->
    false
  selectPreviousWord: ->
    "selectPreviousWord()"
  selectFollowingWord: ->
    "selectFollowingWord()"
