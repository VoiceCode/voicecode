Actions = require '../base/actions'

class DarwinActions extends Actions
  constructor: ->
    super
    @keys = require './keyCodes'
  setCurrentApplication: (application) ->
    super
    if @inBrowser()
      @monitorBrowserUrl(true)
    else
      @monitorBrowserUrl(false)

  inBrowser: ->
    @_currentApplication in Settings.browserApplications

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

  key: (key, modifiers) ->
    key = key.toString().toLowerCase()

    @notUndoable()
    code = @keys.keyCodes[key]
    if code?
      @_pressKey(code, @_normalizeModifiers(modifiers))
      @delay Settings.keyDelay or 8
    else
      code = @keys.keyCodesShift[key]
      if code?
        mods = _.unique((modifiers or []).concat("shift"))
        @_pressKey code, @_normalizeModifiers(mods)
        @delay Settings.keyDelay or 8

  string: (string) ->
    string = string.toString()
    if string?.length
      if @_capturingText
        @_capturedText += string
      else
        @setUndoByDeleting string.length
        for item in string.split('')
          @delay Settings.characterDelay or 4
          code = @keys.keyCodesRegular[item]
          if code?
            @_pressKey code
          else
            code = @keys.keyCodesShift[item]
            if code?
              @_pressKey code, ["shift"]
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
    _.contains Settings.applicationsThatNeedExplicitModifierPresses, @currentApplication()

  contextAllowsArrowKeyTextSelection: ->
    not _.contains(Settings.applicationsThatWillNotAllowArrowKeyTextSelection, @currentApplication())

  clickDelayRequired: ->
    Settings.clickDelayRequired[@currentApplication()] or Settings.clickDelayRequired["default"] or 0

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
    @notUndoable()
    position ?= @getMousePosition()
    down = $.CGEventCreateMouseEvent(null, $.kCGEventLeftMouseDown, position, $.kCGMouseButtonLeft)
    $.CGEventPost($.kCGSessionEventTap, down)

  mouseUp: (position) ->
    @notUndoable()
    position ?= @getMousePosition()
    up = $.CGEventCreateMouseEvent(null, $.kCGEventLeftMouseUp, position, $.kCGMouseButtonLeft)
    $.CGEventPost($.kCGSessionEventTap, up)

  previousMouseLocation: (index) ->
    mouseTracker.previousLocation(index or 0)

  click: (position) ->
    @notUndoable()
    position ?= @getMousePosition()
    @mouseDown(position)
    @mouseUp(position)
    @delay(@clickDelayRequired())

  clickAtPosition: (pos) ->
    console.log "clicking at", pos
    @moveMouseAndReturn pos, (position) =>
      @click(position)

  doubleClick: (position) ->
    @notUndoable()
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
    @notUndoable()
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
    @notUndoable()
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
    @notUndoable()
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
    @notUndoable()
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
    @notUndoable()
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
    @notUndoable()
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
    @notUndoable()
    Applescript content, shouldReturn

  exec: (script, options = null) ->
    options ?= {silent: true}
    Execute script, options

  runAtomCommand: (name, options) ->
    info =
      command: name
      options: options

    escaped = JSON.stringify(info).replace(/\\/g, '\\\\').replace(/"/g, '\\"')
    command = """echo "#{escaped}" | nc -U /tmp/voicecode-atom.sock"""
    debug command
    @exec command

  openMenuBarItem: (item) ->
    @notUndoable()
    @applescript """
    tell application "System Events" to tell (process 1 where frontmost is true)
      click menu bar item "#{item}" of menu bar 1
    end tell
    """

  openMenuBarPath: (itemArray) ->
    @notUndoable()
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
    @notUndoable()
    event = $.CGEventCreateScrollWheelEvent(null, $.kCGScrollEventUnitLine, 1, -1 * (amount or 1))
    $.CGEventPost($.kCGHIDEventTap, event)

  scrollUp: (amount) ->
    @notUndoable()
    event = $.CGEventCreateScrollWheelEvent(null, $.kCGScrollEventUnitLine, 1, (amount or 1))
    $.CGEventPost($.kCGHIDEventTap, event)

  scrollLeft: (amount) ->
    @notUndoable()
    event = $.CGEventCreateScrollWheelEvent(null, $.kCGScrollEventUnitLine, 2, 0, (amount or 1))
    $.CGEventPost($.kCGHIDEventTap, event)

  scrollRight: (amount) ->
    @notUndoable()
    event = $.CGEventCreateScrollWheelEvent(null, $.kCGScrollEventUnitLine, 2, 0, -1 * (amount or 1))
    $.CGEventPost($.kCGHIDEventTap, event)

  openApplication: (name) ->
    @notUndoable()
    if name in Settings.applicationsThatNeedLaunchingWithApplescript
      @applescript "tell application \"#{name}\" to activate"
    else
      string = $.NSString('stringWithUTF8String', name)
      w = $.NSWorkspace('sharedWorkspace')
      w('launchApplication', string)

  openBrowser: ->
    @notUndoable()
    defaultBrowser = Settings.defaultBrowser or "Safari"
    @openApplication(defaultBrowser)

  openURL: (url) ->
    @notUndoable()
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
      @_currentApplication = result

  _getCurrentBrowserUrl: (cb) ->
    container = mutate 'getCurrentBrowserUrl', {url: null}
    container.url

  currentBrowserUrl: ({reset} = {reset: false}) ->
    if reset or !@_currentBrowserUrl?
      # refresh in bg
      @_getCurrentBrowserUrl (code, url) =>
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
    switch @currentApplication()
      when "Atom"
        @runAtomCommand "transformSelectedText", transform
      else
        if @isTextSelected()
          contents = @getSelectedText()
          transformed = SelectionTransformer[transform](contents)
          @string transformed

  revealFinderDirectory: (directory) ->
    @notUndoable()
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
    @notUndoable()
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
    delay = Settings.clipboardLatency[@currentApplication()] or 200
    @delay delay

  canDetermineSelections: ->
    not _.contains(Settings.applicationsThatCanNotHandleBlankSelections, @currentApplication())

  verticalSelectionExpansion: (number) ->
    @notUndoable()
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

  symmetricSelectionExpansion: (number) ->
    @notUndoable()
    @copy()
    @delay 100
    clipboard = @getClipboard()
    length = clipboard?.length or 0
    @left()
    @left number
    @repeat number * 2 + length, =>
      @key 'right', 'shift'

  selectCurrentOccurrence: (input) ->
    @notUndoable()
    if input?.length
      first = input[0]
      last = input[1]
      @key 'left', 'command'
      @key 'right', 'command shift'
      clipboard = @getSelectedText().toLowerCase()
      if last?.length and clipboard.indexOf(last) >= 0 and clipboard.indexOf(first) >= 0
        totalLength = clipboard?.length
        firstResults = clipboard.split(first)
        distanceLeft = firstResults[0]?.length or 0
        lastResults = clipboard.split(last)
        distanceRight = lastResults[lastResults.length - 1]?.length or 0
        @left()
        @right distanceLeft

        width = totalLength - distanceLeft - distanceRight
        @repeat width, =>
          @key 'right', 'shift'
      else if clipboard.indexOf(first) >= 0
        totalLength = clipboard?.length
        firstResults = clipboard.split(first)
        distanceLeft = firstResults[0]?.length or 0
        @left()
        @right distanceLeft

        width = first.length
        @repeat width, =>
          @key 'right', 'shift'
  selectPreviousOccurrence: (input) ->
    @notUndoable()
    if input?.length
      first = input[0]
      last = input[1]
      @left()
      @right()
      @repeat 20, => @key 'up', 'shift'
      clipboard = @getSelectedText().toLowerCase()
      if last?.length and clipboard.indexOf(last) >= 0 and clipboard.indexOf(first) >= 0
        totalLength = clipboard?.length
        firstResults = clipboard.split(first)
        distanceLeft = firstResults[0]?.length or 0
        lastResults = clipboard.split(last)
        distanceRight = lastResults[lastResults.length - 1]?.length or 0
        @right()
        @left(distanceRight)

        width = distanceLeft - first.length - distanceRight
        @repeat width, =>
          @key 'left', 'shift'
      else if clipboard.indexOf(first) >= 0
        totalLength = clipboard?.length
        firstResults = clipboard.split(first)
        distanceRight = firstResults[firstResults.length - 1]?.length or 0
        @right()
        @left(distanceRight)
        width = first.length
        _(width).times =>
          @key 'left', 'shift'
      else
        @right()
  selectNextOccurrence: (input) ->
    @notUndoable()
    if input?.length
      first = input[0]
      last = input[1]
      @right()
      @left()
      _(20).times => @key 'down', 'shift'
      clipboard = @getSelectedText().toLowerCase()
      if last?.length and clipboard.indexOf(last) >= 0 and clipboard.indexOf(first) >= 0
        totalLength = clipboard?.length
        firstResults = clipboard.split(first)
        distanceLeft = firstResults[0]?.length or 0
        lastResults = clipboard.split(last)
        distanceRight = lastResults[lastResults.length - 1]?.length or 0
        @left()
        @right(distanceLeft)

        width = totalLength - distanceLeft - distanceRight
        _(width).times =>
          @key 'right', 'shift'
      else if clipboard.indexOf(first) >= 0
        firstResults = clipboard.split(first)
        distanceLeft = firstResults[0]?.length or 0
        @left()
        @right(distanceLeft)

        width = first.length
        _(width).times =>
          @key 'right', 'shift'
      else
        @left()

  selectNextOccurrenceWithDistance: (phrase, distance) ->
    @notUndoable()
    if phrase?.length
      distance = (distance or 1)
      @left()
      @right()
      _(20).times => @key 'down', 'shift'
      selected = @getSelectedText().toLowerCase()
      if selected.indexOf(phrase) >= 0
        results = selected.split(phrase)
        distanceLeft = results.splice(0, distance).join(phrase).length
        @left()
        @right(distanceLeft)
        width = phrase.length
        _(width).times =>
          @key 'right', 'shift'
      else
        @left()

  selectPreviousOccurrenceWithDistance: (phrase, distance) ->
    @notUndoable()
    if phrase?.length
      distance = (distance or 1)
      @right()
      @left()
      _(20).times => @key 'up', 'shift'
      selected = @getSelectedText().toLowerCase()
      if selected.indexOf(phrase) >= 0
        results = selected.split(phrase).reverse()
        distanceLeft = results.splice(0, distance).join(phrase).length
        @right()
        @left(distanceLeft)
        width = phrase.length
        _(width).times =>
          @key 'left', 'shift'
      else
        @right()

  extendSelectionToFollowingOccurrenceWithDistance: (phrase, distance) ->
    @notUndoable()
    if phrase?.length
      if @canDetermineSelections() and @isTextSelected()
        existing = @getSelectedText()
      distance = (distance or 1)
      _(20).times => @key 'down', 'shift'
      selected = @getSelectedText().toLowerCase()
      @left()
      if existing? and selected.indexOf(existing) is 0
        selected = selected.slice(existing.length)
        _(existing.length).times =>
          @key 'right', 'shift'
      if selected.indexOf(phrase) >= 0
        results = selected.split(phrase)
        distanceLeft = results.splice(0, distance).join(phrase).length
        _(distanceLeft).times =>
          @key 'right', 'shift'
        width = phrase.length
        _(width).times =>
          @key 'right', 'shift'

  extendSelectionToPreviousOccurrenceWithDistance: (phrase, distance) ->
    @notUndoable()
    if phrase?.length
      if @canDetermineSelections() and @isTextSelected()
        existing = @getSelectedText()
      distance = (distance or 1)
      _(20).times => @key 'up', 'shift'
      selected = @getSelectedText().toLowerCase()
      @right()
      if existing? and selected.indexOf(existing) is (selected.length - existing.length)
        selected = selected.slice(0, selected.length - existing.length)
        _(existing.length).times =>
          @key 'left', 'shift'
      if selected.indexOf(phrase) >= 0
        results = selected.split(phrase).reverse()
        distanceLeft = results.splice(0, distance).join(phrase).length
        _(distanceLeft).times =>
          @key 'left', 'shift'
        width = phrase.length
        _(width).times =>
          @key 'left', 'shift'


  ###
  @params object
    @input integer
    @expression regex
    @direction integer: +1 or -1
    @splitterExpression regex: when to start a new match inside a contiguous match
  ###

  selectContiguousMatching: (params) ->
    distance = (parseInt(params.input) or 1) - 1
    expression = params.expression or /\w/
    direction = params.direction or 1
    splitterExpression = params.splitterExpression

    if direction > 0
      horizontalForward = 'right'
      horizontalBackward = 'left'
      verticalForward = 'down'
    else
      horizontalForward = 'left'
      horizontalBackward = 'right'
      verticalForward = 'up'

    @notUndoable()

    if @canDetermineSelections() and @isTextSelected()
      @key horizontalForward

    @key verticalForward, 'shift'
    @key verticalForward, 'shift'
    @key horizontalForward, 'shift command'

    selection = if direction > 0
      @getSelectedText()
    else
      _s.reverse @getSelectedText()

    results = []
    start = undefined
    selecting = false
    for item, index in selection.split('')
      if item.match(expression)
        if splitterExpression? and item.match(splitterExpression)
          if selecting
            results.push [start, index]
            results.push [index, index + 1]
            selecting = false
            start = undefined
          else
            results.push [index, index + 1]
        else
          selecting = true
          start ?= index
      else
        if selecting
          results.push [start, index]
          selecting = false
          start = undefined

    @key horizontalBackward

    if results[distance]?
      span = results[distance][1] - results[distance][0]
      _(results[distance][0]).times =>
        @key horizontalForward
      _(span).times =>
        @key horizontalForward, 'shift'


  selectSurroundedOccurrence: (params) ->
    distance = (parseInt(params.input) or 1) - 1
    expression = params.expression
    return unless expression?.length

    direction = params.direction or 1

    if direction > 0
      horizontalForward = 'right'
      horizontalBackward = 'left'
      verticalForward = 'down'
    else
      horizontalForward = 'left'
      horizontalBackward = 'right'
      verticalForward = 'up'

    @notUndoable()

    if @canDetermineSelections() and @isTextSelected()
      @key horizontalForward

    @key verticalForward, 'shift'
    @key verticalForward, 'shift'
    @key verticalForward, 'shift'
    @key verticalForward, 'shift'
    @key horizontalForward, 'shift command'

    selection = if direction > 0
      @getSelectedText()
    else
      _s.reverse @getSelectedText()

    if direction is 1
      first = expression[0]
      last = expression[expression.length - 1]
    else
      last = expression[0]
      first = expression[expression.length - 1]

    results = []
    start = undefined
    selecting = false
    canStart = true
    candidate = null
    for item, index in selection.split('')
      if item is first and not selecting and canStart
        start = index
        selecting = true
        canStart = false
      else if item is last and selecting and start != index
        candidate = [start, index + 1]
      else if item.match(/\w/)
        canStart = false
        candidate = null
      else
        if selecting and candidate
          results.push candidate
        start = null
        candidate = null
        selecting = false
        canStart = true

    @key horizontalBackward

    if results[distance]?
      span = results[distance][1] - results[distance][0]
      _(results[distance][0]).times =>
        @key horizontalForward
      _(span).times =>
        @key horizontalForward, 'shift'


  selectBlock: ->
    @notUndoable()
    clipboard = if @canDetermineSelections() and @isTextSelected()
      @getSelectedText()
    else
      ""
    match = clipboard.match(/\r/g)
    numberOfLines = (match?.length or 0) + 1
    if clipboard.charAt(clipboard.length - 1).match(/\r/)
      numberOfLines -= 1
    @key 'left', 'command'
    _(numberOfLines).times => @key 'down', 'shift'

    # return some info in case someone wants to do something with it
    {
      height: numberOfLines
    }

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
module.exports = new DarwinActions
