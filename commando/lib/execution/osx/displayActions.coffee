class OSX.displayActions
  constructor: () ->
    @storage = {}
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
    @result += "getClipboard()"
    ""
  verticalSelectionExpansion: (number) ->
    ""
  positionMouse: (x, y) ->
    @result += "positionMouse(#{x or ''}, #{y or ''})"
  mouseUp: ->
    @result += "mouseUp()"
  mouseDown: ->
    @result +=  "mouseDown()"
  symmetricSelectionExpansion: ->
    @result +=  "symmetricSelectionExpansion()"
  selectCurrentOccurrence: ->
    @result += "selectCurrentOccurrence()"
  selectPreviousOccurrence: ->
    @result += "selectPreviousOccurrence()"
  selectFollowingOccurrence: ->
    @result += "selectFollowingOccurrence()"
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
    @result += "selectPreviousWord()"
  selectFollowingWord: ->
    @result += "selectFollowingWord()"
  exec: (script) ->
    @result += "exec(#{script})"
  openMenuBarPath: (path) ->
    @result += "openMenuBarPath(#{path})"
  do: (other) ->
    @result += "do(#{other})"
  selectContiguousMatching: ->
    @result += "selectContiguousMatching()"
  selectBlock: ->
    @result += "selectBlock()"