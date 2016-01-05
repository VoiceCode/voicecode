_a = global.Actions

module.exports =
  selectCurrentOccurrence: (input) ->
    emit 'notUndoable'
    if input?.length
      first = input[0]
      last = input[1]
      _a.key 'left', 'command'
      _a.key 'right', 'command shift'
      clipboard = _a.getSelectedText().toLowerCase()
      if last?.length and clipboard.indexOf(last) >= 0 and clipboard.indexOf(first) >= 0
        totalLength = clipboard?.length
        firstResults = clipboard.split(first)
        distanceLeft = firstResults[0]?.length or 0
        lastResults = clipboard.split(last)
        distanceRight = lastResults[lastResults.length - 1]?.length or 0
        _a.left()
        _a.right distanceLeft

        width = totalLength - distanceLeft - distanceRight
        _a.repeat width, =>
          _a.key 'right', 'shift'
      else if clipboard.indexOf(first) >= 0
        totalLength = clipboard?.length
        firstResults = clipboard.split(first)
        distanceLeft = firstResults[0]?.length or 0
        _a.left()
        _a.right distanceLeft

        width = first.length
        _a.repeat width, =>
          _a.key 'right', 'shift'
  selectPreviousOccurrence: (input) ->
    emit 'notUndoable'
    if input?.length
      first = input[0]
      last = input[1]
      _a.left()
      _a.right()
      _a.repeat 20, => _a.key 'up', 'shift'
      clipboard = _a.getSelectedText().toLowerCase()
      if last?.length and clipboard.indexOf(last) >= 0 and clipboard.indexOf(first) >= 0
        totalLength = clipboard?.length
        firstResults = clipboard.split(first)
        distanceLeft = firstResults[0]?.length or 0
        lastResults = clipboard.split(last)
        distanceRight = lastResults[lastResults.length - 1]?.length or 0
        _a.right()
        _a.left(distanceRight)

        width = distanceLeft - first.length - distanceRight
        _a.repeat width, =>
          _a.key 'left', 'shift'
      else if clipboard.indexOf(first) >= 0
        totalLength = clipboard?.length
        firstResults = clipboard.split(first)
        distanceRight = firstResults[firstResults.length - 1]?.length or 0
        _a.right()
        _a.left(distanceRight)
        width = first.length
        _(width).times =>
          _a.key 'left', 'shift'
      else
        _a.right()
  selectNextOccurrence: (input) ->
    emit 'notUndoable'
    if input?.length
      first = input[0]
      last = input[1]
      _a.right()
      _a.left()
      _(20).times => _a.key 'down', 'shift'
      clipboard = _a.getSelectedText().toLowerCase()
      if last?.length and clipboard.indexOf(last) >= 0 and clipboard.indexOf(first) >= 0
        totalLength = clipboard?.length
        firstResults = clipboard.split(first)
        distanceLeft = firstResults[0]?.length or 0
        lastResults = clipboard.split(last)
        distanceRight = lastResults[lastResults.length - 1]?.length or 0
        _a.left()
        _a.right(distanceLeft)

        width = totalLength - distanceLeft - distanceRight
        _(width).times =>
          _a.key 'right', 'shift'
      else if clipboard.indexOf(first) >= 0
        firstResults = clipboard.split(first)
        distanceLeft = firstResults[0]?.length or 0
        _a.left()
        _a.right(distanceLeft)

        width = first.length
        _(width).times =>
          _a.key 'right', 'shift'
      else
        _a.left()

  selectNextOccurrenceWithDistance: (phrase, distance) ->
    emit 'notUndoable'
    if phrase?.length
      distance = (distance or 1)
      _a.left()
      _a.right()
      _(20).times => _a.key 'down', 'shift'
      selected = _a.getSelectedText().toLowerCase()
      if selected.indexOf(phrase) >= 0
        results = selected.split(phrase)
        distanceLeft = results.splice(0, distance).join(phrase).length
        _a.left()
        _a.right(distanceLeft)
        width = phrase.length
        _(width).times =>
          _a.key 'right', 'shift'
      else
        _a.left()

  selectPreviousOccurrenceWithDistance: (phrase, distance) ->
    emit 'notUndoable'
    if phrase?.length
      distance = (distance or 1)
      _a.right()
      _a.left()
      _(20).times => _a.key 'up', 'shift'
      selected = _a.getSelectedText().toLowerCase()
      if selected.indexOf(phrase) >= 0
        results = selected.split(phrase).reverse()
        distanceLeft = results.splice(0, distance).join(phrase).length
        _a.right()
        _a.left(distanceLeft)
        width = phrase.length
        _(width).times =>
          _a.key 'left', 'shift'
      else
        _a.right()

  extendToFollowingOccurrenceWithDistance: (phrase, distance) ->
    emit 'notUndoable'
    if phrase?.length
      if _a.canDetermineSelections() and _a.isTextSelected()
        existing = _a.getSelectedText()
      distance = (distance or 1)
      _(20).times => _a.key 'down', 'shift'
      selected = _a.getSelectedText().toLowerCase()
      _a.left()
      if existing? and selected.indexOf(existing) is 0
        selected = selected.slice(existing.length)
        _(existing.length).times =>
          _a.key 'right', 'shift'
      if selected.indexOf(phrase) >= 0
        results = selected.split(phrase)
        distanceLeft = results.splice(0, distance).join(phrase).length
        _(distanceLeft).times =>
          _a.key 'right', 'shift'
        width = phrase.length
        _(width).times =>
          _a.key 'right', 'shift'

  extendToPreviousOccurrenceWithDistance: (phrase, distance) ->
    emit 'notUndoable'
    if phrase?.length
      if _a.canDetermineSelections() and _a.isTextSelected()
        existing = _a.getSelectedText()
      distance = (distance or 1)
      _(20).times => _a.key 'up', 'shift'
      selected = _a.getSelectedText().toLowerCase()
      _a.right()
      if existing? and selected.indexOf(existing) is (selected.length - existing.length)
        selected = selected.slice(0, selected.length - existing.length)
        _(existing.length).times =>
          _a.key 'left', 'shift'
      if selected.indexOf(phrase) >= 0
        results = selected.split(phrase).reverse()
        distanceLeft = results.splice(0, distance).join(phrase).length
        _(distanceLeft).times =>
          _a.key 'left', 'shift'
        width = phrase.length
        _(width).times =>
          _a.key 'left', 'shift'
  symmetricSelectionExpansion: (number) ->
    emit 'notUndoable'
    _a.copy()
    _a.delay 100
    clipboard = _a.getClipboard()
    length = clipboard?.length or 0
    _a.left()
    _a.left number
    _a.repeat number * 2 + length, =>
      _a.key 'right', 'shift'

  selectContiguousMatching: (params) ->
    distance = (parseInt(params.input) or 1) - 1
    expression = params.expression or /\w/
    direction = params.direction or 1
    splitterExpression = params.splitterExpression

    if direction > 0
      horizontalForward = 'right'
      horizontalBackward = 'left'
      verticalForward = 'down'
    else
      horizontalForward = 'left'
      horizontalBackward = 'right'
      verticalForward = 'up'

    emit 'notUndoable'

    if _a.canDetermineSelections() and _a.isTextSelected()
      _a.key horizontalForward

    _a.key verticalForward, 'shift'
    _a.key verticalForward, 'shift'
    _a.key horizontalForward, 'shift command'

    selection = if direction > 0
      _a.getSelectedText()
    else
      _s.reverse _a.getSelectedText()

    results = []
    start = undefined
    selecting = false
    for item, index in selection.split('')
      if item.match(expression)
        if splitterExpression? and item.match(splitterExpression)
          if selecting
            results.push [start, index]
            results.push [index, index + 1]
            selecting = false
            start = undefined
          else
            results.push [index, index + 1]
        else
          selecting = true
          start ?= index
      else
        if selecting
          results.push [start, index]
          selecting = false
          start = undefined

    _a.key horizontalBackward

    if results[distance]?
      span = results[distance][1] - results[distance][0]
      _(results[distance][0]).times =>
        _a.key horizontalForward
      _(span).times =>
        _a.key horizontalForward, 'shift'


  selectSurroundedOccurrence: (params) ->
    distance = (parseInt(params.input) or 1) - 1
    expression = params.expression
    return unless expression?.length

    direction = params.direction or 1

    if direction > 0
      horizontalForward = 'right'
      horizontalBackward = 'left'
      verticalForward = 'down'
    else
      horizontalForward = 'left'
      horizontalBackward = 'right'
      verticalForward = 'up'

    emit 'notUndoable'

    if _a.canDetermineSelections() and _a.isTextSelected()
      _a.key horizontalForward

    _a.key verticalForward, 'shift'
    _a.key verticalForward, 'shift'
    _a.key verticalForward, 'shift'
    _a.key verticalForward, 'shift'
    _a.key horizontalForward, 'shift command'

    selection = if direction > 0
      _a.getSelectedText()
    else
      _s.reverse _a.getSelectedText()

    if direction is 1
      first = expression[0]
      last = expression[expression.length - 1]
    else
      last = expression[0]
      first = expression[expression.length - 1]

    results = []
    start = undefined
    selecting = false
    canStart = true
    candidate = null
    for item, index in selection.split('')
      if item is first and not selecting and canStart
        start = index
        selecting = true
        canStart = false
      else if item is last and selecting and start != index
        candidate = [start, index + 1]
      else if item.match(/\w/)
        canStart = false
        candidate = null
      else
        if selecting and candidate
          results.push candidate
        start = null
        candidate = null
        selecting = false
        canStart = true

    _a.key horizontalBackward

    if results[distance]?
      span = results[distance][1] - results[distance][0]
      _(results[distance][0]).times =>
        _a.key horizontalForward
      _(span).times =>
        _a.key horizontalForward, 'shift'


  selectBlock: ->
    emit 'notUndoable'
    clipboard = if _a.canDetermineSelections() and _a.isTextSelected()
      _a.getSelectedText()
    else
      ""
    match = clipboard.match(/\r/g)
    numberOfLines = (match?.length or 0) + 1
    if clipboard.charAt(clipboard.length - 1).match(/\r/)
      numberOfLines -= 1
    _a.key 'left', 'command'
    _(numberOfLines).times => _a.key 'down', 'shift'

    # return some info in case someone wants to do something with it
    {
      height: numberOfLines
    }
