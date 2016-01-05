return unless pack = Packages.get 'darwin'

pack.implement
  'cursor:new-line-below': ->
    @key 'right', 'command'
    @enter()
  'common:new-line-above': ->
    @key "left", "command"
    @enter()
    @up()
  'text-manipulation:nudge-text-left': ->
    @key 'left', 'option'
    @key 'delete'
  'text-manipulation:delete.word.backward': ->
    @key 'delete', 'option'
  'text-manipulation:delete.word.forword': ->
    @key 'forwarddelete', 'option'
