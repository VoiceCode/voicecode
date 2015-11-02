simpleActions = [
  "microphoneOff"
  "selectContiguousMatching"
  "click"
  "doubleClick"
  "tripleClick"
  "rightClick"
  "shiftClick"
  "commandClick"
  "optionClick"
  "openBrowser"
  "mouseUp"
  "mouseDown"
  "symmetricSelectionExpansion"
  "selectCurrentOccurrence"
  "selectPreviousOccurrence"
  "selectNextOccurrence"
  "scrollRight"
  "scrollLeft"
  "scrollUp"
  "scrollDown"
  "getSelectedText"
  "selectPreviousWord"
  "selectFollowingWord"
  "selectBlock"
  "clickAtPosition"
]

noDisplayActions = [
  "setClipboard"
]

class Platforms.base.displayActions extends Platforms.base.actions
  constructor: () ->
    @storage = {}
    _.each simpleActions, (action) =>
      @[action] = =>
        @result += action + "()"
    _.each noDisplayActions, (action) =>
      @[action] = =>
        ""
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
  applescript: (content) ->
    @result += "applescript: #{content}"
  openMenuBarItem: (item) ->
    @result += "openMenuBarItem(#{item or ''})"
  scrollUp: (amount) ->
    @result += "scrollUp"
  openApplication: (name) ->
    @result += "openApplication(#{name or ''})"
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
  getCurrentVolume: ->
    50
  clickServiceItem: (item) ->
    @result += "clickServiceItem(#{item or ''})"
  getClipboard: ->
    @result += "getClipboard()"
    ""
  verticalSelectionExpansion: (number) ->
    ""
  positionMouse: (x, y) ->
    @result += "positionMouse(#{x or ''}, #{y or ''})"
  makeModifierText: (modifiers) ->
    if modifiers?.length
      r = _.map modifiers.split(" "), (m) ->
        modifierCodes[m]
      r.join('')
    else
      ""
  canDetermineSelections: ->
    false
  isTextSelected: ->
    false
  exec: (script) ->
    @result += "exec(#{script})"
  openMenuBarPath: (path) ->
    @result += "openMenuBarPath(#{path})"
  do: (other) ->
    @result += "do(#{other})"
  runAtomCommand: (command) ->
    @result += "runAtomCommand(#{command})"
  deletePartialWord: (direction) ->
    @result += "deletePartialWord(#{direction})"
  transformSelectedText: (options) ->
    @result += "transformSelectedText(#{options})"
  getMousePosition: ->
    {}
  previousMouseLocation: ->
    {}
