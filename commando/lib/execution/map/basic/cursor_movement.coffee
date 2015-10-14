Commands.createDisabled
  'doomway':
    description: 'move the cursor to the bottom of the page'
    tags: ['cursor', 'recommended']
    action: ->
      @key 'down', 'command'
  'doom':
    description: 'press the down arrow'
    tags: ['cursor', 'recommended']
    repeatable: true
    action: ->
      @down()
  'jeepway':
    description: 'move the cursor to the top of the page'
    tags: ['cursor', 'recommended']
    action: ->
      @key 'up', 'command'
  'jeep':
    description: 'Press the up arrow'
    tags: ['cursor', 'recommended']
    repeatable: true
    action: ->
      @up()
  'crimp':
    description: 'press the left arrow'
    misspellings: ['crimped']
    tags: ['cursor', 'recommended']
    repeatable: true
    action: ->
      @left()
  'chris':
    description: 'press the right arrow'
    tags: ['cursor', 'recommended']
    misspellings: ['krist', 'crist']
    repeatable: true
    action: ->
      @right()
  'shunkrim':
    description: 'move the cursor by word to the left'
    tags: ['cursor', 'recommended']
    repeatable: true
    action: ->
      switch @currentApplication()
        when "Parallels Desktop"
          @key 'left', 'control'
        else
          @key 'left', 'option'
  'wonkrim':
    description: 'move the cursor by partial word to the left'
    tags: ['cursor']
    repeatable: true
    action: ->
      @key 'left', 'control'
  'wonkrish':
    description: 'move the cursor by partial word to the right'
    tags: ['cursor']
    repeatable: true
    action: ->
      @key 'right', 'control'
  'shunkrish':
    description: 'move the cursor by word to the right'
    tags: ['cursor', 'recommended']
    repeatable: true
    action: ->
      switch @currentApplication()
        when "Parallels Desktop"
          @key 'right', 'control'
        else
          @key 'right', 'option'
  'ricky':
    description: 'moves the cursor all the way to the right'
    tags: ['cursor', 'recommended']
    action: ->
      switch @currentApplication()
        when "Parallels Desktop"
          @key 'end'
        else
          @key 'right', 'command'
  'derek':
    description: 'moves the cursor on the way to the right than inserts a space'
    tags: ['cursor', 'space', 'right', 'combo', 'recommended']
    misspellings: ['derrick']
    action: ->
      @key 'right', 'command'
      @space()
  'nudgle':
    description: 'remove a space before the adjacent word on the left'
    tags: ['cursor', 'space', 'deleting', 'left', 'combo', 'recommended']
    repeatable: true
    misspellings: ['nigel']
    action: ->
      @key 'left', 'option'
      @key 'delete'
  'ricksy':
    description: 'selects all text to the right'
    tags: ['selection', 'right', 'recommended']
    action: ->
      switch @currentApplication()
        when "Parallels Desktop"
          @key 'end', 'shift'
        else
          @key 'right', 'command shift'
  'lefty':
    description: 'move the cursor all the way to the left'
    tags: ['cursor', 'left', 'recommended']
    action: ->
      switch @currentApplication()
        when "Parallels Desktop"
          @key 'home'
        else
          @key 'left', 'command'
  'lecksy':
    description: 'selects all text to the left'
    tags: ['selection', 'left', 'recommended']
    action: ->
      switch @currentApplication()
        when "Parallels Desktop"
          @key 'home', 'shift'
        else
          @key 'left', 'command shift'
  'shackle':
    description: 'selects the entire line'
    tags: ['selection', 'recommended']
    misspellings: ['sheqel', 'shikel', 'shekel']
    action: ->
      @key 'left', 'command'
      @key 'right', 'command shift'
  'snipline':
    description: 'with no arguments will delete the entire line(s). With a single argument will move to that line and delete it. With a number range will delete the range of lines'
    grammarType: 'numberRange'
    tags: ['deleting', 'recommended']
    misspellings: ['snipeline']
    action: ({first, last} = {}) ->
      console.log "snipline", arguments
      switch @currentApplication()
        when 'Sublime Text'
          if last?
            @sublime().selectRange(first, last).execute()
          else if first?
            @sublime().goToLine(first).execute()
          @key 'k', 'control shift'
        when 'Atom'
          if last?
            @runAtomCommand 'selectLineRange',
              from: first
              to: last
          else if first?
            @runAtomCommand 'goToLine', first
          @delay 40
          @key 'k', 'control shift'
        else
          @key 'delete'
          @key 'right', 'command'
          @key 'delete', 'command'
  'snipper':
    description: 'will delete everything to the right'
    tags: ['deleting', 'right', 'recommended']
    misspellings: ['sniper']
    action: ->
      if @currentApplication is 'Sublime Text'
        @key 'k', ['control']
      else
        @key 'right', 'command shift'
        @key 'delete'
  'snipple':
    tags: ['deleting', 'left', 'recommended']
    description: 'will delete everything to the left'
    action: ->
      @key 'delete', 'command'
  'jolt':
    description: 'will duplicate the current line'
    tags: ['text-manipulation', 'recommended']
    misspellings: ['joel']
    action: ->
      switch @currentApplication()
        when 'Sublime Text', 'Atom'
          @key 'd', 'command shift'
        else
          @do 'shackle'
          @copy()
          @right()
          @enter()
          @paste()
  'swan':
    description: "Enters 'Ace Jump' / 'Easy Motion' mode"
    tags: ['cursor']
    action: ->
      if @currentApplication is 'Sublime Text'
        @key ';', 'command'
