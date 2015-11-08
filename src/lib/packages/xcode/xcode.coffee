packageInfo =
  name: 'xcode'
  description: 'Xcode IDE integration'
  triggerScopes: ['Xcode']
  tags: ['xcode']

Commands.before 'cursor.move.lineNumber', packageInfo, (input, context) ->
  @key 'l', 'command'
  if input?
    @delay 200
    @string input
    @delay 100
    @enter()
  @stop()

Commands.before 'line.move.up', packageInfo, (input, context) ->
  @key '[', 'command option'
  @stop()
