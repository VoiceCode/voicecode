pack = Packages.register
  name: 'mouse'
  description: 'Mouse control: clicking, moving, etc.'

pack.commands
  'double-click':
    spoken: 'duke'
    description: 'double click'
    tags: ['recommended']
    mouseLatency: true
    action: (input, context) ->
      if context.mouseLatencyIndex
        @doubleClickAtPosition @previousMouseLocation(context.mouseLatencyIndex + 1)
      else
        @doubleClick()
  'right-click':
    spoken: 'chipper'
    description: 'right click'
    tags: ['recommended']
    mouseLatency: true
    action: (input, context) ->
      if context.mouseLatencyIndex
        @rightClickAtPosition @previousMouseLocation(context.mouseLatencyIndex + 1)
      else
        @rightClick()
  'click':
    spoken: 'chiff'
    description: 'left click'
    tags: ['recommended']
    mouseLatency: true
    action: (input, context) ->
      if context.mouseLatencyIndex
        @clickAtPosition @previousMouseLocation(context.mouseLatencyIndex + 1)
      else
        @click()
  'click-previous-position':
    spoken: 'chaffin'
    description: 'Latency compensated left click. "mouseDwellTracking" needs to be enabled for this to work.
      This allows you to click then move the mouse, and have it still perform the click where the mouse used to be. Only works well with a regular mouse or trackpad (not SmartNav)'
    tags: ['dwelling']
    action: ->
      current = @getMousePosition()
      previous = @previousMouseLocation(1)

      # if mouse stopped moving already, look backwards 2 spots, else it's still moving, so only look back 1 spot
      if current.x is previous.x and current.y is previous.y
        previous = @previousMouseLocation(2)

      @clickAtPosition previous

  'triple-click':
    spoken: 'triplick'
    description: 'left click'
    tags: ['recommended']
    action: ->
      @tripleClick()
  'shift-click':
    spoken: 'shicks'
    description: 'shift+click'
    tags: ['recommended']
    misspellings: ['chicks']
    mouseLatency: true
    action: (input, context) ->
      if context.mouseLatencyIndex
        @shiftClickAtPosition @previousMouseLocation(context.mouseLatencyIndex + 1)
      else
        @shiftClick()
  'command-click':
    spoken: 'chom lick'
    description: 'command+click'
    tags: []
    mouseLatency: true
    action: (input, context) ->
      if context.mouseLatencyIndex
        @commandClickAtPosition @previousMouseLocation(context.mouseLatencyIndex + 1)
      else
        @commandClick()
  'option-click':
    spoken: 'crop lick'
    description: 'option+click'
    tags: []
    action: ->
      @optionClick()
  'press':
    spoken: 'pretzel'
    description: 'press down mouse and hold'
    tags: []
    action: ->
      @mouseDown()
  'release':
    spoken: 'relish'
    description: 'release the mouse after press and hold'
    tags: []
    action: ->
      @mouseUp()
  'dwelling-on':
    spoken: 'dwelling on'
    description: 'turn on "dwell clicking" - whenever the mouse stops moving it will do a left click. "mouseDwellTracking" needs to be enabled for this to work'
    tags: ['dwelling']
    action: ->
      @enableDwellClicking()
  'dwelling-off':
    spoken: 'dwelling off'
    description: 'turn off "dwell clicking"'
    tags: ['dwelling']
    action: ->
      @disableDwellClicking()
  'dwelling-once':
    spoken: 'griffin'
    description: 'makes it so the mouse will click next time it pauses (dwells) - this makes it faster to click sometimes because it eliminates the latency. You would use it when you already know you are going to click but the mouse is still moving toward its destination'
    tags: ['dwelling']
    action: ->
      @dwellClickOnce()
  'store-position':
    spoken: 'store mouse position'
    description: 'store current mouse position to the clipboard, so that you can paste it elsewhere. If an argument is spoken, it stores to the named clipboard'
    tags: ['clipboard', 'snippet']
    grammarType: 'textCapture'
    continuous: false
    action: (input) ->
      position = @getMousePosition()
      flattened = "x: #{position.x}, y: #{position.y}"
      @setClipboard flattened
      if input?.length
        @storeItem 'clipboard', input.join(' '), flattened
  'relocate':
    spoken: 'mousy'
    grammarType: 'integerCapture'
    description: """moves the mouse by grid coordinates
      [1-9] => grid on current monitor;
      10 => center of monitor 1;
      20 => center of monitor 2;
      [11-19] => grid on monitor 1;
      [21-29] => grid on monitor 2"""
    tags: ['smartnav']
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
