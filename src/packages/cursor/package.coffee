pack = Packages.register
  name: 'cursor'
  description: 'Cursor movement, etc.'

pack.commands
  'way.down':
    spoken: 'doomway'
    formdescription: 'Move the cursor to the bottom of the page'
    tags: ['cursor', 'recommended']
    action: ->
      @key 'down', 'command'
  'down':
    spoken: 'doom'
    description: 'press the down arrow'
    tags: ['cursor', 'recommended']
    repeatable: true
    action: ->
      @down()
  'way.up':
    spoken: 'jeep way'
    description: 'Move the cursor to the top of the page'
    tags: ['cursor', 'recommended']
    action: ->
      @key 'up', 'command'
  'up':
    spoken: 'jeep'
    description: 'Press the up arrow'
    tags: ['cursor', 'recommended']
    repeatable: true
    action: ->
      @up()
  'left':
    spoken: 'crimp'
    description: 'press the left arrow'
    misspellings: ['crimped']
    tags: ['cursor', 'recommended']
    repeatable: true
    action: ->
      @left()
  'right':
    spoken: 'chris'
    description: 'press the right arrow'
    tags: ['cursor', 'recommended']
    misspellings: ['krist', 'crist']
    repeatable: true
    action: ->
      @right()
  'word.left':
    spoken: 'fame'
    description: 'Move the cursor by word to the left'
    tags: ['cursor', 'recommended']
    repeatable: true
    action: ->
      switch @currentApplication().name
        when "Parallels Desktop"
          @key 'left', 'control'
        else
          @key 'left', 'option'
  'wordpartial.left':
    spoken: 'wonkrim'
    description: 'Move the cursor by partial word to the left'
    tags: ['cursor']
    repeatable: true
    action: ->
      @key 'left', 'control'
  'wordpartial.right':
    spoken: 'wonkrish'
    description: 'Move the cursor by partial word to the right'
    tags: ['cursor']
    repeatable: true
    action: ->
      @key 'right', 'control'
  'word.right':
    spoken: 'fish'
    description: 'Move the cursor by word to the right'
    tags: ['cursor', 'recommended']
    repeatable: true
    action: ->
      switch @currentApplication().name #TODO: package
        when "Parallels Desktop"
          @key 'right', 'control'
        else
          @key 'right', 'option'
  'way.right':
    spoken: 'ricky'
    description: 'Move the cursor all the way to the right'
    tags: ['cursor', 'recommended']
    action: ->
      switch @currentApplication().name #TODO: package
        when "Parallels Desktop"
          @key 'end'
        else
          @key 'right', 'command'
  'way.right+space':
    spoken: 'derek'
    description: 'Move the cursor all the way to the right than inserts a space'
    tags: ['cursor', 'space', 'right', 'combo', 'recommended']
    misspellings: ['derrick']
    action: ->
      @key 'right', 'command'
      @space()
  'way.left':
    spoken: 'lefty'
    description: 'Move the cursor all the way to the left'
    tags: ['cursor', 'left', 'recommended']
    action: ->
      switch @currentApplication().name
        # TODO: package
        when "Parallels Desktop"
          @key 'home'
        else
          @key 'left', 'command'
  'new-line-below':
    spoken: 'shockoon'
    description: "Inserts a new line below the current line"
    tags: ["return", "combo", "recommended"]
    repeatable: true
  'new-line-above':
    spoken: 'shockey'
    description: "Inserts a new line above the current line"
    misspellings: ["chalky", "shocking", "shocky"]
    tags: ["return", "combo", "recommended"]
    repeatable: true
