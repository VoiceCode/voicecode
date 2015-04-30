Commands.create
  "switchy":
    kind: "action"
    grammarType: "individual"
    description: "move current line (or multiline selection) up"
    tags: ["text-manipulation"]
    action: (input) ->
      switch @currentApplication()
        when "Sublime Text"
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
    kind: "action"
    grammarType: "individual"
    description: "move current line (or multiline selection) down"
    tags: ["text-manipulation"]
    action: (input) ->
      switch @currentApplication()
        when "Sublime Text"
          @key "Down", ['control', 'command']
        when "Xcode"
          @key "]", ['command', 'option']
        else
          height = @do("folly").height
          @key "X", ['command']
          @key "Down"
          @key "V", ['command']
          _(height).times => @key "Up", ['shift']


