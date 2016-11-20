Actions = require '../base/actions'

class DarwinActions extends Actions
  constructor: ->
    super
    @keys = require './keyCodes'
    @undoableKeys = [
      'v command'
    ]

  _modifierMask: (modifiers) ->
    mask = 0
    for m in modifiers
      bits = switch m
        when "shift"
          $.kCGEventFlagMaskShift
        when "command"
          $.kCGEventFlagMaskCommand
        when "option"
          $.kCGEventFlagMaskAlternate
        when "control"
          $.kCGEventFlagMaskControl
      mask = mask | bits
    mask

  contextAllowsArrowKeyTextSelection: ->
    not _.includes(Settings.os.applicationsThatWillNotAllowArrowKeyTextSelection, @currentApplication().name)

  _getCurrentBrowserUrl: (cb) ->
    mutate('getCurrentBrowserUrl', {url: null}).url

  currentBrowserUrl: ({reset} = {reset: false}) ->
    if reset or !@_currentBrowserUrl?
      # refresh in bg
      @_getCurrentBrowserUrl (url) =>
        console.log url: url
        @_currentBrowserUrl = url
      @_currentBrowserUrl
    else
      @_currentBrowserUrl

  urlContains: (url) ->
    console.log current: @_currentBrowserUrl, actual: url
    @_currentBrowserUrl?.indexOf(url) != -1

  urlIs: (url) ->
    @_currentBrowserUrl is url

  checkBundleExistence: do ->
    cache = {global: true}
    (bundleId) ->
      return cache[bundleId] if cache[bundleId]?
      cache[bundleId] = !!Applescript """
      try
        tell application "Finder" to get application file id \"#{bundleId}\"
        return true
      on error
        return false
      end try
      """

  clickServiceItem: (item) ->
    emit 'notUndoable'
    @applescript """
    tell application "System Events" to tell (process 1 where frontmost is true)
      click menu item "#{item}" of menu "Services" of menu item "Services" of menu 1 of menu bar item 2 of menu bar 1
    end tell
    delay 1
    """

  verticalSelectionExpansion: (number) ->
    emit 'notUndoable'
    @copy()
    @delay 100
    clipboard = @getClipboard()
    numberOfLines = clipboard.split("\n").length
    console.log bloxy:
      numberOfLines: numberOfLines
      clipboard: clipboard
    @up number
    @key 'left', 'command'
    downtimes = numberOfLines + (number * 2)
    if clipboard.charAt(clipboard.length - 1) is "\n"
      downtimes -= 1

    @repeat downtimes, =>
      @key 'down', 'shift'


  deletePartialWord: (direction) ->
    distance = 1
    if direction is "right"
      @key 'right', 'command shift'
    else
      @key 'left', 'command shift'
    content = @getSelectedText()
    components = SelectionTransformer.uncamelize(content).split(" ")
    if direction is "left"
      components = components.reverse()
    foundContent = false
    spacePadding = 0
    for item in components
      unless foundContent
        if item.length is 0
          spacePadding += 1
        else
          foundContent = true

    chosenComponents = components.splice(0, distance + spacePadding)
    characters = chosenComponents.join('').length + spacePadding
    if direction is "right"
      @left()
    else
      @right()
    if characters > 0
      for index in [1..characters]
        if direction is "right"
          @key 'right', 'shift'
        else
          @key 'left', 'shift'
      @key 'delete'


# module.exports = do ->
#   isActive = false
#   Events.once 'startupComplete', -> isActive = true
#   return new Proxy (new DarwinActions), {
#     get: (target, property, receiver) ->
#       if not target[property]? and isActive
#         target.breakChain "Actions.#{property} does not exist."
#         error 'missingAction'
#         , {property}, "Actions.#{property} does not exist."
#       Reflect.get target, property, receiver
# }
module.exports = new DarwinActions
