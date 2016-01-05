pack = Packages.register
  name: 'text-manipulation'
  description: ''

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
  'line.move.up':
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
  'line.move.down':
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
