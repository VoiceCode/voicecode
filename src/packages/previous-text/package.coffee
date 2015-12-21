pack = Packages.register
  name: 'previous-text'
  description: 'Smart undo, selection, or altering previous spoken phrase'

previousCharacterCount = 0
currentCharacterCount = 0

ignoreNotUndoable = false

Events.on 'chainWillExecute', ->
  previousCharacterCount = currentCharacterCount
  currentCharacterCount = 0

Events.on 'commandWillExecute', ->
  # nothing for now

Events.on 'commandDidExecute', ->
  # nothing for now

Events.on 'startUndoable', ->
  ignoreNotUndoable = true

Events.on 'stopUndoable', ->
  ignoreNotUndoable = false

Events.on 'notUndoable', ->
  unless ignoreNotUndoable
    currentCharacterCount = 0
    previousCharacterCount = 0

Events.on 'charactersTyped', (string) ->
  debug 'charactersTyped', string
  currentCharacterCount += (string?.length or 0)

pack.commands
  'delete':
    spoken: "scratchy"
    description: "tries to do a 'smart' undo by deleting previously
     inserted characters if the previous command only inserted text"
    tags: ["recommended"]
    action: () ->
      count = previousCharacterCount
      if count? and count > 0
        if @contextAllowsArrowKeyTextSelection()
          @repeat count, =>
            @key 'left', 'shift'
          @key "delete"
        else
          @repeat count, =>
            @key 'delete'
  'select':
    spoken: "tragic"
    description: "tries to select the previously inserted text if possible"
    tags: ["recommended"]
    action: () ->
      count = previousCharacterCount
      if count? and count > 0
        for i in [1..count]
          @key 'left', 'shift'

  'space-before':
    spoken: 'poser'
    description: "puts a space before the previously spoken text
     (only if it is the next command after the text was spoken)"
    action: ->
      count = previousCharacterCount
      debug 'count', count
      if count? and count > 0
        @left(count)
        @space()
        @right(count)
