Commands.createDisabled
  # 'core.actions.affirmation': # RENAMING ALERT
  'core.common.enter': # RENAMING ALERT
    spoken: 'shock'
    misspellings: ['shocked', 'shox', 'chalk', 'schock']
    description: 'press the return key'
    tags: ['return', 'recommended']
    repeatable: true
    action: (input) ->
      @enter()
  'core.common.deletion.backward':
    spoken: 'junk'
    description: 'press the delete key'
    misspellings: ['junks', 'junked']
    tags: ['deleting', 'recommended']
    repeatable: true
    action: (input) ->
      @key 'delete'
  'core.common.deletion.forward':
    spoken: 'spunk'
    description: 'pressed the forward delete key'
    tags: ['deleting', 'recommended']
    repeatable: true
    action: (input) ->
      @key 'forwarddelete'
  # 'core.actions.regret' # RENAMING ALERT
  'core.common.undo': # RENAMING ALERT
    spoken: 'dizzle'
    description: 'undo'
    tags: ['application', 'recommended']
    repeatable: true
    action: (input) ->
      @undo()
  'core.common.redo':
    spoken: 'rizzle'
    description: 'redo'
    tags: ['application', 'recommended']
    repeatable: true
    action: (input) ->
      @redo()
  'core.common.tab.backward':
    spoken: 'tarp'
    description: 'inserts a tab'
    tags: ['tab', 'recommended']
    repeatable: true
    action: (input) ->
      @key 'tab'
  'core.common.tab.forward':
    spoken: 'tarsh'
    description: 'inserts a shift + tab'
    tags: ['tab', 'recommended']
    repeatable: true
    action: (input) ->
      @key 'tab', 'shift'
  'core.common.zoom.in':
    spoken: 'shompla'
    description: 'zoom in'
    tags: ['application', 'plus', 'recommended']
    repeatable: true
    action: (input) ->
      @key '=', 'command'
  'core.common.zoom.out':
    spoken: 'shaman'
    description: 'zoom out'
    tags: ['application', 'minus', 'recommended']
    repeatable: true
    action: (input) ->
      @key '-', 'command'
  'core.common.indentation.left':
    spoken: 'shabble'
    description: 'indent to the left'
    tags: ['[', 'recommended']
    repeatable: true
    action: (input) ->
      @key '[', 'command'
  'core.common.indentation.right':
    spoken: 'shabber'
    description: 'indent to the right'
    misspellings: ['shammar']
    tags: [']', 'recommended']
    repeatable: true
    action: (input) ->
      @key ']', 'command'
  'core.common.search.nextOccurrence':
    spoken: 'marneck'
    description: 'find the next occurrence of a search term'
    tags: ['application', 'recommended']
    repeatable: true
    action: (input) ->
      @key 'g', 'command'
  'core.common.search.previousOccurrence':
    spoken: 'marpreev'
    description: 'find the previous occurrence of a search term'
    tags: ['application', 'recommended']
    repeatable: true
    action: (input) ->
      @key 'g', 'command shift'
  'core.common.select.all':
    spoken: 'olly'
    description: 'select all'
    tags: ['selection', 'recommended']
    action: ->
      @selectAll()
  'core.common.save':
    spoken: 'sage'
    description: 'file > save'
    tags: ['application', 'recommended']
    action: ->
      @save()
  'core.combo.save-and-switch-application':
    spoken: 'sagewick'
    description: 'file > save'
    tags: ['application', 'combo']
    action: ->
      @save()
      @switchApplication()
  'core.common.close.window':
    spoken: 'totch'
    description: 'close a window or tab'
    tags: ['application', 'window', 'recommended']
    repeatable: true
    action: ->
      @key 'w', 'command'
  'core.common.open.search':
    spoken: 'marco'
    description: 'find'
    tags: ['application', 'recommended']
    action: ->
      @key 'f', 'command'
  'core.common.open.tab':
    spoken: 'talky'
    description: 'open a new tab'
    tags: ['application', 'window', 'recommended']
    misspellings: ['talkie']
    action: ->
      @newTab()
  'core.common.escape': # RENAMING ALERT
  # 'core.actions.negation': # RENAMING ALERT
    spoken: 'randall'
    description: 'Press escape'
    tags: ['key', 'recommended']
    action: ->
      @key 'escape'
  'core.common.key.home': # RENAMING ALERT
    spoken: 'prome'
    description: 'press the home key'
    tags: ['recommended', 'key']
    action: ->
      @key 'home'
  'core.common.key.end': # RENAMING ALERT
    spoken: 'prend'
    description: 'press the end key'
    tags: ['recommended', 'key']
    action: ->
      @key 'end'
