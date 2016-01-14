return unless pack = Packages.get 'darwin'

pack.commands
  'application-preferences':
    spoken: 'prefies'
    description: 'Open application preferences'
    action: ->
      @key ',', ['command']

pack.implement
  'os:key': ({key, modifiers}) ->
    @___key key, modifiers

  'os:string': (string) ->
    string = string.toString()
    if string?.length
      if @_capturingText
        @_capturedText += string
      else
        emit 'charactersTyped', string
        if string.length > (Settings.maxStringTypingLength or 9)
          @paste string
        else
          for item in string.split('')
            @delay Settings.characterDelay or 4
            code = @keys.keyCodesRegular[item]
            if code?
              @_pressKey code
            else
              code = @keys.keyCodesShift[item]
              if code?
                @_pressKey code, ["shift"]
  'cursor:new-line-below': ->
    @key 'right', 'command'
    @enter()
  'cursor:new-line-above': ->
    @key "left", "command"
    @enter()
    @up()
  'text-manipulation:nudge-text-left': ->
    @key 'left', 'option'
    @key 'delete'
  'text-manipulation:delete.word.backward': ->
    @key 'delete', 'option'
  'text-manipulation:delete.word.forward': ->
    @key 'forwarddelete', 'option'
  'object:duplicate': ->
    @do 'selection:line.text'
    @copy()
    @right()
    @enter()
    @paste()
