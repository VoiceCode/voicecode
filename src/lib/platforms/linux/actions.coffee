Actions = require '../base/actions'

class Platforms.linux.actions extends Actions
  resolveSuperModifier: ->
    "control"
  key: (key, modifiers) ->
    key = key.toString()
    @notUndoable()
  string: (string) ->
  keyDown: (key, modifiers) ->
  keyUp: (key, modifiers) ->
  _keyDown: (key, modifiers) ->
  _keyUp: (key, modifiers) ->
  _modifierMask: (modifiers) ->
  clickDelayRequired: ->
    Settings.clickDelayRequired[@currentApplication().name] or Settings.clickDelayRequired["default"] or 0
  _pressKey: (key, modifiers) ->
  getMousePosition: ->
  mouseDown: (position) ->
  mouseUp: (position) ->
  click: ->
  doubleClick: ->
  tripleClick: ->
  rightClick: ->
  shiftClick: ->
  commandClick: ->
  optionClick: ->
  getScreenInfo: ->
  positionMouse: (x, y, screenIndex) ->
  applescript: (content, shouldReturn=true) ->
  exec: (script) ->
    Execute script
  runAtomCommand: (name, options) ->
    info =
      command: name
      options: options

    command = """echo "#{JSON.stringify(info).replace(/"/g, '\\"')}" | nc -U /tmp/voicecode-atom.sock"""
    console.log command
    @exec command
  scrollDown: (amount) ->
  scrollUp: (amount) ->
  scrollLeft: (amount) ->
  scrollRight: (amount) ->
  openApplication: (name) ->
  openBrowser: ->
  openURL: (url) ->
  currentApplication: ->
  transformSelectedText: (transform) ->
  revealFinderDirectory: (directory) ->
  setVolume: (volume) ->
  isTextSelected: ->
  getClipboard: ->
  setClipboard: (text) ->
  getSelectedText: ->
  waitForClipboard: ->
    delay = Settings.clipboardLatency[@currentApplication().name] or 200
    @delay delay
  canDetermineSelections: ->
    not _.contains(Settings.applicationsThatCanNotHandleBlankSelections, @currentApplication().name)
  verticalSelectionExpansion: (number) ->
  symmetricSelectionExpansion: (number) ->
  selectCurrentOccurrence: (input) ->
  selectPreviousOccurrence: (input) ->
  selectNextOccurrence: (input) ->
  selectNextOccurrenceWithDistance: (phrase, distance) ->
  selectPreviousOccurrenceWithDistance: (phrase, distance) ->
  extendSelectionToFollowingOccurrenceWithDistance: (phrase, distance) ->
  extendSelectionToPreviousOccurrenceWithDistance: (phrase, distance) ->
  selectContiguousMatching: (params) ->
  selectSurroundedOccurrence: (params) ->
  selectBlock: ->
  deletePartialWord: (direction) ->
  notify: (text) ->
    notify null, null, text

module.exports = new Platforms.linux.actions
