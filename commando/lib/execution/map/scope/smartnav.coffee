Commands.createDisabled
  "mousy":
    description: "center the mouse in the middle of the screen (requires smartnav)"
    tags: ["smartnav", "mouse"]
    action: (input) ->
      @positionMouse(0.5, 0.5)