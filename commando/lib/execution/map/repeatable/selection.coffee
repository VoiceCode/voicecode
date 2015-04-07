_.extend Commands.mapping,
  "shroomway":
    kind: "action"
    grammarType: "individual"
    description: "select all text downward"
    tags: ["selection"]
    action: ->
      @key 'Down', ['shift', 'command']
  "shroom":
    kind: "action"
    grammarType: "individual"
    description: "shift down, select text by line downward"
    tags: ["selection"]
    action: ->
      @key 'Down', ['shift']
  "shreepway":
    kind: "action"
    grammarType: "individual"
    description: "select all text upward"
    tags: ["selection"]
    action: ->
      @key 'Up', ['shift', 'command']
  "shreep":
    kind: "action"
    grammarType: "individual"
    description: "shift up, select text by line upward"
    tags: ["selection"]
    action: ->
      @key 'Up', ['shift']
  "shrim":
    kind: "action"
    grammarType: "individual"
    description: "extend selection by character to the left"
    tags: ["selection"]
    action: ->
      @key 'Left', ['shift']
  "shrish":
    kind: "action"
    grammarType: "individual"
    description: "extend selection by character to the right"
    tags: ["selection"]
    action: ->
      @key 'Right', ['shift']
  "scram":
    kind: "action"
    grammarType: "individual"
    description: "extend selection by word to the left"
    tags: ["selection"]
    action: ->
      @key 'Left', ['option', 'shift']
  "scrish":
    kind: "action"
    grammarType: "individual"
    description: "extend selection by word to the right"
    tags: ["selection"]
    action: ->
      @key 'Right', ['option', 'shift']
