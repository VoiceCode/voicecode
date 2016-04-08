Actions = require '../base/actions'

class DarwinActions extends Actions
  constructor: ->
    super
    @keys = require './keyCodes'
    @undoableKeys = [
      'v command'
    ]

  setCurrentApplication: (application) ->
    super
    if @inBrowser()
      @monitorBrowserUrl(true)
    else
      @monitorBrowserUrl(false)

  inBrowser: ->
    @_currentApplication.bundleId in Settings.browserApplications

  monitorBrowserUrl: (monitor=true) ->
    if monitor
      @_monitorBrowserUrlInterval ?= setInterval =>
        @currentBrowserUrl(reset: true)
      , 1600
    else
      clearInterval @_monitorBrowserUrlInterval
      delete @_monitorBrowserUrlInterval

  resolveSuperModifier: ->
    "command"

  ___key: (key, modifiers) ->
    key = key.toString().toLowerCase()

    emit 'notUndoable'
    code = @keys.keyCodes[key]
    if code?
      @_pressKey(code, @_normalizeModifiers(modifiers))
      @delay Settings.keyDelay or 8
    else
      code = @keys.keyCodesShift[key]
      if code?
        mods = _.uniq((modifiers or []).concat("shift"))
        @_pressKey code, @_normalizeModifiers(mods)
        @delay Settings.keyDelay or 8


  keyDown: (key, modifiers) ->
    code = @keys.keyCodes[key.toLowerCase()]
    if code?
      @_keyDown code, @_normalizeModifiers(modifiers)
  keyUp: (key, modifiers) ->
    code = @keys.keyCodes[key.toLowerCase()]
    if code?
      @_keyUp code, @_normalizeModifiers(modifiers)

  _keyDown: (keyCode, modifiers) ->
    e = $.CGEventCreateKeyboardEvent(null, keyCode, true)
    if modifiers?.length
      $.CGEventSetFlags(e, @_modifierMask(modifiers))
    else
      $.CGEventSetFlags(e, 0)
    $.CGEventPost($.kCGSessionEventTap, e)

  _keyUp: (keyCode, modifiers) ->
    e = $.CGEventCreateKeyboardEvent(null, keyCode, false)
    if modifiers
      $.CGEventSetFlags(e, @_modifierMask(modifiers))
    else
      $.CGEventSetFlags(e, 0)
    $.CGEventPost($.kCGSessionEventTap, e)

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

  needsExplicitModifierPresses: ->
    _.includes Settings.applicationsThatNeedExplicitModifierPresses, @currentApplication().name

  contextAllowsArrowKeyTextSelection: ->
    not _.includes(Settings.applicationsThatWillNotAllowArrowKeyTextSelection, @currentApplication().name)

  clickDelayRequired: ->
    Settings.clickDelayRequired[@currentApplication().name] or Settings.clickDelayRequired["default"] or 0

  _pressKey: (key, modifiers) ->
    if modifiers? and @needsExplicitModifierPresses()
      for m in modifiers
        @_keyDown @keys.keyCodes[m], [m]
        @delay Settings.modifierKeyDelay or 2

    @_keyDown key, modifiers
    @_keyUp key #, modifiers

    if modifiers? and @needsExplicitModifierPresses()
      # get a copy of the modifiers so we can reverse it
      mods = modifiers.slice().reverse()
      for m in mods
        @_keyUp @keys.keyCodes[m] #, [m]
        @delay Settings.modifierKeyDelay or 2

  getMousePosition: ->
    $.CGEventGetLocation($.CGEventCreate(null))

  mouseDown: (position) ->
    emit 'notUndoable'
    position ?= @getMousePosition()
    down = $.CGEventCreateMouseEvent(null, $.kCGEventLeftMouseDown, position, $.kCGMouseButtonLeft)
    $.CGEventPost($.kCGSessionEventTap, down)

  mouseUp: (position) ->
    emit 'notUndoable'
    position ?= @getMousePosition()
    up = $.CGEventCreateMouseEvent(null, $.kCGEventLeftMouseUp, position, $.kCGMouseButtonLeft)
    $.CGEventPost($.kCGSessionEventTap, up)

  previousMouseLocation: (index) ->
    mouseTracker.previousLocation(index or 0)

  click: (position) ->
    emit 'notUndoable'
    position ?= @getMousePosition()
    @mouseDown(position)
    @mouseUp(position)
    @delay(@clickDelayRequired())

  clickAtPosition: (pos) ->
    console.log "clicking at", pos
    @moveMouseAndReturn pos, (position) =>
      @click(position)

  doubleClick: (position) ->
    emit 'notUndoable'
    position ?= @getMousePosition()
    down = $.CGEventCreateMouseEvent(null, $.kCGEventLeftMouseDown, position, $.kCGMouseButtonLeft)
    up = $.CGEventCreateMouseEvent(null, $.kCGEventLeftMouseUp, position, $.kCGMouseButtonLeft)
    $.CGEventPost($.kCGSessionEventTap, down)
    $.CGEventPost($.kCGSessionEventTap, up)
    $.CGEventSetIntegerValueField(down, $.kCGMouseEventClickState, 2)
    $.CGEventPost($.kCGSessionEventTap, down)
    $.CGEventSetIntegerValueField(up, $.kCGMouseEventClickState, 2)
    $.CGEventPost($.kCGSessionEventTap, up)
    @delay(@clickDelayRequired())

  doubleClickAtPosition: (pos) ->
    @moveMouseAndReturn pos, (position) =>
      @doubleClick(position)

  moveMouseAndReturn: (pos, action) ->
    current = @getMousePosition()
    position = if pos?
      $.CGPointMake(pos.x, pos.y)
    else
      @getMousePosition()

    action(position)

    # move the mouse back
    event = $.CGEventCreateMouseEvent null, $.kCGEventMouseMoved, current, 0
    $.CGEventPost($.kCGSessionEventTap, event)

  tripleClick: ->
    emit 'notUndoable'
    position = @getMousePosition()
    down = $.CGEventCreateMouseEvent(null, $.kCGEventLeftMouseDown, position, $.kCGMouseButtonLeft)
    up = $.CGEventCreateMouseEvent(null, $.kCGEventLeftMouseUp, position, $.kCGMouseButtonLeft)

    $.CGEventPost($.kCGSessionEventTap, down)
    $.CGEventPost($.kCGSessionEventTap, up)

    $.CGEventSetIntegerValueField(down, $.kCGMouseEventClickState, 2)
    $.CGEventSetIntegerValueField(up, $.kCGMouseEventClickState, 2)

    $.CGEventPost($.kCGSessionEventTap, down)
    $.CGEventPost($.kCGSessionEventTap, up)

    $.CGEventSetIntegerValueField(down, $.kCGMouseEventClickState, 3)
    $.CGEventSetIntegerValueField(up, $.kCGMouseEventClickState, 3)

    $.CGEventPost($.kCGSessionEventTap, down)
    $.CGEventPost($.kCGSessionEventTap, up)
    @delay(@clickDelayRequired())

  rightClick: (position) ->
    emit 'notUndoable'
    position ?= @getMousePosition()
    down = $.CGEventCreateMouseEvent(null, $.kCGEventRightMouseDown, position, $.kCGMouseButtonRight)
    up = $.CGEventCreateMouseEvent(null, $.kCGEventRightMouseUp, position, $.kCGMouseButtonRight)
    $.CGEventPost($.kCGSessionEventTap, down)
    $.CGEventPost($.kCGSessionEventTap, up)
    @delay(@clickDelayRequired())

  rightClickAtPosition: (pos) ->
    @moveMouseAndReturn pos, (position) =>
      @rightClick(position)

  shiftClick: (position) ->
    emit 'notUndoable'
    position ?= @getMousePosition()
    down = $.CGEventCreateMouseEvent(null, $.kCGEventLeftMouseDown, position, $.kCGMouseButtonLeft)
    up = $.CGEventCreateMouseEvent(null, $.kCGEventLeftMouseUp, position, $.kCGMouseButtonLeft)

    mask = @_modifierMask(["shift"])
    $.CGEventSetFlags(down, mask)
    $.CGEventSetFlags(up, mask)

    @keyDown "shift"
    $.CGEventPost($.kCGSessionEventTap, down)
    $.CGEventPost($.kCGSessionEventTap, up)
    @keyUp "shift"
    @delay(@clickDelayRequired())

  shiftClickAtPosition: (pos) ->
    @moveMouseAndReturn pos, (position) =>
      @shiftClick(position)


  commandClick: (position) ->
    emit 'notUndoable'
    position ?= @getMousePosition()
    down = $.CGEventCreateMouseEvent(null, $.kCGEventLeftMouseDown, position, $.kCGMouseButtonLeft)
    up = $.CGEventCreateMouseEvent(null, $.kCGEventLeftMouseUp, position, $.kCGMouseButtonLeft)

    mask = @_modifierMask(["command"])
    $.CGEventSetFlags(down, mask)
    $.CGEventSetFlags(up, mask)

    @keyDown "command"
    $.CGEventPost($.kCGSessionEventTap, down)
    $.CGEventPost($.kCGSessionEventTap, up)
    @keyUp "command"
    @delay(@clickDelayRequired())

  commandClickAtPosition: (pos) ->
    @moveMouseAndReturn pos, (position) =>
      @commandClick(position)

  optionClick: ->
    emit 'notUndoable'
    position = @getMousePosition()
    down = $.CGEventCreateMouseEvent(null, $.kCGEventLeftMouseDown, position, $.kCGMouseButtonLeft)
    up = $.CGEventCreateMouseEvent(null, $.kCGEventLeftMouseUp, position, $.kCGMouseButtonLeft)

    mask = @_modifierMask(["option"])
    $.CGEventSetFlags(down, mask)
    $.CGEventSetFlags(up, mask)

    @keyDown "option"
    $.CGEventPost($.kCGSessionEventTap, down)
    $.CGEventPost($.kCGSessionEventTap, up)
    @keyUp "option"
    @delay(@clickDelayRequired())

  getScreenInfo: ->
    screens = $.NSScreen('screens')
    count = screens('count') or 1
    i = 0
    mainScreen = screens('objectAtIndex', 0)('visibleFrame')
    results = []
    while i < count
      s = screens('objectAtIndex', i)('visibleFrame')
      results.push
        origin:
          x: s.origin.x
          y: mainScreen.size.height - s.origin.y - s.size.height
        size:
          width: s.size.width
          height: s.size.height
      i++

    frame = $.NSScreen('mainScreen')('visibleFrame')

    final =
      screens: results
      currentFrame:
        origin:
          x: frame.origin.x
          y: mainScreen.size.height - frame.origin.y - frame.size.height
        size:
          width: frame.size.width
          height: frame.size.height

  positionMouse: (x, y, screenIndex) ->
    emit 'notUndoable'
    position = @getMousePosition()
    if screenIndex?
      screen = @getScreenInfo().screens[screenIndex - 1]
    # find current screen
    else
      for s in @getScreenInfo().screens
        if position.x > s.origin.x and
        position.x < (s.origin.x + s.size.width) and
        position.y > s.origin.y and
        position.y < (s.origin.y + s.size.height)
          screen = s


    if screen
      offsetX = if x <= 1
        screen.size.width * x
      else
        x

      offsetY = if y <= 1
        screen.size.height * y
      else
        y

      newOriginX = screen.origin.x + offsetX
      newOriginY = screen.origin.y + offsetY

      event = $.CGEventCreateMouseEvent null, $.kCGEventMouseMoved, $.CGPointMake(newOriginX, newOriginY), 0
      $.CGEventPost($.kCGSessionEventTap, event)


  applescript: (content, shouldReturn=true) ->
    emit 'notUndoable'
    Applescript content, shouldReturn

  exec: (script, options = null) ->
    options ?= {silent: true}
    Execute script, options

  openMenuBarItem: (item) ->
    emit 'notUndoable'
    @applescript """
    tell application "System Events" to tell (process 1 where frontmost is true)
      click menu bar item "#{item}" of menu bar 1
    end tell
    """

  openMenuBarPath: (itemArray) ->
    emit 'notUndoable'
    elements = _.map itemArray.reverse(), (item, index) ->
      if index is 0
        "click menu item \"#{item}\""
      else if index != (itemArray.length - 1)
        "of menu \"#{item}\" of menu item \"#{item}\""
      else
        "of menu \"#{item}\" of menu bar item \"#{item}\" of menu bar 1"
    script = """
    tell application "System Events" to tell (process 1 where frontmost is true)
      #{elements.join(" ")}
    end tell
    """
    @applescript script

  scrollDown: (amount) ->
    emit 'notUndoable'
    event = $.CGEventCreateScrollWheelEvent(null, $.kCGScrollEventUnitLine, 1, -1 * (amount or 1))
    $.CGEventPost($.kCGHIDEventTap, event)

  scrollUp: (amount) ->
    emit 'notUndoable'
    event = $.CGEventCreateScrollWheelEvent(null, $.kCGScrollEventUnitLine, 1, (amount or 1))
    $.CGEventPost($.kCGHIDEventTap, event)

  scrollLeft: (amount) ->
    emit 'notUndoable'
    event = $.CGEventCreateScrollWheelEvent(null, $.kCGScrollEventUnitLine, 2, 0, (amount or 1))
    $.CGEventPost($.kCGHIDEventTap, event)

  scrollRight: (amount) ->
    emit 'notUndoable'
    event = $.CGEventCreateScrollWheelEvent(null, $.kCGScrollEventUnitLine, 2, 0, -1 * (amount or 1))
    $.CGEventPost($.kCGHIDEventTap, event)

  openApplication: (name) ->
    emit 'notUndoable'
    if name in Settings.applicationsThatNeedLaunchingWithApplescript
      @applescript "tell application \"#{name}\" to activate"
    else
      string = $.NSString('stringWithUTF8String', name)
      w = $.NSWorkspace('sharedWorkspace')
      w('launchApplication', string)

  openBrowser: ->
    emit 'notUndoable'
    defaultBrowser = Settings.defaultBrowser or "Safari"
    @openApplication(defaultBrowser)

  openURL: (url) ->
    emit 'notUndoable'
    string = $.NSString('stringWithUTF8String', url)
    u = $.NSURL('URLWithString', string)
    w = $.NSWorkspace('sharedWorkspace')
    w('openURL', u)

  microphoneOff: ->
    @applescript """
    tell application id "com.dragon.dictate"
      set listening to false
    end tell
    """, false

  currentApplication: ->
    if @_currentApplication
      @_currentApplication
    else
      w = $.NSWorkspace('sharedWorkspace')
      app = w('frontmostApplication')
      result = app('localizedName').toString()
      @_currentApplication = {name: result}

  _getCurrentBrowserUrl: (cb) ->
    container = mutate 'getCurrentBrowserUrl', {url: null}
    container.url

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

  transformSelectedText: (transform) ->
    switch @currentApplication().name
      when "Atom"
        @runAtomCommand "transformSelectedText", transform, true
      else
        if @isTextSelected()
          contents = @getSelectedText()
          transformed = SelectionTransformer[transform](contents)
          @string transformed

  revealFinderDirectory: (directory) ->
    emit 'notUndoable'
    w = $.NSWorkspace('sharedWorkspace')
    d = $.NSString('stringWithUTF8String', directory)
    # finder = $.NSString('stringWithUTF8String', "Finder")
    w('openFile', d('stringByStandardizingPath'))
    # w('openFile', d, 'withApplication', finder)

  setVolume: (volume) ->
    if volume >= 0 and volume <= 100
      @applescript """
      set volume output volume #{volume}
      """

  getCurrentVolume: ->
    volume = @applescript """
    output volume of (get volume settings)
    """
    if volume?.length
      parseInt volume
    else
      undefined

  clickServiceItem: (item) ->
    emit 'notUndoable'
    @applescript """
    tell application "System Events" to tell (process 1 where frontmost is true)
      click menu item "#{item}" of menu "Services" of menu item "Services" of menu 1 of menu bar item 2 of menu bar 1
    end tell
    delay 1
    """

  isTextSelected: ->
    result = @applescript """
    tell application "System Events" to tell (process 1 where frontmost is true)
      set selectionExists to (enabled of first menu item of (menu 1 of menu bar item 4 of menu bar 1) ¬
          where (value of attribute "AXMenuItemCmdChar" is "C") ¬
          and (value of attribute "AXMenuItemCmdModifiers" is 0))
    end tell
    return selectionExists
    """
    (result is "true")
  # something:
  #   AXUIElementRef systemWideElement = AXUIElementCreateSystemWide();
  #   AXUIElementRef focussedElement = NULL;
  #   AXError error = AXUIElementCopyAttributeValue(systemWideElement, kAXFocusedUIElementAttribute, (CFTypeRef *)&focussedElement);
  #   if (error != kAXErrorSuccess) {
  #       NSLog(@"Could not get focussed element");
  #   } else {
  #       AXValueRef selectedRangeValue = NULL;
  #       AXError getSelectedRangeError = AXUIElementCopyAttributeValue(focussedElement, kAXSelectedTextRangeAttribute, (CFTypeRef *)&selectedRangeValue);
  #       if (getSelectedRangeError == kAXErrorSuccess) {
  #           CFRange selectedRange;
  #           AXValueGetValue(selectedRangeValue, kAXValueCFRangeType, &selectedRange);
  #           AXValueRef selectionBoundsValue = NULL;
  #           AXError getSelectionBoundsError = AXUIElementCopyParameterizedAttributeValue(focussedElement, kAXBoundsForRangeParameterizedAttribute, selectedRangeValue, (CFTypeRef *)&selectionBoundsValue);
  #           CFRelease(selectedRangeValue);
  #           if (getSelectionBoundsError == kAXErrorSuccess) {
  #               CGRect selectionBounds;
  #               AXValueGetValue(selectionBoundsValue, kAXValueCGRectType, &selectionBounds);
  #               NSLog(@"Selection bounds: %@", NSStringFromRect(NSRectFromCGRect(selectionBounds)));
  #           } else {
  #               NSLog(@"Could not get bounds for selected range");
  #           }
  #           if (selectionBoundsValue != NULL) CFRelease(selectionBoundsValue);
  #       } else {
  #           NSLog(@"Could not get selected range");
  #       }
  #   }
  #   if (focussedElement != NULL) CFRelease(focussedElement);
  #   CFRelease(systemWideElement);

  getClipboard: ->
    # @applescript("return the clipboard as text")
    p = $.NSPasteboard('generalPasteboard')
    # item = p('pasteboardItems')('objectAtIndex', 0)
    item = p('stringForType', $('public.utf8-plain-text'))
    if item
      item.toString()
    else
      ""
  setClipboard: (text) ->
    if text.length
      p = $.NSPasteboard('generalPasteboard')
      types = $.NSMutableArray('alloc')('init')
      types('addObject', $('public.utf8-plain-text'))
      p('declareTypes', types, 'owner', null)
      p('setString', $(text), 'forType', $('public.utf8-plain-text'))

  getSelectedText: ->
    old = @getClipboard()
    @copy()
    @waitForClipboard()
    result = @getClipboard()
    @setClipboard(old)
    result

  waitForClipboard: ->
    delay = Settings.clipboardLatency[@currentApplication().name] or 200
    @delay delay

  canDetermineSelections: ->
    not _.includes(Settings.applicationsThatCanNotHandleBlankSelections, @currentApplication().name)

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

  notify: (text) ->
    Notify(text)

  checkBundleExistence: do ->
    cache = {global: true}
    (bundleId) ->
      return cache[bundleId] if cache[bundleId]?
      cache[bundleId] = eval Applescript """
      try
        tell application "Finder" to get application file id \"#{bundleId}\"
        return true
      on error
        return false
      end try
      """

  paste: (content) ->
    if content?.length
      @pasteContent content
    else
      super

  pasteContent: (content) ->
    old = @getClipboard()
    @setClipboard content
    @paste()
    @delay 300
    @setClipboard old

module.exports = new DarwinActions
