Commands.createDisabled
  'trough':
    description: 'delete a word at a time (press option-delete)'
    tags: ['deleting', 'recommended']
    repeatable: true
    action: ->
      @key 'delete', 'option'
  'steffi':
    description: 'delete a partial word at a time'
    tags: ['deleting']
    repeatable: true
    misspellings: ['steffy']
    action: ->
      current = @currentApplication()
      if current is 'Sublime Text'
        @key 'delete', 'control'
      else if current in ['iTerm', 'iTerm2'] and @mode is 'vim'
        @key 'delete', 'option'
      else if current is 'Emacs' or (current in ['iTerm', 'iTerm2'] and @mode is 'emacs')
        @key 'delete', 'option'
      else
        @deletePartialWord('left')
  'stippy':
    description: 'forward delete a partial word at a time'
    tags: ['deleting']
    repeatable: true
    action: ->
      if @currentApplication() is 'Sublime Text'
        @key 'forwarddelete', 'control'
      else
        @deletePartialWord('right')
  'kite':
    description: 'forward delete a word at a time'
    tags: ['deleting', 'recommended']
    repeatable: true
    action: ->
      @key 'forwarddelete', 'option'
