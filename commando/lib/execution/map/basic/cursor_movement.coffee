Commands.create
  "doomway":
    kind: "action"
    grammarType: "individual"
    description: "move the cursor to the bottom of the page"
    tags: ["cursor", "recommended"]
    action: ->
      @key "Down", ["command"]
  "doom":
    kind: "action"
    grammarType: "individual"
    description: "press the down arrow"
    tags: ["cursor", "recommended"]
    action: ->
      @key "Down"
  "jeepway":
    kind: "action"
    grammarType: "individual"
    description: "move the cursor to the top of the page"
    tags: ["cursor", "recommended"]
    action: ->
      @key "Up", ["command"]
  "jeep":
    kind: "action"
    description: "Press the up arrow"
    grammarType: "individual"
    tags: ["cursor", "recommended"]
    action: ->
      @key "Up"
  "crimp":
    kind: "action"
    grammarType: "individual"
    description: "press the left arrow"
    aliases: ["crimped"]
    tags: ["cursor", "recommended"]
    action: ->
      @key "Left"
  "chris":
    kind: "action"
    grammarType: "individual"
    description: "press the right arrow"
    tags: ["cursor", "recommended"]
    aliases: ["krist", "crist"]
    action: ->
      @key "Right"
  "shunkrim":
    kind: "action"
    grammarType: "individual"
    description: "move the cursor by word to the left"
    tags: ["cursor", "recommended"]
    action: ->
      @key "Left", ["option"]
  "wonkrim":
    kind: "action"
    grammarType: "individual"
    description: "move the cursor by partial word to the left"
    tags: ["cursor"]
    action: ->
      @key "Left", ["control"]
  "wonkrish":
    kind: "action"
    grammarType: "individual"
    description: "move the cursor by partial word to the right"
    tags: ["cursor"]
    action: ->
      @key "Right", ["control"]
  "shunkrish":
    kind: "action"
    grammarType: "individual"
    description: "move the cursor by word to the right"
    tags: ["cursor", "recommended"]
    action: ->
      @key "Right", ["option"]
  "ricky":
    kind: "action"
    grammarType: "individual"
    description: "moves the cursor all the way to the right"
    tags: ["cursor", "recommended"]
    action: ->
      @key "Right", ['command']
  "derek":
    kind: "action"
    grammarType: "individual"
    description: "moves the cursor on the way to the right than inserts a space"
    tags: ["cursor", "space", "right", "combo", "recommended"]
    action: ->
      @key "Right", ['command']
      @key " "
  "nudgle":
    kind: "action"
    grammarType: "individual"
    description: "remove a space before the adjacent word on the left"
    tags: ["cursor", "space", "deleting", "left", "combo", "recommended"]
    action: ->
      @key "Left", ['option']
      @key "Delete"
  "ricksy":
    kind: "action"
    grammarType: "individual"
    description: "selects all text to the right"
    tags: ["selection", "right", "recommended"]
    action: ->
      @key "Right", ['command', 'shift']
  "lefty":
    kind: "action"
    grammarType: "individual"
    description: "move the cursor all the way to the left"
    tags: ["cursor", "left", "recommended"]
    action: ->
      @key "Left", ['command']
  "lecksy":
    kind: "action"
    grammarType: "individual"
    description: "selects all text to the left"
    tags: ["selection", "left", "recommended"]
    action: ->
      @key "Left", ['command', 'shift']
  "shackle":
    kind: "action"
    grammarType: "individual"
    description: "selects the entire line"
    tags: ["selection", "recommended"]
    aliases: ["sheqel", "shikel"]
    action: ->
      @key "Left", ['command']
      @key "Right", ['command', 'shift']
  "snipline":
    kind: "action"
    grammarType: "individual"
    description: "will delete the entire line(s)"
    tags: ["deleting", "recommended"]
    aliases: ["snipeline"]
    action: ->
      if @currentApplication() is "Sublime Text"
        @key "K", ['control', 'shift']
      else
        @key "Delete"
        @key "Right", ['command']
        @key "Delete", ['command']
  "snipper":
    kind: "action"
    grammarType: "individual"
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
    kind: "action"
    grammarType: "individual"
    tags: ["deleting", "left", "recommended"]
    description: "will delete everything to the left"
    action: ->
      @key "Delete", ['command']
  "jolt":
    kind: "action"
    grammarType: "individual"
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
  "folly":
    kind: "action"
    description: "expand selection to block"
    grammarType: "individual"
    tags: ["text-manipulation"]
    aliases: ["foley"]
    action: ->
      if @currentApplication() is "Sublime Text"
        @key "L", ['command']
      else
        Scripts.selectBlock()
  "spando":
    kind: "action"
    description: "expand selection symmetrically (horizontally)"
    grammarType: "numberCapture"
    tags: ["text-manipulation"]
    action: (input) ->
      @symmetricSelectionExpansion(input or 1)

  "bloxy":
    kind: "action"
    description: "expand selection vertically, symmetrically"
    grammarType: "numberCapture"
    tags: ["text-manipulation"]
    action: (input) ->
      @verticalSelectionExpansion(input or 1)

  "kerleck":
    kind: "action"
    description: "With argument: [word], Will select the text [word] on the current line. With arguments: [word1], [word2], Will select the text starting with the first occurrence of [word1] and ending with the last occurrence of [word2] on the current line"
    grammarType: "textCapture"
    tags: ["text-manipulation", "cursor", "selection"]
    action: (input) ->
      @selectCurrentOccurrence(input)

  "jeepleck":
    kind: "action"
    description: "With argument: [word], Will select the text [word] previous to the cursor. With arguments: [word1], [word2], Will select the text starting with the last occurrence of [word1] and ending with the last occurrence of [word2] previous to the cursor"
    grammarType: "textCapture"
    tags: ["text-manipulation", "cursor", "selection"]
    action: (input) ->
      @selectPreviousOccurrence(input)

  "doomleck":
    kind: "action"
    description: "With argument: [word], Will select the text [word] after the cursor. With arguments: [word1], [word2], Will select the text starting with the first occurrence of [word1] and ending with the first occurrence of [word2] after the cursor"
    grammarType: "textCapture"
    tags: ["text-manipulation", "cursor", "selection"]
    action: (input) ->
      @selectFollowingOccurrence(input)

  "swan":
    kind: "action"
    grammarType: "individual"
    description: "Enters 'Ace Jump' / 'Easy Motion' mode"
    tags: ["cursor"]
    action: ->
      if @currentApplication is "Sublime Text"
        @key ";", ['command']
