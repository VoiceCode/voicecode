class @MouseTracker
  constructor: () ->
    @frequency = Settings.mouseTrackerFrequency or 120
    @dwellings = []
    @lastFixedPoint = {x: 0, y: 0}
    @potential = false
    @trailingDistance = 0
  start: ->
    @interval = Meteor.setInterval =>
      @sample()
    , @frequency
    @
  sample: ->
    current = Actions.getMousePosition()
    x = current.x
    y = current.y
    # console.log x, y

    previous = @lastFixedPoint
    distance = Math.sqrt(Math.pow(x - previous.x, 2) + Math.pow(y - previous.y, 2))
    # console.log "distance", distance

    if distance is 0 and @trailingDistance is 0

      if @potential
        # adding new dwelling
        @dwellings.unshift
          x: x
          y: y
          time: Date.now()
        Actions.onDwell(@dwellings[0])
        if Settings.debugMouseDwellTracking
          console.log "Dwelling: ", @dwellings[0]
        # only keep a few spots
        @dwellings.splice(10)
        @potential = false
      else        
        # not adding a new dwelling, self update the most recent with the current position
        @dwellings[0] =
          x: x
          y: y
          time: Date.now()
    else
      @potential = true
      @lastFixedPoint = {x: x, y: y}
    @trailingDistance = distance

  previousLocation: (index = 1) ->
    if @dwellings.length
      @dwellings[index - 1]





