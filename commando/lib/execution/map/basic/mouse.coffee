Commands.createDisabled
  "duke":
    description: "double click"
    tags: ["mouse", "recommended"]
    mouseLatency: true
    action: (input, context) ->
      if context.mouseLatencyIndex
        @doubleClickAtPosition @previousMouseLocation(context.mouseLatencyIndex + 1)
      else
        @doubleClick()
  "chipper":
    description: "right click"
    tags: ["mouse", "recommended"]
    mouseLatency: true
    action: (input, context) ->
      if context.mouseLatencyIndex
        @rightClickAtPosition @previousMouseLocation(context.mouseLatencyIndex + 1)
      else
        @rightClick()
  "chiff":
    description: "left click"
    tags: ["mouse", "recommended"]
    mouseLatency: true
    action: (input, context) ->
      if context.mouseLatencyIndex
        @clickAtPosition @previousMouseLocation(context.mouseLatencyIndex + 1)
      else
        @click()
  "chaffin":
    description: "Latency compensated left click. 'mouseDwellTracking' needs to be enabled for this to work.
      This allows you to click then move the mouse, and have it still perform the click where the mouse used to be. Only works well with a regular mouse or trackpad (not SmartNav)"
    tags: ["mouse", "dwelling"]
    action: ->
      current = @getMousePosition()
      previous = @previousMouseLocation(1)

      # if mouse stopped moving already, look backwards 2 spots, else it's still moving, so only look back 1 spot
      if current.x is previous.x and current.y is previous.y
        previous = @previousMouseLocation(2)

      @clickAtPosition previous
      
  "triplick":
    description: "left click"
    tags: ["mouse", "recommended"]
    action: ->
      @tripleClick()
  "shicks":
    description: "shift+click"
    tags: ["mouse", "recommended"]
    aliases: ["chicks"]
    mouseLatency: true
    action: (input, context) ->
      if context.mouseLatencyIndex
        @shiftClickAtPosition @previousMouseLocation(context.mouseLatencyIndex + 1)
      else
        @shiftClick()
  "chom lick":
    description: "command+click"
    tags: ["mouse"]
    vocabulary: true
    mouseLatency: true
    action: (input, context) ->
      if context.mouseLatencyIndex
        @commandClickAtPosition @previousMouseLocation(context.mouseLatencyIndex + 1)
      else
        @commandClick()
  "crop lick":
    description: "option+click"
    tags: ["mouse"]
    vocabulary: true
    action: ->
      @optionClick()
  "pretzel":
    description: "press down mouse and hold"
    tags: ["mouse"]
    action: ->
      @mouseDown()
  "relish":
    description: "release the mouse after press and hold"
    tags: ["mouse"]
    action: ->
      @mouseUp()
  "dwelling on":
    description: "turn on 'dwell clicking' - whenever the mouse stops moving it will do a left click. 'mouseDwellTracking' needs to be enabled for this to work"
    tags: ["mouse", "dwelling"]
    action: ->
      @enableDwellClicking()
  "dwelling off":
    description: "turn off 'dwell clicking'"
    tags: ["mouse", "dwelling"]
    action: ->
      @disableDwellClicking()
  "griffin":
    description: "makes it so the mouse will click next time it pauses (dwells) - this makes it faster to click sometimes because it eliminates the latency. You would use it when you already know you are going to click but the mouse is still moving toward its destination"
    tags: ["mouse", "dwelling"]
    action: ->
      @dwellClickOnce()    
