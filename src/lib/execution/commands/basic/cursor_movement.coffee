Commands.createDisabled
  'core.cursor.way.down':
    spoken: 'doomway'
    formdescription: 'Move the cursor to the bottom of the page'
    tags: ['cursor', 'recommended']
    action: ->
      @key 'down', 'command'
  'core.cursor.down':
    spoken: 'doom'
    description: 'press the down arrow'
    tags: ['cursor', 'recommended']
    repeatable: true
    action: ->
      @down()
  'core.cursor.way.up':
    spoken: 'jeepway'
    description: 'Move the cursor to the top of the page'
    tags: ['cursor', 'recommended']
    action: ->
      @key 'up', 'command'
  'core.cursor.up':
    spoken: 'jeep'
    description: 'Press the up arrow'
    tags: ['cursor', 'recommended']
    repeatable: true
    action: ->
      @up()
  'core.cursor.left':
    spoken: 'crimp'
    description: 'press the left arrow'
    misspellings: ['crimped']
    tags: ['cursor', 'recommended']
    repeatable: true
    action: ->
      @left()
  'core.cursor.right':
    spoken: 'chris'
    description: 'press the right arrow'
    tags: ['cursor', 'recommended']
    misspellings: ['krist', 'crist']
    repeatable: true
    action: ->
      @right()
  'core.cursor.wordLeft':
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
  'core.cursor.wordPartialLeft':
    spoken: 'wonkrim'
    description: 'Move the cursor by partial word to the left'
    tags: ['cursor']
    repeatable: true
    action: ->
      @key 'left', 'control'
  'core.cursor.wordPartialRight':
    spoken: 'wonkrish'
    description: 'Move the cursor by partial word to the right'
    tags: ['cursor']
    repeatable: true
    action: ->
      @key 'right', 'control'
  'core.cursor.wordRight':
    spoken: 'shunkrish'
    description: 'Move the cursor by word to the right'
    tags: ['cursor', 'recommended']
    repeatable: true
    action: ->
      switch @currentApplication()
        when "Parallels Desktop"
          @key 'right', 'control'
        else
          @key 'right', 'option'
  'core.cursor.way.right':
    spoken: 'ricky'
    description: 'Move the cursor all the way to the right'
    tags: ['cursor', 'recommended']
    action: ->
      switch @currentApplication()
        when "Parallels Desktop"
          @key 'end'
        else
          @key 'right', 'command'
  'core.cursor.way.rightThenSpace':
    spoken: 'derek'
    description: 'Move the cursor all the way to the right than inserts a space'
    tags: ['cursor', 'space', 'right', 'combo', 'recommended']
    misspellings: ['derrick']
    action: ->
      @key 'right', 'command'
      @space()
  'core.text.nudge.left':
    spoken: 'nudgle'
    description: 'remove a space before the adjacent word on the left'
    tags: ['cursor', 'space', 'deleting', 'left', 'combo', 'recommended']
    repeatable: true
    misspellings: ['nigel']
    action: ->
      @key 'left', 'option'
      @key 'delete'
  'core.select.way.right':
    spoken: 'ricksy'
    description: 'selects all text to the right'
    tags: ['selection', 'right', 'recommended']
    action: ->
      switch @currentApplication()
        when "Parallels Desktop"
          @key 'end', 'shift'
        else
          @key 'right', 'command shift'
  'core.cursor.way.left':
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
  'core.select.way.left'
    spoken: 'lecksy'
    description: 'selects all text to the left'
    tags: ['selection', 'left', 'recommended']
    action: ->
      switch @currentApplication()
        # TODO: package
        when "Parallels Desktop"
          @key 'home', 'shift'
        else
          @key 'left', 'command shift'
  'core.select.all.lineText':
    spoken: 'shackle'
    description: 'selects the entire line text'
    tags: ['selection', 'recommended']
    misspellings: ['sheqel', 'shikel', 'shekel']
    action: ->
      @key 'left', 'command'
      @key 'right', 'command shift'
  'core.delete.all.line':
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
  'core.delete.all.right':
    spoken: 'snipper'
    description: 'Will delete everything to the right'
    tags: ['deleting', 'right', 'recommended']
    misspellings: ['sniper']
    action: ->
      @key 'right', 'command shift'
      @key 'delete'
  'core.delete.all.left':
    spoken: 'snipple'
    tags: ['deleting', 'left', 'recommended']
    description: 'Will delete everything to the left'
    action: ->
      @key 'delete', 'command'
  'core.object.duplicate':
    spoken: 'jolt'
    description: 'Will duplicate whichever makes sense in the context'
    tags: ['text-manipulation', 'recommended']
    misspellings: ['joel']
    action: ->
      # TODO: re-implement
      # RENAMING ALERT
      @do 'core.select.all.lineText'
      @copy()
      @do 'core.common.newLineBelow'
      @paste()
  'core.showShortcuts':
    spoken: 'swan'
    description: "Show shortcuts"
    tags: ['cursor']
    action: ->
      null
