Commands.createDisabled
  'delimiter': # RENAMING ALERT
    spoken: 'shin'
    description: "does nothing, but enters into voice code"
    misspellings: ["chin"]
    tags: ["text", "recommended"]
    action: ->
      null

  'combo.shiftSpace':
    spoken: 'sky koosh'
    description: "press shift+space (useful for scrolling up, or other random purposes in certain applications)"
    tags: ["space"]
    repeatable: true
    action: ->
      @key 'space', 'shift'
  'common.newLineBelow':
    spoken: 'shockoon'
    description: "Inserts a new line below the current line"
    tags: ["return", "combo", "recommended"]
    repeatable: true
    action: ->
      # TODO: move 2 sublime package
      if @currentApplication().name is "sublime"
        @key "return", "command"
      else
        @key "right", "command"
        @enter()
  'common.newLineAbove':
    spoken: 'shockey'
    description: "Inserts a new line above the current line"
    misspellings: ["chalky", "shocking", "shocky"]
    tags: ["return", "combo", "recommended"]
    repeatable: true
    action: ->
      # TODO: move 2 sublime package
      if @currentApplication().name is "sublime"
        @key "return", "command shift"
      else
        @key "left", "command"
        @enter()
        @up()
