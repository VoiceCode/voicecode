Commands.createDisabled
  'delete.word.backward':
    spoken: 'trough'
    description: 'Delete a word at a time (press option-delete)'
    tags: ['deleting', 'recommended']
    repeatable: true
    action: ->
      @key 'delete', 'option'
  'delete.wordpartial.backward':
    spoken: 'steffi'
    description: 'Delete a partial word at a time'
    tags: ['deleting']
    repeatable: true
    misspellings: ['steffy']
    action: ->
      current = @currentApplication()
      if current is 'Sublime Text'
        @key 'delete', 'control'
      else if current is 'iTerm' and @mode is 'vim'
        @key 'delete', 'option'
      else if current is 'Emacs' or (current is 'iTerm' and @mode is 'emacs')
        @key 'delete', 'option'
      else
        @deletePartialWord('left')
  'delete.wordpartial.forward':
    spoken: 'stippy'
    description: 'Forward delete a partial word at a time'
    tags: ['deleting']
    repeatable: true
    action: ->
      if @currentApplication() is 'Sublime Text'
        @key 'forwarddelete', 'control'
      else
        @deletePartialWord('right')
  'delete.word.forward':
    spoken: 'kite'
    description: 'forward delete a word at a time'
    tags: ['deleting', 'recommended']
    repeatable: true
    action: ->
      @key 'forwarddelete', 'option'
