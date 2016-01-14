pack = Packages.register
  name: 'text-manipulation'
  description: 'Various text manipulations'

pack.commands
  'delete.word.backward':
    spoken: 'trough'
    description: 'Delete a word backward'
    tags: ['deleting', 'recommended']
    repeatable: true
  'delete.wordpartial.backward':
    spoken: 'steffi'
    description: 'Delete a partial word backward'
    tags: ['deleting']
    repeatable: true
    misspellings: ['steffy']
    action: ->
      current = @currentApplication().name
      if current is 'Sublime Text' #TODO: fix
        @key 'delete', 'control'
      else if current is 'iTerm' and @mode is 'vim'
        @key 'delete', 'option'
      else if current is 'Emacs' or (current is 'iTerm' and @mode is 'emacs')
        @key 'delete', 'option'
      else
        @deletePartialWord('left')
  'delete.wordpartial.forward':
    spoken: 'stippy'
    description: 'Forward delete a partial word'
    tags: ['deleting']
    repeatable: true
    action: ->
      if @currentApplication().name is 'Sublime Text' #TODO: fix
        @key 'forwarddelete', 'control'
      else
        @deletePartialWord('right')
  'delete.word.forward':
    spoken: 'kite'
    description: 'Forward delete a word'
    tags: ['deleting', 'recommended']
    repeatable: true
  'nudge-text-left':
    spoken: 'nudgle'
    description: 'Remove a space before the adjacent word on the left'
    tags: ['cursor', 'space', 'deleting', 'left', 'combo', 'recommended']
    repeatable: true
    misspellings: ['nigel']
  'move-line-up':
    spoken: 'switchy'
    description: 'move current line (or multiline selection) up'
    tags: ['text-manipulation']
    action: (input) ->
      height = @do('selection:block').height or 1
      @cut()
      @up()
      @paste()
      @repeat height, =>
        @key 'up', 'shift'
  'move-line-down':
    spoken: 'switcho'
    description: 'move current line (or multiline selection) down'
    tags: ['text-manipulation']
    action: (input) ->
      height = @do('selection:block').height or 1
      @cut()
      @down()
      @paste()
      @repeat height, =>
        @key 'up', 'shift'
  'delete-lines':
    spoken: 'snipline'
    description: 'with no arguments will delete the entire line(s).
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
  'delete-to-end-of-line':
    spoken: 'snipper'
    description: 'will delete everything to the right'
    tags: ['deleting', 'right', 'recommended']
    misspellings: ['sniper']
    action: ->
      @key 'right', 'command shift'
      @key 'delete'
  'delete-to-beginning-of-line':
    spoken: 'snipple'
    tags: ['deleting', 'left', 'recommended']
    description: 'will delete everything to the left'
    action: ->
      @key 'delete', 'command'
