pack = Packages.register
  name: 'common'
  platforms: ['darwin', 'windows', 'linux']
  description: 'Common actions'

pack.commands
  # 'actions.affirmation':
  'enter':
    spoken: 'shock'
    misspellings: ['shocked', 'shox', 'chalk', 'schock']
    description: 'press the return key'
    tags: ['return', 'recommended']
    repeatable: true
    action: (input) ->
      @enter()
  'deletion.backward':
    spoken: 'junk'
    description: 'press the delete key'
    misspellings: ['junks', 'junked']
    tags: ['deleting', 'recommended']
    repeatable: true
    action: (input) ->
      @key 'delete'
  'deletion.forward':
    spoken: 'spunk'
    description: 'pressed the forward delete key'
    tags: ['deleting', 'recommended']
    repeatable: true
    action: (input) ->
      @key 'forwarddelete'
  # 'actions.regret'
  'undo':
    spoken: 'dizzle'
    description: 'undo'
    tags: ['application', 'recommended']
    repeatable: true
    action: (input) ->
      @undo()
  'redo':
    spoken: 'rizzle'
    description: 'redo'
    tags: ['application', 'recommended']
    repeatable: true
    action: (input) ->
      @redo()
  'tab.backward':
    spoken: 'tarp'
    description: 'inserts a tab'
    tags: ['tab', 'recommended']
    repeatable: true
    action: (input) ->
      @key 'tab'
  'tab.forward':
    spoken: 'tarsh'
    description: 'inserts a shift + tab'
    tags: ['tab', 'recommended']
    repeatable: true
    action: (input) ->
      @key 'tab', 'shift'
  'zoom.in':
    spoken: 'shompla'
    description: 'zoom in'
    tags: ['application', 'plus', 'recommended']
    repeatable: true
    action: (input) ->
      @key '=', 'command'
  'zoom.out':
    spoken: 'shaman'
    description: 'zoom out'
    tags: ['application', 'minus', 'recommended']
    repeatable: true
    action: (input) ->
      @key '-', 'command'
  'indentation.left':
    spoken: 'shabble'
    description: 'indent to the left'
    tags: ['[', 'recommended']
    repeatable: true
    action: (input) ->
      @key '[', 'command'
  'indentation.right':
    spoken: 'shabber'
    description: 'indent to the right'
    misspellings: ['shammar']
    tags: [']', 'recommended']
    repeatable: true
    action: (input) ->
      @key ']', 'command'
  'search.nextOccurrence':
    spoken: 'marneck'
    description: 'find the next occurrence of a search term'
    tags: ['application', 'recommended']
    repeatable: true
    action: (input) ->
      @key 'g', 'command'
  'search.previousOccurrence':
    spoken: 'marpreev'
    description: 'find the previous occurrence of a search term'
    tags: ['application', 'recommended']
    repeatable: true
    action: (input) ->
      @key 'g', 'command shift'
  'select.all':
    spoken: 'olly'
    description: 'select all'
    tags: ['selection', 'recommended']
    action: ->
      @selectAll()
  'save':
    spoken: 'sage'
    description: 'file > save'
    tags: ['application', 'recommended']
    action: ->
      @save()
  'combo.save-and-switch-application':
    spoken: 'sagewick'
    description: 'file > save'
    tags: ['application', 'combo']
    action: ->
      @save()
      @switchApplication()
  'close.window':
    spoken: 'totch'
    description: 'close a window or tab'
    tags: ['application', 'window', 'recommended']
    repeatable: true
    action: ->
      @key 'w', 'command'
  'open.search':
    spoken: 'marco'
    description: 'find'
    tags: ['application', 'recommended']
    action: ->
      @key 'f', 'command'
  'open.tab':
    spoken: 'talky'
    description: 'open a new tab'
    tags: ['application', 'window', 'recommended']
    misspellings: ['talkie']
    action: ->
      @newTab()
  'escape':
  # 'actions.negation':
    spoken: 'randall'
    description: 'Press escape'
    tags: ['key', 'recommended']
    action: ->
      @key 'escape'
  'key.home':
    spoken: 'prome'
    description: 'press the home key'
    tags: ['recommended', 'key']
    action: ->
      @key 'home'
  'key.end':
    spoken: 'prend'
    description: 'press the end key'
    tags: ['recommended', 'key']
    action: ->
      @key 'end'
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
  'shift-space':
    spoken: 'sky koosh'
    description: "press shift+space (useful for scrolling up, or other random purposes in certain applications)"
    tags: ["space"]
    repeatable: true
    action: ->
      @key 'space', 'shift'
