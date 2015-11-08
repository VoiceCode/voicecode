packageInfo = {
  name: 'sublime'
  description: 'Sublime Text integration'
  triggerScopes: ['Sublime Text']
}

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
