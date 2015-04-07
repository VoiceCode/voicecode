
class OSX.Actions
  constructor: () ->
    # @shift = $.kCGEventFlagMaskShift
    # @command = $.kCGEventFlagMaskCommand
    # @option = $.kCGEventFlagMaskOption
    # @control = $.kCGEventFlagMaskControl
  key: (key, modifiers) ->
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
      _.each string.split(''), (item) =>
        Meteor.sleep(6)
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
    console.log "keydown: #{key}"
    e = $.CGEventCreateKeyboardEvent(null, key, true)
    if modifiers
      $.CGEventSetFlags(e, @_modifierMask(modifiers))
    $.CGEventPost($.kCGSessionEventTap, e)

  _keyUp: (key, modifiers) ->
    # console.log "keyup: #{key}, #{modifier}"
    e = $.CGEventCreateKeyboardEvent(null, key, false)
    if modifiers
      $.CGEventSetFlags(e, @_modifierMask(modifiers))
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


  _pressKey: (key, modifiers) ->
    if modifiers?
      _.each modifiers, (m) =>
        Meteor.sleep(4)
        @keyDown m
        Meteor.sleep(4)

    @_keyDown(key, modifiers)
    @_keyUp(key, modifiers)

    if modifiers?
      _.each modifiers, (m) =>
        Meteor.sleep(4)
        @keyUp m
        Meteor.sleep(8)

  _normalizeModifiers: (modifiers) ->
    if modifiers?.length
      # titleize mods
      _.map modifiers, (m) ->
        m.charAt(0).toUpperCase() + m.slice(1)

  click: ->    
    # position = $.NSEvent('mouseLocation')
    position = $.CGEventGetLocation($.CGEventCreate(null))
    # console.log position
    down = $.CGEventCreateMouseEvent(null, $.kCGEventLeftMouseDown, position, $.kCGMouseButtonLeft)
    up = $.CGEventCreateMouseEvent(null, $.kCGEventLeftMouseUp, position, $.kCGMouseButtonLeft)
    $.CGEventPost($.kCGSessionEventTap, down)
    # Meteor.sleep(30)
    $.CGEventPost($.kCGSessionEventTap, up)

  doubleClick: ->
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
    position = $.CGEventGetLocation($.CGEventCreate(null))
    down = $.CGEventCreateMouseEvent(null, $.kCGEventRightMouseDown, position, $.kCGMouseButtonRight)
    up = $.CGEventCreateMouseEvent(null, $.kCGEventRightMouseUp, position, $.kCGMouseButtonRight)
    $.CGEventPost($.kCGSessionEventTap, down)
    $.CGEventPost($.kCGSessionEventTap, up)

  shiftClick: ->    
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

  applescript: (content) ->
    script = $.NSAppleScript('alloc')('initWithSource', $(content))
    results = script('executeAndReturnError', null)
    results

  openMenuBarItem: (item) ->
    @applescript """
    tell application "System Events" to tell (process 1 where frontmost is true)
      click menu bar item "#{item}" of menu bar 1
    end tell
    """

  scrollUp: (amount) ->
    event = $.CGEventCreateScrollWheelEvent(null, $.kCGScrollEventUnitLine, 1, -1)
    $.CGEventPost($.kCGHIDEventTap, event)

  openApplication: (name) ->
    string = $.NSString('stringWithUTF8String', name)
    w = $.NSWorkspace('sharedWorkspace')
    w('launchApplication', string)

  openBrowser: ->
    defaultBrowser = CommandoSettings.defaultBrowser or "Safari"    
    @openApplication(defaultBrowser)

  openURL: (url) ->
    string = $.NSString('stringWithUTF8String', url)
    u = $.NSURL('URLWithString', string)
    w = $.NSWorkspace('sharedWorkspace')
    w('openURL', u)

  delay: (ms) ->
    Meteor.sleep(ms)

  currentApplication: ->
    w = $.NSWorkspace('sharedWorkspace')
    # app = w('frontmostApplication')
    app = w('menuBarOwningApplication')
    result = app('localizedName').toString()
    console.log result
    result

  setGlobalContext: (context) ->
    Commands.context = context

  revealFinderDirectory: (directory) ->
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
    @applescript """
    tell application "System Events" to tell (process 1 where frontmost is true)
      click menu item "#{item}" of menu "Services" of menu item "Services" of menu 1 of menu bar item 2 of menu bar 1
    end tell
    delay 1
    """

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
    @applescript("return the clipboard as text")('stringValue').toString()

  verticalSelectionExpansion: (number) ->
    @key "C", ["command"]
    @delay 100
    clipboard = @getClipboard()
    console.log clipboard
    numberOfLines = clipboard.split("\r").length
    console.log numberOfLines
    _(number).times => @key "Up"
    _(numberOfLines + (number * 2) - 1).times => @key "Down", ['shift']
