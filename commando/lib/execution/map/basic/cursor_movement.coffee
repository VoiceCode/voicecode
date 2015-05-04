Commands.create
  "doomway":
    description: "move the cursor to the bottom of the page"
    tags: ["cursor", "recommended"]
    action: ->
      @key "Down", ["command"]
  "doom":
    description: "press the down arrow"
    tags: ["cursor", "recommended"]
    action: ->
      @key "Down"
  "jeepway":
    description: "move the cursor to the top of the page"
    tags: ["cursor", "recommended"]
    action: ->
      @key "Up", ["command"]
  "jeep":
    description: "Press the up arrow"
    tags: ["cursor", "recommended"]
    action: ->
      @key "Up"
  "crimp":
    description: "press the left arrow"
    aliases: ["crimped"]
    tags: ["cursor", "recommended"]
    action: ->
      @key "Left"
  "chris":
    description: "press the right arrow"
    tags: ["cursor", "recommended"]
    aliases: ["krist", "crist"]
    action: ->
      @key "Right"
  "shunkrim":
    description: "move the cursor by word to the left"
    tags: ["cursor", "recommended"]
    action: ->
      @key "Left", ["option"]
  "wonkrim":
    description: "move the cursor by partial word to the left"
    tags: ["cursor"]
    action: ->
      @key "Left", ["control"]
  "wonkrish":
    description: "move the cursor by partial word to the right"
    tags: ["cursor"]
    action: ->
      @key "Right", ["control"]
  "shunkrish":
    description: "move the cursor by word to the right"
    tags: ["cursor", "recommended"]
    action: ->
      @key "Right", ["option"]
  "ricky":
    description: "moves the cursor all the way to the right"
    tags: ["cursor", "recommended"]
    action: ->
      @key "Right", ['command']
  "derek":
    description: "moves the cursor on the way to the right than inserts a space"
    tags: ["cursor", "space", "right", "combo", "recommended"]
    aliases: ["derrick"]
    action: ->
      @key "Right", ['command']
      @key " "
  "nudgle":
    description: "remove a space before the adjacent word on the left"
    tags: ["cursor", "space", "deleting", "left", "combo", "recommended"]
    action: ->
      @key "Left", ['option']
      @key "Delete"
  "ricksy":
    description: "selects all text to the right"
    tags: ["selection", "right", "recommended"]
    action: ->
      @key "Right", ['command', 'shift']
  "lefty":
    description: "move the cursor all the way to the left"
    tags: ["cursor", "left", "recommended"]
    action: ->
      @key "Left", ['command']
  "lecksy":
    description: "selects all text to the left"
    tags: ["selection", "left", "recommended"]
    action: ->
      @key "Left", ['command', 'shift']
  "shackle":
    description: "selects the entire line"
    tags: ["selection", "recommended"]
    aliases: ["sheqel", "shikel", "shekel"]
    action: ->
      @key "Left", ['command']
      @key "Right", ['command', 'shift']
  "snipline":
    description: "will delete the entire line(s)"
    tags: ["deleting", "recommended"]
    aliases: ["snipeline"]
    action: ->
      switch @currentApplication()
        when "Sublime Text"
          @key "K", ['control', 'shift']
        when "Atom"
          @key "K", ['control', 'shift']
        else
          @key "Delete"
          @key "Right", ['command']
          @key "Delete", ['command']
  "snipper":
    description: "will delete everything to the right"
    tags: ["deleting", "right", "recommended"]
    aliases: ["sniper"]
    action: ->
      if @currentApplication is "Sublime Text"
        @key "K", ['control']
      else
        @key "Right", ['command', 'shift']
        @key "Delete"
  "snipple":
    tags: ["deleting", "left", "recommended"]
    description: "will delete everything to the left"
    action: ->
      @key "Delete", ['command']
  "jolt":
    description: "will duplicate the current line"
    tags: ["text-manipulation", "recommended"]
    aliases: ["joel"]
    action: ->
      if @currentApplication() is "Sublime Text"
        @key "D", ['command', 'shift']
      else
        @key "Left", ['command']
        @key "Right", ['command', 'shift']
        @key "C", ['command']
        @key "Right"
        @key "Return"
        @key "V", ['command']
  "swan":
    description: "Enters 'Ace Jump' / 'Easy Motion' mode"
    tags: ["cursor"]
    action: ->
      if @currentApplication is "Sublime Text"
        @key ";", ['command']
