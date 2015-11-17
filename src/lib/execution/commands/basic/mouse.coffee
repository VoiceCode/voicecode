Commands.createDisabled
  'mouse.doubleClick':
    spoken: 'duke'
    description: 'double click'
    tags: ['mouse', 'recommended']
    mouseLatency: true
    action: (input, context) ->
      if context.mouseLatencyIndex
        @doubleClickAtPosition @previousMouseLocation(context.mouseLatencyIndex + 1)
      else
        @doubleClick()
  'mouse.rightClick':
    spoken: 'chipper'
    description: 'right click'
    tags: ['mouse', 'recommended']
    mouseLatency: true
    action: (input, context) ->
      if context.mouseLatencyIndex
        @rightClickAtPosition @previousMouseLocation(context.mouseLatencyIndex + 1)
      else
        @rightClick()
  'mouse.click':
    spoken: 'chiff'
    description: 'left click'
    tags: ['mouse', 'recommended']
    mouseLatency: true
    action: (input, context) ->
      if context.mouseLatencyIndex
        @clickAtPosition @previousMouseLocation(context.mouseLatencyIndex + 1)
      else
        @click()
  'mouse.previousPosition.click':
    spoken: 'chaffin'
    description: 'Latency compensated left click. "mouseDwellTracking" needs to be enabled for this to work.
      This allows you to click then move the mouse, and have it still perform the click where the mouse used to be. Only works well with a regular mouse or trackpad (not SmartNav)'
    tags: ['mouse', 'dwelling']
    action: ->
      current = @getMousePosition()
      previous = @previousMouseLocation(1)

      # if mouse stopped moving already, look backwards 2 spots, else it's still moving, so only look back 1 spot
      if current.x is previous.x and current.y is previous.y
        previous = @previousMouseLocation(2)

      @clickAtPosition previous

  'mouse.tripleClick':
    spoken: 'triplick'
    description: 'left click'
    tags: ['mouse', 'recommended']
    action: ->
      @tripleClick()
  'mouse.shiftClick':
    spoken: 'shicks'
    description: 'shift+click'
    tags: ['mouse', 'recommended']
    misspellings: ['chicks']
    mouseLatency: true
    action: (input, context) ->
      if context.mouseLatencyIndex
        @shiftClickAtPosition @previousMouseLocation(context.mouseLatencyIndex + 1)
      else
        @shiftClick()
  'mouse.commandClick':
    spoken: 'chom lick'
    description: 'command+click'
    tags: ['mouse']
    vocabulary: true
    mouseLatency: true
    action: (input, context) ->
      if context.mouseLatencyIndex
        @commandClickAtPosition @previousMouseLocation(context.mouseLatencyIndex + 1)
      else
        @commandClick()
  'mouse.optionClick':
    spoken: 'crop lick'
    description: 'option+click'
    tags: ['mouse']
    vocabulary: true
    action: ->
      @optionClick()
  'mouse.press':
    spoken: 'pretzel'
    description: 'press down mouse and hold'
    tags: ['mouse']
    action: ->
      @mouseDown()
  'mouse.release':
    spoken: 'relish'
    description: 'release the mouse after press and hold'
    tags: ['mouse']
    action: ->
      @mouseUp()
  'mouse.dwelling.on':
    spoken: 'dwelling on'
    description: 'turn on "dwell clicking" - whenever the mouse stops moving it will do a left click. "mouseDwellTracking" needs to be enabled for this to work'
    tags: ['mouse', 'dwelling']
    action: ->
      @enableDwellClicking()
  'mouse.dwelling.off':
    spoken: 'dwelling off'
    description: 'turn off "dwell clicking"'
    tags: ['mouse', 'dwelling']
    action: ->
      @disableDwellClicking()
  'mouse.dwelling.once':
    spoken: 'griffin'
    description: 'makes it so the mouse will click next time it pauses (dwells) - this makes it faster to click sometimes because it eliminates the latency. You would use it when you already know you are going to click but the mouse is still moving toward its destination'
    tags: ['mouse', 'dwelling']
    action: ->
      @dwellClickOnce()
  'mouse.position.store':
    spoken: 'store mouse position'
    description: 'store current mouse position to the clipboard, so that you can paste it elsewhere. If an argument is spoken, it stores to the named clipboard'
    tags: ['clipboard', 'mouse', 'snippet']
    grammarType: 'textCapture'
    continuous: false
    inputRequired: false
    action: (input) ->
      position = @getMousePosition()
      flattened = "x: #{position.x}, y: #{position.y}"
      @setClipboard flattened
      if input?.length
        @storeItem 'clipboard', input.join(' '), flattened
  'mouse.relocate':
    spoken: 'mousy'
    grammarType: 'integerCapture'
    description: """moves the mouse by grid coordinates
      [1-9] => grid on current monitor;
      10 => center of monitor 1;
      20 => center of monitor 2;
      [11-19] => grid on monitor 1;
      [21-29] => grid on monitor 2"""
    tags: ['smartnav', 'mouse']
    inputRequired: true
    action: (input) ->
      quadrants = [
        [0.5, 0.5]
        [0.2, 0.2]
        [0.5, 0.2]
        [0.8, 0.2]
        [0.2, 0.5]
        [0.5, 0.5]
        [0.8, 0.5]
        [0.2, 0.8]
        [0.5, 0.8]
        [0.8, 0.8]
      ]
      screen = undefined
      quadrant = 0
      if input?
        # current monitor
        if input < 10
          quadrant = input
        # monitor number 1
        else if input is 10
          screen = 1
        else if input < 20
          screen = 1
          quadrant = input % 10
        # monitor number 2
        else if input is 20
          screen = 2
        else if input < 30
          screen = 2
          quadrant = input % 10
        # monitor number 3
        else if input is 30
          screen = 3
        else if input < 30
          screen = 3
          quadrant = input % 10

      @positionMouse quadrants[quadrant][0], quadrants[quadrant][1], screen
