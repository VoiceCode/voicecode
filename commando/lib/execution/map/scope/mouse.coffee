Commands.createDisabled
  'mousy':
    grammarType: 'numberCapture'
    description: """moves the mouse by grid coordinates
      [1-9] => grid on current monitor;
      10 => center of monitor 1;
      20 => center of monitor 2;
      [11-19] => grid on monitor 1;
      [21-29] => grid on monitor 2"""
    tags: ['smartnav', 'mouse']
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
