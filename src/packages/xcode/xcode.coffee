Context.register
  name: 'xcode'
  applications: ['Xcode']

pack = Packages.register
  name: 'xcode'
  description: 'Xcode IDE integration'
  context: 'xcode'
  tags: ['xcode']

pack.before
  'editor:move-to-line-number': (input) ->
    @key 'l', 'command'
    if input?
      @delay 200
      @string input
      @delay 100
      @enter()
    @stop()
  'line.move.up': ->
    @key '[', 'command option'
    @stop()
