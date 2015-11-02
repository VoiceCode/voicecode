Commands.createDisabled
  'switchy':
    description: 'move current line (or multiline selection) up'
    tags: ['text-manipulation']
    action: (input) ->
      switch @currentApplication()
        when 'Sublime Text'
          @key 'up', 'control command'
        when 'Atom'
          @key 'up', 'control command'
        when 'Xcode'
          @key '[', 'command option'
        else
          height = @do('folly').height or 1
          @cut()
          @up()
          @paste()
          @repeat height, => 
            @key 'up', 'shift'

  'switcho':
    description: 'move current line (or multiline selection) down'
    tags: ['text-manipulation']
    action: (input) ->
      switch @currentApplication()
        when 'Sublime Text'
          @key 'down', 'control command'
        when 'Atom'
          @key 'down', 'control command'
        when 'Xcode'
          @key ']', 'command option'
        else
          height = @do('folly').height or 1
          @cut()
          @down()
          @paste()
          @repeat height, =>
            @key 'up', 'shift'
