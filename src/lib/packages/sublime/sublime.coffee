packageInfo =
  name: 'sublime'
  description: 'Sublime Text integration'
  triggerScopes: ['Sublime Text']

customDescription = ((_.clone packageInfo).description = 'Requires "bracket highlighter" package')
Commands.before 'combo.expandSelectionToScope', customDescription,
  (input, context) ->
    @key 's', 'control command option'
    @stop()

Commands.before 'select.line.range', packageInfo, (input, context) ->
  if input?
    number = input.toString()
    length = Math.floor(number.length / 2)
    first = number.substr(0, length)
    last = number.substr(length, length + 1)
    first = parseInt(first)
    last = parseInt(last)
    if last < first
      temp = last
      last = first
      first = temp

  @sublime().selectRange(first, last).execute()
  @stop()

Commands.before 'select.block', packageInfo, (input, context) ->
  @key 'l', ['command']
  @stop()

Commands.before 'line.move.down', packageInfo, (input, context) ->
  @key 'down', 'control command'
  @stop()

Commands.before 'line.move.up', packageInfo, (input, context) ->
  @key 'up', 'control command'
  @stop()

Commands.before 'cursor.move.lineNumber', packageInfo, (input, context) ->
  if input
    @sublime().goToLine(input).execute()
  else
    @key 'g', 'control'
  @stop()

Commands.before 'showShortcuts', packageInfo, (input, context) ->
  @key ';', 'command'
  @stop()

Commands.before 'duplicate.line', packageInfo, (input, context) ->
  @key 'd', 'command shift'
  @stop()

Commands.before 'delete.all.right', packageInfo, (input, context) ->
  @key 'k', 'control'
  @stop()

Commands.before 'ide.toggleComment', packageInfo, ({first, last} = {}) ->
  if last?
    @sublime().selectRange(first, last).execute()
  else if first?
    @sublime().goToLine(first).execute()
  @key '/', 'command'
  @stop()

Commands.before 'delete.all.line', packageInfo, ({first, last} = {}) ->
  if last?
    @sublime().selectRange(first, last).execute()
  else if first?
    @sublime().goToLine(first).execute()
  @key 'k', 'control shift'
  @stop()

Commands.before 'object.forwards', packageInfo, (input, context) ->
  @key '-', 'control shift'
  @stop()

Commands.before 'select.word.next', packageInfo, (input, context) ->
  s = new Contexts.Sublime() #TODO: <-
  @repeat input or 1, ->
    s.selectNextWord()
  s.execute()
  @stop()

Commands.before 'select.word.previous', packageInfo, (input, context) ->
  s = new Contexts.Sublime() #TODO: <-
  @repeat input or 1, ->
    s.selectPreviousWord()
  s.execute()
  @stop()

Commands.before 'select.untilLineNumber', packageInfo, (input, context) ->
  @sublime()
  .setMark()
  .goToLine(input)
  .selectToMark()
  .clearMark()
  .execute()
  @stop()

Commands.before 'object.backwards', packageInfo, (input, context) ->
  @key '-', 'control'
  @stop()

# RENAMING ALERT
# should this be an extension of core? will there ever be a core function implementation?
Commands.before 'combo.copyUnderMouseAndInsertAtCursor', packageInfo, (input, context) ->
  @doubleClick()
  @delay 200
  @copy()
  @delay 50
  @sublime()
    .jumpBack()
    .jumpBack()
    .execute()
  @paste()
  @stop()
