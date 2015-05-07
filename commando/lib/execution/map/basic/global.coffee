Commands.createDisabled
  "goneck":
    description: "go to next thing (application-specific), tab, message, etc."
    tags: ["recommended", "navigation"]
    action: ->
      @key "]", ['command', 'shift']
  "gopreev":
    description: "go to previous thing (application-specific), tab, message, etc."
    tags: ["recommended", "navigation"]
    action: ->
      @key "[", ['command', 'shift']
  "baxley":
    description: "go 'back' - whatever that might mean in context"
    tags: ["recommended", "navigation"]
    action: ->
      switch @currentApplication()
        when "Safari"
          @key "[", ['command']
        when "Google Chrome"
          @key "[", ['command']
        when "Sublime Text"
          @key "-", ['control']
  "fourthly":
    description: "go 'forward' - whatever that might mean in context"
    tags: ["recommended", "navigation"]
    action: ->
      switch @currentApplication()
        when "Safari"
          @key "]", ['command']
        when "Google Chrome"
          @key "]", ['command']
        when "Sublime Text"
          @key "-", ['control', 'shift']


