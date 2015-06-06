Commands.createDisabled
  "goneck":
    description: "go to next thing (application-specific), tab, message, etc."
    tags: ["recommended", "navigation"]
    repeatable: true
    action: ->
      switch @currentApplication()
        when "Skype"
          @key "Right", 'command option'
        else
          @key "]", 'command shift'
  "gopreev":
    description: "go to previous thing (application-specific), tab, message, etc."
    tags: ["recommended", "navigation"]
    repeatable: true
    action: ->
      switch @currentApplication()
        when "Skype"
          @key "Left", 'command option'
        else
          @key "[", 'command shift'
  "baxley":
    description: "go 'back' - whatever that might mean in context"
    tags: ["recommended", "navigation"]
    repeatable: true
    action: ->
      switch @currentApplication()
        when "Safari", "Google Chrome", "Firefox"
          @key "[", 'command'
        when "Sublime Text"
          @key "-", 'control'
  "fourthly":
    description: "go 'forward' - whatever that might mean in context"
    tags: ["recommended", "navigation"]
    repeatable: true
    action: ->
      switch @currentApplication()
        when "Safari", "Google Chrome", "Firefox"
          @key "]", 'command'
        when "Sublime Text"
          @key "-", "control shift"
  "freshly":
    description: "reload or refresh depending on context"
    tags: ["recommended", "navigation"]
    action: ->
      switch @currentApplication()
        when "Safari", "Google Chrome", "Firefox"
          @key "R", 'command'
        when "Atom"
          @key "L", 'control option command'
  "cheese":
    description: "presses the down arrow [x] times then presses return (for choosing items from lists that don't have direct shortcuts)"
    tags: ["navigation"]
    grammarType: "numberCapture"
    action: (input) ->
      times = input or 1
      for i in [1..times]
        @key "Down"
      @key "Return"
