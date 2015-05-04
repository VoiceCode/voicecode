Commands.createDisabled
  "switchy":
    description: "move current line (or multiline selection) up"
    tags: ["text-manipulation"]
    action: (input) ->
      switch @currentApplication()
        when "Sublime Text"
          @key "Up", ['control', 'command']
        when "Atom"
          @key "Up", ['control', 'command']
        when "Xcode"
          @key "[", ['command', 'option']
        else
          height = @do("folly").height
          @key "X", ['command']
          @key "Up"
          @key "V", ['command']
          _(height).times => @key "Up", ['shift']

  "switcho":
    description: "move current line (or multiline selection) down"
    tags: ["text-manipulation"]
    action: (input) ->
      switch @currentApplication()
        when "Sublime Text"
          @key "Down", ['control', 'command']
        when "Atom"
          @key "Down", ['control', 'command']
        when "Xcode"
          @key "]", ['command', 'option']
        else
          height = @do("folly").height
          @key "X", ['command']
          @key "Down"
          @key "V", ['command']
          _(height).times => @key "Up", ['shift']


