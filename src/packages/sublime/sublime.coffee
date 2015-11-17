Context.register
  name: 'sublime'
  applications: ['Sublime Text']

pack = Packages.register
  name: 'sublime'
  description: 'Sublime Text integration'
  context: 'sublime'

pack.before
 'editor:expand-selection-to-scope': ->
    @key 's', 'control command option'
    @stop()

 'editor:select-line-number-range': (input) ->
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

 'select.block': ->
    @key 'l', ['command']
    @stop()

 'line.move.down': ->
    @key 'down', 'control command'
    @stop()

 'line.move.up': ->
    @key 'up', 'control command'
    @stop()

 'editor:move-to-line-number': (input) ->
    if input
      @sublime().goToLine(input).execute()
    else
      @key 'g', 'control'
    @stop()

 'showShortcuts': ->
    @key ';', 'command'
    @stop()

 'duplicate-current-line': ->
    @key 'd', 'command shift'
    @stop()

 'delete.all.right': ->
    @key 'k', 'control'
    @stop()

 'editor:toggle-comments': ({first, last} = {}) ->
    if last?
      @sublime().selectRange(first, last).execute()
    else if first?
      @sublime().goToLine(first).execute()
    @key '/', 'command'
    @stop()

 'delete.all.line': ({first, last} = {}) ->
    if last?
      @sublime().selectRange(first, last).execute()
    else if first?
      @sublime().goToLine(first).execute()
    @key 'k', 'control shift'
    @stop()

 'object.forward': ->
    @key '-', 'control shift'
    @stop()

 'select.word.next': (input) ->
    s = new Contexts.Sublime() #TODO: <-
    @repeat input or 1, ->
      s.selectNextWord()
    s.execute()
    @stop()

 'select.word.previous': (input) ->
    s = new Contexts.Sublime() #TODO: <-
    @repeat input or 1, ->
      s.selectPreviousWord()
    s.execute()
    @stop()

 'editor:extend-selection-to-line-number': (input) ->
    @sublime()
    .setMark()
    .goToLine(input)
    .selectToMark()
    .clearMark()
    .execute()
    @stop()

 'object.backward': ->
    @key '-', 'control'
    @stop()

# TODO RENAMING ALERT
# should this be an extension of core? will there ever be a core function implementation?
 'combo.copyUnderMouseAndInsertAtCursor': ->
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
