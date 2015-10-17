Commands.createDisabled
  'spring':
    grammarType: 'numberCapture'
    description: 'go to line number.'
    tags: ['sublime', 'xcode']
    triggerScopes: ['Sublime Text', 'Xcode', 'Atom']
    inputRequired: false
    action: (input) ->
      switch @currentApplication()
        when 'Sublime Text'
          if input
            @sublime().goToLine(input).execute()
          else
            @key 'g', 'control'
        when 'Atom'
          if input
            @runAtomCommand 'goToLine', input
          else
            @key 'g', 'control'
        when 'Xcode'
          @key 'l', 'command'
          if input?
            @delay 200
            @string input
            @delay 100
            @enter()

  'sprinkler':
    grammarType: 'numberCapture'
    description: 'go to line number then position cursor at end of line.'
    tags: ['sublime', 'xcode']
    triggerScopes: ['Sublime Text', 'Xcode', 'Atom']
    inputRequired: false
    action: (input) ->
      @do 'spring', input
      if input?
        @do 'ricky'

  'sprinkle':
    grammarType: 'numberCapture'
    description: 'go to line number then position cursor at beginning of line.'
    tags: ['xcode']
    triggerScopes: ['Sublime Text', 'Xcode', 'Atom']
    inputRequired: false
    action: (input) ->
      @do 'spring', input
      if input?
        @do 'lefty'

  'sprinkoon':
    grammarType: 'numberCapture'
    description: 'go to line number then insert a new line below.'
    tags: ['sublime', 'xcode']
    triggerScopes: ['Sublime Text', 'Xcode', 'Atom']
    inputRequired: false
    action: (input) ->
      @do 'spring', input
      if input?
        @do 'shockoon'

  'spackle':
    grammarType: 'numberCapture'
    description: 'go to line number then select entire line.'
    tags: ['sublime']
    triggerScopes: ['Sublime Text', 'Xcode', 'Atom']
    inputRequired: false
    action: (input) ->
      @do 'spring', input
      if input?
        @do 'shackle'

  'bracken':
    description: 'expand selection to quotes, parens, braces, or brackets. (Sublime requires "bracket highlighter" package)'
    tags: ['sublime', 'atom']
    triggerScopes: ['Atom', 'Sublime Text']
    action: (input) ->
      switch @currentApplication()
        when 'Sublime Text'
          @key 's', 'control command option'
        when 'Atom'
          # @runAtomCommand 'trigger', 'expand-selection-to-quotes:toggle'
          @key "'", 'control'

  'selrang':
    grammarType: 'numberCapture'
    description: 'selects text in a line range: selrang ten twenty.'
    tags: ['atom', 'sublime']
    triggerScopes: ['Atom', 'Sublime Text']
    inputRequired: true
    action: (input) ->
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
        switch @currentApplication()
          when 'Sublime Text'
            @sublime().selectRange(first, last).execute()
          when 'Atom'
            @runAtomCommand 'selectLineRange',
              from: first
              to: last

  'seltill':
    grammarType: 'numberCapture'
    description: 'selects text from current position through spoken line number: seltil five five.'
    # TODO remove this misspelling after a few more releases because of command name change
    misspellings: ['seltil']
    tags: ['atom', 'sublime']
    triggerScopes: ['Atom', 'Sublime Text']
    inputRequired: true
    action: (input) ->
      if input?
        switch @currentApplication()
          when 'Sublime Text'
            @sublime()
              .setMark()
              .goToLine(input)
              .selectToMark()
              .clearMark()
              .execute()
          when 'Atom'
            @runAtomCommand 'extendSelectionToLine', input

  'clonesert':
    grammarType: 'numberCapture'
    description: 'Insert the text from another line at the current cursor position'
    tags: ['atom']
    triggerScopes: ['Atom']
    inputRequired: true
    action: (input) ->
      if input?
        switch @currentApplication()
          when 'Atom'
            @runAtomCommand 'insertContentFromLine', input

  'trundle':
    grammarType: 'numberRange'
    tags: ['editing', 'atom', 'sublime']
    description: 'toggle comments on the line or range'
    inputRequired: false
    action: ({first, last} = {}) ->
      switch @currentApplication()
        when 'Sublime Text'
          if last?
            @sublime().selectRange(first, last).execute()
          else if first?
            @sublime().goToLine(first).execute()
          @key '/', 'command'
        when 'Atom'
          if last?
            @runAtomCommand 'selectLineRange',
              from: first
              to: last
          else if first?
            @runAtomCommand 'goToLine', first
          @delay 50
          @key '/', 'command'
