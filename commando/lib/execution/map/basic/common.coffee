Commands.createDisabled
  'shock':
    aliases: ['shocked', 'shox', 'chalk']
    description: 'press the return key'
    tags: ['return', 'recommended']
    repeatable: true
    action: (input) ->
      @enter()
  'junk':
    description: 'press the delete key'
    aliases: ['junks', 'junked']
    tags: ['deleting', 'recommended']
    repeatable: true
    action: (input) ->
      @key 'delete'
  'spunk':
    description: 'pressed the forward delete key'
    tags: ['deleting', 'recommended']
    repeatable: true
    action: (input) ->
      @key 'forwarddelete'
  'dizzle':
    description: 'undo'
    tags: ['application', 'recommended']
    repeatable: true
    action: (input) ->
      @undo()
  'rizzle':
    description: 'redo'
    tags: ['application', 'recommended']
    repeatable: true
    action: (input) ->
      @redo()
  'tarp':
    description: 'inserts a tab'
    tags: ['tab', 'recommended']
    repeatable: true
    action: (input) ->
      @key 'tab'
  'tarsh':
    description: 'inserts a shift + tab'
    tags: ['tab', 'recommended']
    repeatable: true
    action: (input) ->
      @key 'tab', 'shift'
  'gibby':
    description: 'Switch to next window in same application'
    tags: ['application', 'window', 'recommended']
    repeatable: true
    action: (input) ->
      @key '`', 'command'
  'shibby':
    description: 'Switch to previous window in same application'
    tags: ['application', 'window', 'recommended']
    repeatable: true
    action: (input) ->
      @key '`', 'command shift'
  'shompla':
    description: 'zoom in'
    tags: ['application', 'plus', 'recommended']
    repeatable: true
    action: (input) ->
      @key '=', 'command'
  'shaman':
    description: 'zoom out'
    tags: ['application', 'minus', 'recommended']
    repeatable: true
    action: (input) ->
      @key '-', 'command'
  'shabble':
    description: 'indent to the left'
    tags: ['[', 'recommended']
    repeatable: true
    action: (input) ->
      @key '[', 'command'
  'shabber':
    description: 'indent to the right'
    aliases: ['shammar']
    tags: [']', 'recommended']
    repeatable: true
    action: (input) ->
      @key ']', 'command'
  'marneck':
    description: 'find the next occurrence of a search term'
    tags: ['application', 'recommended']
    repeatable: true
    action: (input) ->
      @key 'g', 'command'
  'marpreev':
    description: 'find the previous occurrence of a search term'
    tags: ['application', 'recommended']
    repeatable: true
    action: (input) ->
      @key 'g', 'command shift'
  'olly':
    description: 'select all'
    tags: ['selection', 'recommended']
    action: ->
      @selectAll()
  'sage':
    description: 'file > save'
    tags: ['application', 'recommended']
    action: ->
      @save()
  'sagewick':
    description: 'file > save'
    tags: ['application', 'combo']
    action: ->
      @save()
      @switchApplication()
  'totch':
    description: 'close a window or tab'
    tags: ['application', 'window', 'recommended']
    repeatable: true
    action: ->
      @key 'w', 'command'
  'marco':
    description: 'find'
    tags: ['application', 'recommended']
    action: ->
      @key 'f', 'command'
  'talky':
    description: 'open a new tab'
    tags: ['application', 'window', 'recommended']
    aliases: ['talkie']
    action: ->
      @newTab()
  'randall':
    description: 'press escape'
    tags: ['key', 'recommended']
    action: ->
      @key 'escape'
  'prome':
    description: 'press the home key'
    tags: ['recommended', 'key']
    action: ->
      @key 'home'
  'prend':
    description: 'press the home key'
    tags: ['recommended', 'key']
    action: ->
      @key 'end'
