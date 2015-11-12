Commands.createDisabled
  'cursor.way.down':
    spoken: 'doomway'
    formdescription: 'Move the cursor to the bottom of the page'
    tags: ['cursor', 'recommended']
    action: ->
      @key 'down', 'command'
  'cursor.down':
    spoken: 'doom'
    description: 'press the down arrow'
    tags: ['cursor', 'recommended']
    repeatable: true
    action: ->
      @down()
  'cursor.way.up':
    spoken: 'jeepway'
    description: 'Move the cursor to the top of the page'
    tags: ['cursor', 'recommended']
    action: ->
      @key 'up', 'command'
  'cursor.up':
    spoken: 'jeep'
    description: 'Press the up arrow'
    tags: ['cursor', 'recommended']
    repeatable: true
    action: ->
      @up()
  'cursor.left':
    spoken: 'crimp'
    description: 'press the left arrow'
    misspellings: ['crimped']
    tags: ['cursor', 'recommended']
    repeatable: true
    action: ->
      @left()
  'cursor.right':
    spoken: 'chris'
    description: 'press the right arrow'
    tags: ['cursor', 'recommended']
    misspellings: ['krist', 'crist']
    repeatable: true
    action: ->
      @right()
  'cursor.word.left':
    spoken: 'shunkrim'
    description: 'Move the cursor by word to the left'
    tags: ['cursor', 'recommended']
    repeatable: true
    action: ->
      switch @currentApplication()
        when "Parallels Desktop"
          @key 'left', 'control'
        else
          @key 'left', 'option'
  'cursor.wordpartial.left':
    spoken: 'wonkrim'
    description: 'Move the cursor by partial word to the left'
    tags: ['cursor']
    repeatable: true
    action: ->
      @key 'left', 'control'
  'cursor.wordpartial.right':
    spoken: 'wonkrish'
    description: 'Move the cursor by partial word to the right'
    tags: ['cursor']
    repeatable: true
    action: ->
      @key 'right', 'control'
  'cursor.word.right':
    spoken: 'shunkrish'
    description: 'Move the cursor by word to the right'
    tags: ['cursor', 'recommended']
    repeatable: true
    action: ->
      switch @currentApplication() #TODO: package
        when "Parallels Desktop"
          @key 'right', 'control'
        else
          @key 'right', 'option'
  'cursor.way.right':
    spoken: 'ricky'
    description: 'Move the cursor all the way to the right'
    tags: ['cursor', 'recommended']
    action: ->
      switch @currentApplication() #TODO: package
        when "Parallels Desktop"
          @key 'end'
        else
          @key 'right', 'command'
  'cursor.way.rightThenSpace':
    spoken: 'derek'
    description: 'Move the cursor all the way to the right than inserts a space'
    tags: ['cursor', 'space', 'right', 'combo', 'recommended']
    misspellings: ['derrick']
    action: ->
      @key 'right', 'command'
      @space()
  'text.nudge.left':
    spoken: 'nudgle'
    description: 'remove a space before the adjacent word on the left'
    tags: ['cursor', 'space', 'deleting', 'left', 'combo', 'recommended']
    repeatable: true
    misspellings: ['nigel']
    action: ->
      @key 'left', 'option'
      @key 'delete'
  'select.all.right':
    spoken: 'ricksy'
    description: 'selects all text to the right'
    tags: ['selection', 'right', 'recommended']
    action: ->
      switch @currentApplication()
        when "Parallels Desktop"
          @key 'end', 'shift'
        else
          @key 'right', 'command shift'
  'cursor.way.left':
    spoken: 'lefty'
    description: 'Move the cursor all the way to the left'
    tags: ['cursor', 'left', 'recommended']
    action: ->
      switch @currentApplication()
        # TODO: package
        when "Parallels Desktop"
          @key 'home'
        else
          @key 'left', 'command'
  'delete.all.line':
    spoken: 'snipline'
    description: 'With no arguments will delete the entire line(s).
    With a single argument will move to that line and delete it.
    With a number range will delete the range of lines'
    grammarType: 'numberRange'
    tags: ['deleting', 'recommended']
    misspellings: ['snipeline']
    inputRequired: false
    action: ({first, last} = {}) ->
      @key 'delete'
      @key 'right', 'command'
      @key 'delete', 'command'
  'delete.all.right':
    spoken: 'snipper'
    description: 'Will delete everything to the right'
    tags: ['deleting', 'right', 'recommended']
    misspellings: ['sniper']
    action: ->
      @key 'right', 'command shift'
      @key 'delete'
  'delete.all.left':
    spoken: 'snipple'
    tags: ['deleting', 'left', 'recommended']
    description: 'Will delete everything to the left'
    action: ->
      @key 'delete', 'command'
  'object.duplicate':
    spoken: 'jolt'
    description: 'Will duplicate whichever makes sense in the context'
    tags: ['text-manipulation', 'recommended']
    misspellings: ['joel']
    action: ->
      @do 'select.line.text'
      @copy()
      @do 'common.newLineBelow'
      @paste()
  'showShortcuts':
    spoken: 'swan'
    description: "Show shortcuts"
    tags: ['cursor']
    action: ->
      null
