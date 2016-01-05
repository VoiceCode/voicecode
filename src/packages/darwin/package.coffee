return unless pack = Packages.get 'darwin'

pack.implement
  'common:new-line-below': ->
    @key 'right', 'command'
    @enter()
  'common:new-line-above': ->
    @key "left", "command"
    @enter()
    @up()
