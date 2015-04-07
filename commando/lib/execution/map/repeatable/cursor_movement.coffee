_.extend Commands.mapping,
  "doomway":
    kind: "action"
    grammarType: "individual"
    description: "move the cursor to the bottom of the page"
    tags: ["cursor"]
    action: ->
      @key "Down", ["command"]
  "doom":
    kind: "action"
    grammarType: "individual"
    description: "press the down arrow"
    tags: ["cursor"]
    action: ->
      @key "Down"
  "jeepway":
    kind: "action"
    grammarType: "individual"
    description: "move the cursor to the top of the page"
    tags: ["cursor"]
    action: ->
      @key "Up", ["command"]
  "jeep":
    kind: "action"
    description: "Press the up arrow"
    grammarType: "individual"
    tags: ["cursor"]
    action: ->
      @key "Up"
  "crimp":
    kind: "action"
    grammarType: "individual"
    description: "press the left arrow"
    aliases: ["crimped"]
    tags: ["cursor"]
    action: ->
      @key "Left"
  "chris":
    kind: "action"
    grammarType: "individual"
    description: "press the right arrow"
    tags: ["cursor"]
    aliases: ["krist", "crist"]
    action: ->
      @key "Right"
  "shunkrim":
    kind: "action"
    grammarType: "individual"
    description: "move the cursor by word to the left"
    tags: ["cursor"]
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
    tags: ["cursor"]
    action: ->
      @key "Right", ["option"]

