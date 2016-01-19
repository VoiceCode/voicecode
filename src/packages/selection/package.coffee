pack = Packages.register
  name: 'selection'
  description: 'Text selection'

_.extend pack, require "./#{global.platform}"

pack.commands
  'all.down':
    spoken: 'shroomway'
    description: 'select all text downward'
    tags: ['selection', 'recommended']
    action: ->
      @key 'down', 'shift command'
  'down':
    spoken: 'shroom'
    description: 'shift down, select text by line downward'
    tags: ['selection', 'recommended']
    repeatable: true
    action: ->
      @key 'down', 'shift'
  'all.up':
    spoken: 'shreepway'
    description: 'select all text upward'
    tags: ['selection', 'recommended']
    action: ->
      @key 'up', 'shift command'
  'up':
    spoken: 'shreep'
    description: 'shift up, select text by line upward'
    tags: ['selection', 'recommended']
    repeatable: true
    action: ->
      @key 'up', 'shift'
  'left':
    spoken: 'shrim'
    description: 'extend selection by character to the left'
    tags: ['selection', 'recommended']
    repeatable: true
    action: ->
      @key 'left', 'shift'
  'right':
    spoken: 'shrish'
    description: 'extend selection by character to the right'
    tags: ['selection', 'recommended']
    repeatable: true
    action: ->
      @key 'right', 'shift'
  'left.word':
    spoken: 'scram'
    description: 'extend selection by word to the left'
    tags: ['selection', 'recommended']
    repeatable: true
    action: ->
      @key 'left', 'option shift'
  'right.word':
    spoken: 'scrish'
    description: 'extend selection by word to the right'
    tags: ['selection', 'recommended']
    repeatable: true
    action: ->
      @key 'right', 'option shift'
  'block':
    spoken: 'folly'
    description: 'expand selection to block'
    tags: ['text-manipulation']
    misspellings: ['foley', 'fawley']
    action: ->
      Packages.get('selection').selectBlock()
  'expand.horizontal':
    spoken: 'spando'
    description: 'expand selection symmetrically (horizontally)'
    grammarType: 'integerCapture'
    tags: ['text-manipulation']
    inputRequired: false
    action: (input) ->
      Packages.get('selection').symmetricSelectionExpansion(input or 1)
  'expand.vertical':
    spoken: 'bloxy'
    description: 'expand selection vertically, symmetrically'
    grammarType: 'integerCapture'
    tags: ['text-manipulation']
    inputRequired: true
    action: (input) ->
      Packages.get('selection').verticalSelectionExpansion(input or 1)
  'range.currentLine':
    spoken: 'kerleck'
    description: 'With argument: [word], Will select the text [word] on
    the current line. With arguments: [word1], [word2], Will select the text
    starting with the first occurrence of [word1] and ending with the last
    occurrence of [word2] on the current line'
    grammarType: 'textCapture'
    tags: ['text-manipulation', 'cursor', 'selection']
    inputRequired: true
    action: (input) ->
      Packages.get('selection').selectCurrentOccurrence(input)
  'range.upward':
    spoken: 'jeepleck'
    description: 'With argument: [word], Will select the text [word]
    previous to the cursor: With arguments: [word1], [word2], Will select
    the text starting with the last occurrence of [word1] and ending with the
    last occurrence of [word2] previous to the cursor'
    grammarType: 'textCapture'
    inputRequired: true
    tags: ['text-manipulation', 'cursor', 'selection']
    action: (input) ->
      Packages.get('selection').selectPreviousOccurrence(input)
  'range.downward':
    spoken: 'doomleck'
    description: 'With argument: [word], Will select the text
    [word] after the cursor: With arguments: [word1], [word2],
    Will select the text starting with the first occurrence of
    [word1] and ending with the first occurrence of [word2] after the cursor'
    grammarType: 'textCapture'
    inputRequired: true
    tags: ['text-manipulation', 'cursor', 'selection']
    action: (input) ->
      Packages.get('selection').selectNextOccurrence(input)
  'word.next':
    spoken: 'wordneck'
    description: 'select the following whole word'
    grammarType: 'integerCapture'
    inputRequired: false
    tags: ['text-manipulation', 'cursor', 'selection']
    action: (input) ->
      Packages.get('selection').selectContiguousMatching
        input: input
        expression: /\w/
        direction: 1
  'word.previous':
    spoken: 'wordpreev'
    description: 'select the previous whole word'
    grammarType: 'integerCapture'
    tags: ['text-manipulation', 'cursor', 'selection']
    inputRequired: false
    action: (input) ->
      Packages.get('selection').selectContiguousMatching
        input: input
        expression: /\w/
        direction: -1
  'all.left':
    spoken: 'lecksy'
    description: 'selects all text to the left'
    tags: ['selection', 'left', 'recommended']
    action: ->
      switch @currentApplication().name
        # TODO: package
        when "Parallels Desktop"
          @key 'home', 'shift'
        else
          @key 'left', 'command shift'
  'line.text':
    spoken: 'shackle'
    description: 'selects the entire line text'
    tags: ['selection', 'recommended']
    misspellings: ['sheqel', 'shikel', 'shekel']
    action: ->
      @key 'left', 'command'
      @key 'right', 'command shift'
  'all.right':
    spoken: 'ricksy'
    description: 'selects all text to the right'
    tags: ['selection', 'right', 'recommended']
    action: ->
      switch @currentApplication().name
        when "Parallels Desktop"
          @key 'end', 'shift'
        else
          @key 'right', 'command shift'
  'all':
    spoken: 'olly'
    description: 'select all'
    tags: ['selection', 'recommended']
    action: ->
      @selectAll() #TODO: fix
  'previous.word-occurrence':
    spoken: 'trail'
    description: "Search backward for the next thing you say, then select it"
    misspellings: ["trailed"]
    grammarType: "singleSearch"
    action: (input) ->
      term = input?.value or
      Actions.storage.previousSearchTerm = term # TODO: un-ugly-fy
      if term?.length
        Actions.storage.previousSearchTerm = term # TODO: un-ugly-fy
        Packages.get('selection').selectPreviousOccurrenceWithDistance term, input.distance
  'next.word-occurrence':
    spoken: 'crew'
    description: "Search forward for the next thing you say, then select it"
    misspellings: ["crews", "cruise"]
    grammarType: "singleSearch"
    action: (input) ->
      term = input?.value or
      Actions.storage.previousSearchTerm = term # TODO: un-ugly-fy
      if term?.length
        Actions.storage.previousSearchTerm = term # TODO: un-ugly-fy
        Packages.get('selection').selectNextOccurrenceWithDistance term, input.distance

  'extend.previous.word-occurrence':
    spoken: 'seltrail'
    tags: ["search", "voicecode", "selection"]
    description: "Extend the selection backward
     until the next occurrence of the spoken argument"
    grammarType: "singleSearch"
    action: (input) ->
      term = input?.value or
      Actions.storage.previousSearchTerm = term # TODO: un-ugly-fy
      if term?.length
        Actions.storage.previousSearchTerm = term # TODO: un-ugly-fy
        Packages.get('selection').extendToPreviousOccurrenceWithDistance term, input.distance

  'extend.next.word-occurrence':
    spoken: 'selcrew'
    tags: ["search", "voicecode", "selection"]
    description: "Extend the selection forward until
     the next occurrence of the spoken argument"
    grammarType: "singleSearch"
    action: (input) ->
      term = input?.value or
      Actions.storage.previousSearchTerm = term # TODO: un-ugly-fy
      if term?.length
        Actions.storage.previousSearchTerm = term # TODO: un-ugly-fy
        Packages.get('selection').extendToFollowingOccurrenceWithDistance term, input.distance

  'previous.word-by-surrounding-characters':
    spoken: 'trapreev'
    tags: ["search", "voicecode", "selection"]
    grammarType: "singleSearch"
    description: "Select the previous word by its surrounding characters,
     so the word 'ThxSrndSnd', would be selected by saying 'trapreev teek dell'
      - useful for unpronounceable or long words"
    action: (input) ->
      term = input?.value or
      Actions.storage.previousSearchTerm = term # TODO: un-ugly-fy
      if term?.length
        Actions.storage.previousSearchTerm = term # TODO: un-ugly-fy
        @selectSurroundedOccurrence
          expression: term
          distance: input.distance or 1
          direction: -1

  'next.word-by-surrounding-characters':
    spoken: "trapneck"
    tags: ["search", "voicecode", "selection"]
    grammarType: "singleSearch"
    description: "select the next word by its surrounding characters,
     so the word 'ThxSrndSnd', would be selected by saying 'trapreev teek dell'
      - useful for unpronounceable or long words"
    action: (input) ->
      term = input?.value or
      Actions.storage.previousSearchTerm = term # TODO: un-ugly-fy
      if term?.length
        Actions.storage.previousSearchTerm = term # TODO: un-ugly-fy
        Packages.get('selection').selectSurroundedOccurrence
          expression: term
          distance: input.distance
          direction: 1
  'next.selection-occurrence':
    spoken: "nexok"
    kind : "action"
    grammarType : "individual"
    description : "Select next occurrence of select text"
    inputRequired: false
    action : (input) ->
      if @canDetermineSelections() and @isTextSelected()
        term = @getSelectedText()
      else
        return
      Packages.get('selection').selectNextOccurrenceWithDistance term, 1
  "previous.selection-occurrence":
    spoken: "privok"
    kind : "action"
    grammarType : "individual"
    description : "Select previous occurrence of selected text"
    inputRequired: false
    action : (input) ->
      if @canDetermineSelections() and @isTextSelected()
        term = @getSelectedText()
      else
        return
      Packages.get('selection').selectPreviousOccurrenceWithDistance term, 1

require "./#{global.platform}"
