pack = Packages.register
  name: 'sublime'
  description: 'Sublime Text integration'
  applications: [
    'com.sublimetext.3'
    'com.sublimetext.2'
  ]

Settings.extend "editorApplications", pack.applications()

pack.before
  'editor:expand-selection-to-scope': ->
    @key 's', 'control command option'

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

  'select.block': ->
    @key 'l', ['command']

  'line.move.down': ->
    @key 'down', 'control command'

  'line.move.up': ->
    @key 'up', 'control command'

  'editor:move-to-line-number': (input) ->
    if input
      @sublime().goToLine(input).execute()
    else
      @key 'g', 'control'

  'move-to-line-number+way-right': true
  'move-to-line-number+way-left': true
  'insert-under-line-number': true
  'move-to-line-number+select-line': true

  'show-shortcut-markers': ->
    @key ';', 'command'

  'duplicate-selected': ->
    @key 'd', 'command shift'

  'delete.all.right': ->
    @key 'k', 'control'

  'editor:toggle-comments': ({first, last} = {}) ->
    if last?
      @sublime().selectRange(first, last).execute()
    else if first?
      @sublime().goToLine(first).execute()
    @key '/', 'command'

  'delete.all.line': ({first, last} = {}) ->
    if last?
      @sublime().selectRange(first, last).execute()
    else if first?
      @sublime().goToLine(first).execute()
    @key 'k', 'control shift'

  'object.forward': ->
    @key '-', 'control shift'

  'select.word.next': (input) ->
    s = new Contexts.Sublime() #TODO: <-
    @repeat input or 1, ->
      s.selectNextWord()
    s.execute()

  'select.word.previous': (input) ->
    s = new Contexts.Sublime() #TODO: <-
    @repeat input or 1, ->
      s.selectPreviousWord()
    s.execute()

  'editor:extend-selection-to-line-number': (input) ->
    @sublime()
    .setMark()
    .goToLine(input)
    .selectToMark()
    .clearMark()
    .execute()

  'object.backward': ->
    @key '-', 'control'

 'mouse-combo:insert-hovered': ->
    @doubleClick()
    @delay 200
    @copy()
    @delay 50
    @sublime()
      .jumpBack()
      .jumpBack()
      .execute()
    @paste()
