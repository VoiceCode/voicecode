Commands.create
  "shroomway":
    kind: "action"
    grammarType: "individual"
    description: "select all text downward"
    tags: ["selection", "recommended"]
    action: ->
      @key 'Down', ['shift', 'command']
  "shroom":
    kind: "action"
    grammarType: "individual"
    description: "shift down, select text by line downward"
    tags: ["selection", "recommended"]
    action: ->
      @key 'Down', ['shift']
  "shreepway":
    kind: "action"
    grammarType: "individual"
    description: "select all text upward"
    tags: ["selection", "recommended"]
    action: ->
      @key 'Up', ['shift', 'command']
  "shreep":
    kind: "action"
    grammarType: "individual"
    description: "shift up, select text by line upward"
    tags: ["selection", "recommended"]
    action: ->
      @key 'Up', ['shift']
  "shrim":
    kind: "action"
    grammarType: "individual"
    description: "extend selection by character to the left"
    tags: ["selection", "recommended"]
    action: ->
      @key 'Left', ['shift']
  "shrish":
    kind: "action"
    grammarType: "individual"
    description: "extend selection by character to the right"
    tags: ["selection", "recommended"]
    action: ->
      @key 'Right', ['shift']
  "scram":
    kind: "action"
    grammarType: "individual"
    description: "extend selection by word to the left"
    tags: ["selection", "recommended"]
    action: ->
      @key 'Left', ['option', 'shift']
  "scrish":
    kind: "action"
    grammarType: "individual"
    description: "extend selection by word to the right"
    tags: ["selection", "recommended"]
    action: ->
      @key 'Right', ['option', 'shift']
