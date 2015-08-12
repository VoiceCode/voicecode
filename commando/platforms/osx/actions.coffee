class Platforms.osx.actions extends Platforms.base.actions
  setCurrentApplication: (application) ->
    super
    if @inBrowser()
      @currentBrowserUrl(reset: true)
      console.log @currentBrowserUrl()
      
  inBrowser: ->
    @_currentApplication in ["Safari", "Google Chrome"]

  key: (key, modifiers) ->
    key = key.toString()

    @notUndoable()
    code = Platforms.osx.keyCodes[key]
    if code?
      @_pressKey(code, @_normalizeModifiers(modifiers))
      Meteor.sleep(10)
    else
      code = Platforms.osx.keyCodesShift[key]
      if code?
        mods = _.unique((modifiers or []).concat("shift"))
        @_pressKey code, @_normalizeModifiers(mods)
        Meteor.sleep(10)

  string: (string) ->
    string = string.toString()
    if string?.length
      if @_capturingText
        @_capturedText += string
      else
        @setUndoByDeleting string.length
        for item in string.split('')
          Meteor.sleep(4)
          code = Platforms.osx.keyCodesRegular[item]
          if code?
            @_pressKey code
          else
            code = Platforms.osx.keyCodesShift[item]
            if code?
              @_pressKey code, ["Shift"]
  keyDown: (key, modifiers) ->
    code = Platforms.osx.keyCodes[key]
    if code?
      @_keyDown code, @_normalizeModifiers(modifiers)
  keyUp: (key, modifiers) ->
    code = Platforms.osx.keyCodes[key]
    if code?
      @_keyUp code, @_normalizeModifiers(modifiers)

  _keyDown: (key, modifiers) ->
    # console.log
    #   keydown: key
    #   modifiers: modifiers
    e = $.CGEventCreateKeyboardEvent(null, key, true)
    if modifiers?.length
      $.CGEventSetFlags(e, @_modifierMask(modifiers))
    else
      $.CGEventSetFlags(e, 0)
    $.CGEventPost($.kCGSessionEventTap, e)

  _keyUp: (key, modifiers) ->
    # console.log
    #   keyup: key
    #   modifiers: modifiers
    e = $.CGEventCreateKeyboardEvent(null, key, false)
    if modifiers
      $.CGEventSetFlags(e, @_modifierMask(modifiers))
    else
      $.CGEventSetFlags(e, 0)
    $.CGEventPost($.kCGSessionEventTap, e)

  _modifierMask: (modifiers) ->
    mask = 0
    for m in modifiers
      bits = switch m
        when "Shift"
          $.kCGEventFlagMaskShift
        when "Command"
          $.kCGEventFlagMaskCommand
        when "Option"
          $.kCGEventFlagMaskAlternate
        when "Control"
          $.kCGEventFlagMaskControl
      mask = mask | bits
    mask

  needsExplicitModifierPresses: ->
    _.contains Settings.applicationsThatNeedExplicitModifierPresses, @currentApplication()

  clickDelayRequired: ->
    Settings.clickDelayRequired[@currentApplication()] or Settings.clickDelayRequired["default"] or 0

  _pressKey: (key, modifiers) ->
    if modifiers? and @needsExplicitModifierPresses()
      for m in modifiers
        @_keyDown Platforms.osx.keyCodes[m], [m]

    @_keyDown key, modifiers
    @_keyUp key #, modifiers

    if modifiers? and @needsExplicitModifierPresses()
      for m in modifiers
        @_keyUp Platforms.osx.keyCodes[m] #, [m]

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

  click: ->
    @notUndoable()
    # position = $.NSEvent('mouseLocation')
    position = @getMousePosition()
    # console.log position
    @mouseDown(position)
    @mouseUp(position)
    @delay(@clickDelayRequired())

  clickLocation: (pos) ->
    current = @getMousePosition()

    position = if pos?
      $.CGPointMake(pos.x, pos.y)
    else
      @getMousePosition()

    @mouseDown(position)
    @mouseUp(position)
    @delay(@clickDelayRequired())

    # move the mouse back
    event = $.CGEventCreateMouseEvent null, $.kCGEventMouseMoved, current, 0
    $.CGEventPost($.kCGSessionEventTap, event)


  doubleClick: ->
    @notUndoable()
    position = @getMousePosition()
    down = $.CGEventCreateMouseEvent(null, $.kCGEventLeftMouseDown, position, $.kCGMouseButtonLeft)
    up = $.CGEventCreateMouseEvent(null, $.kCGEventLeftMouseUp, position, $.kCGMouseButtonLeft)
    $.CGEventPost($.kCGSessionEventTap, down)
    $.CGEventPost($.kCGSessionEventTap, up)
    $.CGEventSetIntegerValueField(down, $.kCGMouseEventClickState, 2)
    $.CGEventPost($.kCGSessionEventTap, down)
    $.CGEventSetIntegerValueField(up, $.kCGMouseEventClickState, 2)
    $.CGEventPost($.kCGSessionEventTap, up)
    @delay(@clickDelayRequired())

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

  rightClick: ->
    @notUndoable()
    position = @getMousePosition()
    down = $.CGEventCreateMouseEvent(null, $.kCGEventRightMouseDown, position, $.kCGMouseButtonRight)
    up = $.CGEventCreateMouseEvent(null, $.kCGEventRightMouseUp, position, $.kCGMouseButtonRight)
    $.CGEventPost($.kCGSessionEventTap, down)
    $.CGEventPost($.kCGSessionEventTap, up)
    @delay(@clickDelayRequired())

  shiftClick: ->
    @notUndoable()
    position = @getMousePosition()
    down = $.CGEventCreateMouseEvent(null, $.kCGEventLeftMouseDown, position, $.kCGMouseButtonLeft)
    up = $.CGEventCreateMouseEvent(null, $.kCGEventLeftMouseUp, position, $.kCGMouseButtonLeft)

    mask = @_modifierMask(["Shift"])
    $.CGEventSetFlags(down, mask)
    $.CGEventSetFlags(up, mask)

    @keyDown "Shift"
    $.CGEventPost($.kCGSessionEventTap, down)
    $.CGEventPost($.kCGSessionEventTap, up)
    @keyUp "Shift"
    @delay(@clickDelayRequired())

  commandClick: ->
    @notUndoable()
    position = @getMousePosition()
    down = $.CGEventCreateMouseEvent(null, $.kCGEventLeftMouseDown, position, $.kCGMouseButtonLeft)
    up = $.CGEventCreateMouseEvent(null, $.kCGEventLeftMouseUp, position, $.kCGMouseButtonLeft)

    mask = @_modifierMask(["Command"])
    $.CGEventSetFlags(down, mask)
    $.CGEventSetFlags(up, mask)

    @keyDown "Command"
    $.CGEventPost($.kCGSessionEventTap, down)
    $.CGEventPost($.kCGSessionEventTap, up)
    @keyUp "Command"
    @delay(@clickDelayRequired())

  optionClick: ->
    @notUndoable()
    position = @getMousePosition()
    down = $.CGEventCreateMouseEvent(null, $.kCGEventLeftMouseDown, position, $.kCGMouseButtonLeft)
    up = $.CGEventCreateMouseEvent(null, $.kCGEventLeftMouseUp, position, $.kCGMouseButtonLeft)

    mask = @_modifierMask(["Option"])
    $.CGEventSetFlags(down, mask)
    $.CGEventSetFlags(up, mask)

    @keyDown "Option"
    $.CGEventPost($.kCGSessionEventTap, down)
    $.CGEventPost($.kCGSessionEventTap, up)
    @keyUp "Option"
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
        if position.x > s.origin.x and position.x < (s.origin.x + s.size.width) and position.y > s.origin.y and position.y < (s.origin.y + s.size.height)
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
    script = $.NSAppleScript('alloc')('initWithSource', $(content))
    results = script('executeAndReturnError', null)
    if shouldReturn
      results('stringValue')?.toString()
    else
      null

  exec: (script) ->
    Execute script

  runAtomCommand: (name, options) ->
    info =
      command: name
      options: options

    escaped = JSON.stringify(info).replace(/\\/g, '\\\\').replace(/"/g, '\\"')
    command = """echo "#{escaped}" | nc -U /tmp/voicecode-atom.sock"""
    console.log command
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

  currentApplication: ->
    if @_currentApplication
      console.log @_currentApplication
      @_currentApplication
    else
      w = $.NSWorkspace('sharedWorkspace')
      app = w('frontmostApplication')
      # app = w('menuBarOwningApplication')
      result = app('localizedName').toString()
      @_currentApplication = result
      console.log result
      result

  _getCurrentBrowserUrl: ->
    switch @currentApplication()
      when "Google Chrome"
        @applescript 'tell application "Google Chrome" to get URL of active tab of first window'
      when "Safari"
        @applescript 'tell application "Safari" to return URL of front document as string'

  currentBrowserUrl: ({reset} = {reset: false}) ->
    if reset or !@_currentBrowserUrl?
      @_getCurrentBrowserUrl()
    else
      @_currentBrowserUrl

  transformSelectedText: (transform) ->
    console.log "transform selected text"
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
    @key "C", ['command']
    @waitForClipboard()
    result = @getClipboard()
    @setClipboard(old)
    # console.log
    #   oldClipboard: old
    #   newClipboard: result
    result

  waitForClipboard: ->
    delay = Settings.clipboardLatency[@currentApplication()] or 200
    @delay delay

  canDetermineSelections: ->
    not _.contains(Settings.applicationsThatCanNotHandleBlankSelections, @currentApplication())

  verticalSelectionExpansion: (number) ->
    @notUndoable()
    @key "C", ["command"]
    @delay 100
    clipboard = @getClipboard()
    console.log clipboard
    numberOfLines = clipboard.split("\r").length
    console.log numberOfLines
    _(number).times => @key "Up"
    _(numberOfLines + (number * 2) - 1).times => @key "Down", ['shift']

  symmetricSelectionExpansion: (number) ->
    @notUndoable()
    @key "C", ["command"]
    @delay 100
    clipboard = @getClipboard()
    length = clipboard?.length or 0
    @key "Left"
    _(number).times =>
      @key "Left"
    _(number * 2 + length).times =>
      @key "Right", ["shift"]

  selectCurrentOccurrence: (input) ->
    @notUndoable()
    if input?.length
      first = input[0]
      last = input[1]
      @key "Left", ['command']
      @key "Right", ['command', 'shift']
      clipboard = @getSelectedText().toLowerCase()
      if last?.length and clipboard.indexOf(last) >= 0 and clipboard.indexOf(first) >= 0
        totalLength = clipboard?.length
        firstResults = clipboard.split(first)
        distanceLeft = firstResults[0]?.length or 0
        lastResults = clipboard.split(last)
        distanceRight = lastResults[lastResults.length - 1]?.length or 0
        @key "Left"
        _(distanceLeft).times =>
          @key "Right"

        width = totalLength - distanceLeft - distanceRight
        _(width).times =>
          @key "Right", ['shift']
      else if clipboard.indexOf(first) >= 0
        totalLength = clipboard?.length
        firstResults = clipboard.split(first)
        distanceLeft = firstResults[0]?.length or 0
        @key "Left"
        _(distanceLeft).times =>
          @key "Right"

        width = first.length
        _(width).times =>
          @key "Right", ['shift']
  selectPreviousOccurrence: (input) ->
    @notUndoable()
    if input?.length
      first = input[0]
      last = input[1]
      @key "Left"
      @key "Right"
      _(20).times => @key "Up", ['shift']
      clipboard = @getSelectedText().toLowerCase()
      if last?.length and clipboard.indexOf(last) >= 0 and clipboard.indexOf(first) >= 0
        totalLength = clipboard?.length
        firstResults = clipboard.split(first)
        distanceLeft = firstResults[0]?.length or 0
        lastResults = clipboard.split(last)
        distanceRight = lastResults[lastResults.length - 1]?.length or 0
        @key "Right"
        _(distanceRight).times =>
          @key "Left"

        width = distanceLeft - first.length - distanceRight
        _(width).times =>
          @key "Left", ['shift']
      else if clipboard.indexOf(first) >= 0
        totalLength = clipboard?.length
        firstResults = clipboard.split(first)
        distanceRight = firstResults[firstResults.length - 1]?.length or 0
        @key "Right"
        _(distanceRight).times =>
          @key "Left"

        width = first.length
        _(width).times =>
          @key "Left", ['shift']
      else
        @key "Right"
  selectNextOccurrence: (input) ->
    @notUndoable()
    if input?.length
      first = input[0]
      last = input[1]
      @key "Right"
      @key "Left"
      _(20).times => @key "Down", ['shift']
      clipboard = @getSelectedText().toLowerCase()
      if last?.length and clipboard.indexOf(last) >= 0 and clipboard.indexOf(first) >= 0
        totalLength = clipboard?.length
        firstResults = clipboard.split(first)
        distanceLeft = firstResults[0]?.length or 0
        lastResults = clipboard.split(last)
        distanceRight = lastResults[lastResults.length - 1]?.length or 0
        @key "Left"
        _(distanceLeft).times =>
          @key "Right"

        width = totalLength - distanceLeft - distanceRight
        _(width).times =>
          @key "Right", ['shift']
      else if clipboard.indexOf(first) >= 0
        firstResults = clipboard.split(first)
        distanceLeft = firstResults[0]?.length or 0
        @key "Left"
        _(distanceLeft).times =>
          @key "Right"

        width = first.length
        _(width).times =>
          @key "Right", ['shift']
      else
        @key "Left"

  selectNextOccurrenceWithDistance: (phrase, distance) ->
    @notUndoable()
    if phrase?.length
      distance = (distance or 1)
      @key "Left"
      @key "Right"
      _(20).times => @key "Down", ['shift']
      selected = @getSelectedText().toLowerCase()
      if selected.indexOf(phrase) >= 0
        results = selected.split(phrase)
        distanceLeft = results.splice(0, distance).join(phrase).length
        @key "Left"
        _(distanceLeft).times =>
          @key "Right"
        width = phrase.length
        _(width).times =>
          @key "Right", ['shift']

  selectPreviousOccurrenceWithDistance: (phrase, distance) ->
    @notUndoable()
    if phrase?.length
      distance = (distance or 1)
      @key "Right"
      @key "Left"
      _(20).times => @key "Up", ['shift']
      selected = @getSelectedText().toLowerCase()
      if selected.indexOf(phrase) >= 0
        results = selected.split(phrase).reverse()
        distanceLeft = results.splice(0, distance).join(phrase).length
        @key "Right"
        _(distanceLeft).times =>
          @key "Left"
        width = phrase.length
        _(width).times =>
          @key "Left", ['shift']

  extendSelectionToFollowingOccurrenceWithDistance: (phrase, distance) ->
    @notUndoable()
    if phrase?.length
      if @canDetermineSelections() and @isTextSelected()
        existing = @getSelectedText()
      distance = (distance or 1)
      _(20).times => @key "Down", ['shift']
      selected = @getSelectedText().toLowerCase()
      @key "Left"
      if existing? and selected.indexOf(existing) is 0
        selected = selected.slice(existing.length)
        _(existing.length).times =>
          @key "Right", ['shift']
      if selected.indexOf(phrase) >= 0
        results = selected.split(phrase)
        distanceLeft = results.splice(0, distance).join(phrase).length
        _(distanceLeft).times =>
          @key "Right", ['shift']
        width = phrase.length
        _(width).times =>
          @key "Right", ['shift']

  extendSelectionToPreviousOccurrenceWithDistance: (phrase, distance) ->
    @notUndoable()
    if phrase?.length
      if @canDetermineSelections() and @isTextSelected()
        existing = @getSelectedText()
      distance = (distance or 1)
      _(20).times => @key "Up", ['shift']
      selected = @getSelectedText().toLowerCase()
      @key "Right"
      if existing? and selected.indexOf(existing) is (selected.length - existing.length)
        selected = selected.slice(0, selected.length - existing.length)
        _(existing.length).times =>
          @key "Left", ['shift']
      if selected.indexOf(phrase) >= 0
        results = selected.split(phrase).reverse()
        distanceLeft = results.splice(0, distance).join(phrase).length
        _(distanceLeft).times =>
          @key "Left", ['shift']
        width = phrase.length
        _(width).times =>
          @key "Left", ['shift']


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
      horizontalForward = "Right"
      horizontalBackward = "Left"
      verticalForward = "Down"
    else
      horizontalForward = "Left"
      horizontalBackward = "Right"
      verticalForward = "Up"

    @notUndoable()

    if @canDetermineSelections() and @isTextSelected()
      @key horizontalForward

    @key verticalForward, ['shift']
    @key verticalForward, ['shift']
    @key horizontalForward, ['shift', 'command']

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
        @key horizontalForward, ['shift']


  selectSurroundedOccurrence: (params) ->
    distance = (parseInt(params.input) or 1) - 1
    expression = params.expression
    return unless expression?.length

    direction = params.direction or 1

    if direction > 0
      horizontalForward = "Right"
      horizontalBackward = "Left"
      verticalForward = "Down"
    else
      horizontalForward = "Left"
      horizontalBackward = "Right"
      verticalForward = "Up"

    @notUndoable()

    if @canDetermineSelections() and @isTextSelected()
      @key horizontalForward

    @key verticalForward, ['shift']
    @key verticalForward, ['shift']
    @key verticalForward, ['shift']
    @key verticalForward, ['shift']
    @key horizontalForward, ['shift', 'command']

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

    console.log results: results

    if results[distance]?
      span = results[distance][1] - results[distance][0]
      _(results[distance][0]).times =>
        @key horizontalForward
      _(span).times =>
        @key horizontalForward, ['shift']


  selectBlock: ->
    @notUndoable()
    clipboard = if @canDetermineSelections() and @isTextSelected()
      @getSelectedText()
    else
      ""
    match = clipboard.match(/\r/g)
    console.log match
    numberOfLines = (match?.length or 0) + 1
    if clipboard.charAt(clipboard.length - 1).match(/\r/)
      numberOfLines -= 1
    @key "Left", ['command']
    _(numberOfLines).times => @key "Down", ['shift']

    # return some info in case someone wants to do something with it
    {
      height: numberOfLines
    }

  deletePartialWord: (direction) ->
    distance = 1
    if direction is "right"
      @key 'Right', 'command shift'
    else
      @key 'Left', 'command shift'
    content = @getSelectedText()
    console.log content: content
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
    console.log chosen: chosenComponents
    characters = chosenComponents.join('').length + spacePadding
    if direction is "right"
      @key 'Left'
    else
      @key 'Right'
    if characters > 0
      for index in [1..characters]
        if direction is "right"
          @key 'Right', 'shift'
        else
          @key 'Left', 'shift'
      @key 'Delete'

  notify: (text) ->
    Notify(text)
