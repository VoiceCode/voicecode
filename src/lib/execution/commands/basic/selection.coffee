Commands.createDisabled
  'shroomway':
    description: 'select all text downward'
    tags: ['selection', 'recommended']
    action: ->
      @key 'down', 'shift command'
  'shroom':
    description: 'shift down, select text by line downward'
    tags: ['selection', 'recommended']
    repeatable: true
    action: ->
      @key 'down', 'shift'
  'shreepway':
    description: 'select all text upward'
    tags: ['selection', 'recommended']
    action: ->
      @key 'up', 'shift command'
  'shreep':
    description: 'shift up, select text by line upward'
    tags: ['selection', 'recommended']
    repeatable: true
    action: ->
      @key 'up', 'shift'
  'shrim':
    description: 'extend selection by character to the left'
    tags: ['selection', 'recommended']
    repeatable: true
    action: ->
      @key 'left', 'shift'
  'shrish':
    description: 'extend selection by character to the right'
    tags: ['selection', 'recommended']
    repeatable: true
    action: ->
      @key 'right', 'shift'
  'scram':
    description: 'extend selection by word to the left'
    tags: ['selection', 'recommended']
    repeatable: true
    action: ->
      @key 'left', 'option shift'
  'scrish':
    description: 'extend selection by word to the right'
    tags: ['selection', 'recommended']
    repeatable: true
    action: ->
      @key 'right', 'option shift'
  'folly':
    description: 'expand selection to block'
    tags: ['text-manipulation']
    misspellings: ['foley', 'fawley']
    action: ->
      if @currentApplication() is 'Sublime Text'
        @key 'l', ['command']
      else
        @selectBlock()
  'spando':
    description: 'expand selection symmetrically (horizontally)'
    grammarType: 'numberCapture'
    tags: ['text-manipulation']
    inputRequired: false
    action: (input) ->
      @symmetricSelectionExpansion(input or 1)
  'bloxy':
    description: 'expand selection vertically, symmetrically'
    grammarType: 'numberCapture'
    tags: ['text-manipulation']
    inputRequired: true
    action: (input) ->
      @verticalSelectionExpansion(input or 1)
  'kerleck':
    description: 'With argument: [word], Will select the text [word] on the current line. With arguments: [word1], [word2], Will select the text starting with the first occurrence of [word1] and ending with the last occurrence of [word2] on the current line'
    grammarType: 'textCapture'
    tags: ['text-manipulation', 'cursor', 'selection']
    inputRequired: true
    action: (input) ->
      @selectCurrentOccurrence(input)
  'jeepleck':
    description: 'With argument: [word], Will select the text [word] previous to the cursor. With arguments: [word1], [word2], Will select the text starting with the last occurrence of [word1] and ending with the last occurrence of [word2] previous to the cursor'
    grammarType: 'textCapture'
    inputRequired: true
    tags: ['text-manipulation', 'cursor', 'selection']
    action: (input) ->
      @selectPreviousOccurrence(input)
  'doomleck':
    description: 'With argument: [word], Will select the text [word] after the cursor. With arguments: [word1], [word2], Will select the text starting with the first occurrence of [word1] and ending with the first occurrence of [word2] after the cursor'
    grammarType: 'textCapture'
    inputRequired: true
    tags: ['text-manipulation', 'cursor', 'selection']
    action: (input) ->
      @selectNextOccurrence(input)
  'wordneck':
    description: 'select the following whole word'
    grammarType: 'numberCapture'
    inputRequired: false
    tags: ['text-manipulation', 'cursor', 'selection']
    action: (input) ->
      switch @currentApplication()
        when 'Sublime Text'
          s = new Contexts.Sublime()
          @repeat input or 1, ->
            s.selectNextWord()
          s.execute()
        when 'Atom'
          @runAtomCommand 'selectNextWord', input or 1
        else
          @selectContiguousMatching
            input: input
            expression: /\w/
            direction: 1
  'wordpreev':
    description: 'select the previous whole word'
    grammarType: 'numberCapture'
    tags: ['text-manipulation', 'cursor', 'selection']
    inputRequired: false
    action: (input) ->
      switch @currentApplication()
        when 'Sublime Text'
          s = new Contexts.Sublime()
          @repeat input or 1, ->
            s.selectPreviousWord()
          s.execute()
        when 'Atom'
          @runAtomCommand 'selectPreviousWord', input or 1
        else
          @selectContiguousMatching
            input: input
            expression: /\w/
            direction: -1

  # 'fuzzneck'
  # 'fuzzpreev': archbrov
  # 'stringneck' => crew coif
  # 'stringpreev' => trail coif
