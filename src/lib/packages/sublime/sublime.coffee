packageInfo = {
  name: 'sublime'
  description: 'Sublime Text integration'
  triggerScopes: ['Sublime Text']
}

_.extend packageInfo,
  description: 'Easy Motion' # RENAMING ALERT

Commands.before 'core.showShortcuts', packageInfo, (index, context) ->
  @key ';', 'command'
  @stop()

Commands.before 'core.duplicate.line', packageInfo, (index, context) ->
  @key 'd', 'command shift'
  @stop()

Commands.before 'core.delete.all.right', packageInfo, (index, context) ->
  @key 'k', 'control'
  @stop()

Commands.before 'core.delete.all.line', packageInfo, ({first, last} = {}) ->
  if last?
    @sublime().selectRange(first, last).execute()
  else if first?
    @sublime().goToLine(first).execute()
  @key 'k', 'control shift'
  @stop()

Commands.before 'core.object.forwards', packageInfo, (index, context) ->
  @key '-', 'control shift'
  @stop()

Commands.before 'core.object.backwards', packageInfo, (index, context) ->
  @key '-', 'control'
  @stop()

# RENAMING ALERT
# should this be an extension of core? will there ever be a core function implementation?
Commands.before 'core.combo.copyUnderMouseAndInsertAtCursor', packageInfo, (index, context) ->
  @doubleClick()
  @delay 200
  @copy()
  @delay 50
  @sublime()
    .jumpBack()
    .jumpBack()
    .execute()
  @paste()
