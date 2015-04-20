
class OSX.Actions
  constructor: () ->
    # @shift = $.kCGEventFlagMaskShift
    # @command = $.kCGEventFlagMaskCommand
    # @option = $.kCGEventFlagMaskOption
    # @control = $.kCGEventFlagMaskControl
  setUndoByDeleting: (amount) ->
    Commands.currentUndoByDeletingCount = amount
  notUndoable: ->
    Commands.currentUndoByDeletingCount = 0
  undoByDeleting: ->
    amount = Commands.previousUndoByDeletingCount or 0
    _.times(amount) =>
      @key "Delete"

  key: (key, modifiers) ->
    @notUndoable()
    code = OSX.keyCodes[key]
    if code?
      @_pressKey(code, @_normalizeModifiers(modifiers))
      Meteor.sleep(10)
    else
      code = OSX.keyCodesShift[key]
      if code?
        @_pressKey code, ["Shift"]
        Meteor.sleep(10)

  string: (string) ->
    if string?.length
      @setUndoByDeleting string.length
      _.each string.split(''), (item) =>
        Meteor.sleep(4)
        code = OSX.keyCodesRegular[item]
        if code?
          @_pressKey code
        else
          code = OSX.keyCodesShift[item]
          if code?
            @_pressKey code, ["Shift"]
  keyDown: (key, modifiers) ->
    code = OSX.keyCodes[key]
    if code?
      @_keyDown code, @_normalizeModifiers(modifiers)
  keyUp: (key, modifiers) ->
    code = OSX.keyCodes[key]
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
    _.each modifiers, (m) =>
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

  _pressKey: (key, modifiers) ->
    if modifiers? and @needsExplicitModifierPresses()
      _.each modifiers, (m) =>
        @_keyDown OSX.keyCodes[m], [m]
        # @delay(10)

    @_keyDown key, modifiers
    @_keyUp key #, modifiers

    if modifiers? and @needsExplicitModifierPresses()
      _.each modifiers, (m) =>
        # @delay(10)
        @_keyUp OSX.keyCodes[m] #, [m]

  _normalizeModifiers: (modifiers) ->
    if modifiers?.length
      # titleize mods
      _.map modifiers, (m) ->
        m.charAt(0).toUpperCase() + m.slice(1)

  mouseDown: (position) ->    
    @notUndoable()
    position ?= $.CGEventGetLocation($.CGEventCreate(null))
    down = $.CGEventCreateMouseEvent(null, $.kCGEventLeftMouseDown, position, $.kCGMouseButtonLeft)
    $.CGEventPost($.kCGSessionEventTap, down)

  mouseUp: (position) ->    
    @notUndoable()
    position ?= $.CGEventGetLocation($.CGEventCreate(null))
    up = $.CGEventCreateMouseEvent(null, $.kCGEventLeftMouseUp, position, $.kCGMouseButtonLeft)
    $.CGEventPost($.kCGSessionEventTap, up)

  click: ->    
    @notUndoable()
    # position = $.NSEvent('mouseLocation')
    position = $.CGEventGetLocation($.CGEventCreate(null))
    # console.log position
    @mouseDown(position)
    @mouseUp(position)

  doubleClick: ->
    @notUndoable()
    position = $.CGEventGetLocation($.CGEventCreate(null))
    down = $.CGEventCreateMouseEvent(null, $.kCGEventLeftMouseDown, position, $.kCGMouseButtonLeft)
    up = $.CGEventCreateMouseEvent(null, $.kCGEventLeftMouseUp, position, $.kCGMouseButtonLeft)
    $.CGEventPost($.kCGSessionEventTap, down)
    # Meteor.sleep(30)
    $.CGEventPost($.kCGSessionEventTap, up)
    # Meteor.sleep(30)
    $.CGEventSetIntegerValueField(down, $.kCGMouseEventClickState, 2)
    $.CGEventPost($.kCGSessionEventTap, down)
    # Meteor.sleep(30)
    $.CGEventSetIntegerValueField(up, $.kCGMouseEventClickState, 2)
    $.CGEventPost($.kCGSessionEventTap, up)

  tripleClick: ->
    @notUndoable()
    position = $.CGEventGetLocation($.CGEventCreate(null))
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
  
  rightClick: ->    
    @notUndoable()
    position = $.CGEventGetLocation($.CGEventCreate(null))
    down = $.CGEventCreateMouseEvent(null, $.kCGEventRightMouseDown, position, $.kCGMouseButtonRight)
    up = $.CGEventCreateMouseEvent(null, $.kCGEventRightMouseUp, position, $.kCGMouseButtonRight)
    $.CGEventPost($.kCGSessionEventTap, down)
    $.CGEventPost($.kCGSessionEventTap, up)

  shiftClick: ->    
    @notUndoable()
    position = $.CGEventGetLocation($.CGEventCreate(null))
    down = $.CGEventCreateMouseEvent(null, $.kCGEventLeftMouseDown, position, $.kCGMouseButtonLeft)
    up = $.CGEventCreateMouseEvent(null, $.kCGEventLeftMouseUp, position, $.kCGMouseButtonLeft)

    mask = @_modifierMask(["Shift"])
    $.CGEventSetFlags(down, mask)
    $.CGEventSetFlags(up, mask)

    @keyDown "Shift"
    $.CGEventPost($.kCGSessionEventTap, down)
    $.CGEventPost($.kCGSessionEventTap, up)
    @keyUp "Shift"

  commandClick: ->    
    @notUndoable()
    position = $.CGEventGetLocation($.CGEventCreate(null))
    down = $.CGEventCreateMouseEvent(null, $.kCGEventLeftMouseDown, position, $.kCGMouseButtonLeft)
    up = $.CGEventCreateMouseEvent(null, $.kCGEventLeftMouseUp, position, $.kCGMouseButtonLeft)

    mask = @_modifierMask(["Command"])
    $.CGEventSetFlags(down, mask)
    $.CGEventSetFlags(up, mask)

    @keyDown "Command"
    $.CGEventPost($.kCGSessionEventTap, down)
    $.CGEventPost($.kCGSessionEventTap, up)
    @keyUp "Command"

  optionClick: ->    
    @notUndoable()
    position = $.CGEventGetLocation($.CGEventCreate(null))
    down = $.CGEventCreateMouseEvent(null, $.kCGEventLeftMouseDown, position, $.kCGMouseButtonLeft)
    up = $.CGEventCreateMouseEvent(null, $.kCGEventLeftMouseUp, position, $.kCGMouseButtonLeft)

    mask = @_modifierMask(["Option"])
    $.CGEventSetFlags(down, mask)
    $.CGEventSetFlags(up, mask)

    @keyDown "Option"
    $.CGEventPost($.kCGSessionEventTap, down)
    $.CGEventPost($.kCGSessionEventTap, up)
    @keyUp "Option"

  positionMouse: (x, y) ->
    @notUndoable()
    screen = @getScreenInfo()
    # console.log screen
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

  delay: (ms) ->
    Meteor.sleep(ms)

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

    # result = @applescript """
    # tell application "System Events"
    #   set currentApplication to name of first application process whose frontmost is true
    # end tell
    # return currentApplication
    # """
    # console.log result
    # result
  setCurrentApplication: (application) ->
    @_currentApplication = application
  setGlobalMode: (context) ->
    Commands.mode = mode

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
    @applescript("return the clipboard as text")

  getSelectedText: ->
    @key "C", ['command']
    @delay 150
    @getClipboard()

  canDetermineSelections: ->
    not _.contains(Settings.applicationsThatCanNotHandleBlankSelections, @currentApplication())

  getScreenInfo: ->
    frame = $.NSScreen('mainScreen')('visibleFrame')
    result =
      origin: 
        x: frame.origin.x
        y: frame.origin.y
      size: 
        width: frame.size.width
        height: frame.size.height

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
      if last?.length
        @key "Left", ['command']
        @key "Right", ['command', 'shift']
        @key "C", ['command']
        @delay 100
        clipboard = @getClipboard().toLowerCase()
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
      else
        @key "Left", ['command']
        @key "Right", ['command', 'shift']
        @key "C", ['command']
        @delay 100
        clipboard = @getClipboard().toLowerCase()
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
      @key "C", ['command']
      @delay 100
      clipboard = @getClipboard().toLowerCase()
      if last?.length
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
      else
        clipboard = @getClipboard().toLowerCase()
        totalLength = clipboard?.length
        firstResults = clipboard.split(first)
        distanceRight = firstResults[firstResults.length - 1]?.length or 0
        @key "Right"
        _(distanceRight).times => 
          @key "Left"

        width = first.length
        _(width).times => 
          @key "Left", ['shift']
  selectFollowingOccurrence: (input) ->
    @notUndoable()
    if input?.length
      first = input[0]
      last = input[1]
      @key "Right"
      @key "Left"
      _(20).times => @key "Down", ['shift']
      @key "C", ['command']
      @delay 100
      clipboard = @getClipboard().toLowerCase()
      if last?.length
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
      else
        clipboard = @getClipboard().toLowerCase()
        firstResults = clipboard.split(first)
        distanceLeft = firstResults[0]?.length or 0
        @key "Left"
        _(distanceLeft).times => 
          @key "Right"

        width = first.length
        _(width).times => 
          @key "Right", ['shift']

  selectPreviousWord: (input) ->
    @notUndoable()
    distance = (parseInt(input) or 1) - 1
    if @canDetermineSelections() and @isTextSelected()
      @key "Left"
    @key "Up", ["shift"]
    @key "Up", ["shift"]
    @key "Left", ['shift', 'command']
    t = _s.reverse @getSelectedText()
    results = []
    start = undefined
    selecting = false
    expression = /\w/
    _.each t.split(''), (item, index) =>
      if item.match(expression)
        selecting = true
        start ?= index
      else
        if selecting
          results.push [start, index]
          selecting = false
          start = undefined
          
    @key "Right"
    if results[distance]?
      span = results[distance][1] - results[distance][0]
      _(results[distance][0]).times =>
        @key "Left"
      _(span).times =>
        @key "Left", ['shift']

  selectFollowingWord: (input) ->
    @notUndoable()
    distance = (parseInt(input) or 1) - 1
    if @canDetermineSelections() and @isTextSelected()
      @key "Right"
    @key "Down", ['shift']
    @key "Down", ['shift']
    @key "Right", ['shift', 'command']
    t = @getSelectedText()
    results = []
    start = undefined
    selecting = false
    expression = /\w/
    _.each t.split(''), (item, index) =>
      if item.match(expression)
        selecting = true
        start ?= index
      else
        if selecting
          results.push [start, index]
          selecting = false
          start = undefined

    @key "Left"
    console.log results
    if results[distance]?
      span = results[distance][1] - results[distance][0]
    # match = t.match(expression)
    # item = match[distance] or match[distance - 1]
    # if item?
      # index = t.indexOf(item)
      _(results[distance][0]).times =>
        @key "Right"
      _(span).times =>
        @key "Right", ['shift']

