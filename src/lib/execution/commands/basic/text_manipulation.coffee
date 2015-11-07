Commands.createDisabled
  'line.move.up':
    spoken: 'switchy'
    description: 'move current line (or multiline selection) up'
    tags: ['text-manipulation']
    action: (input) ->
      height = @do('select.block').height or 1
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
      height = @do('select.block').height or 1
      @cut()
      @down()
      @paste()
      @repeat height, =>
        @key 'up', 'shift'
