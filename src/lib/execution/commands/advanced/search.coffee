Commands.createDisabledWithDefaults
  grammarType: "singleSearch"
  tags: ["search", "voicecode", "selection"]
  inputRequired: true
,
  'search.previous.wordOccurrence':
    spoken: 'trail'
    description: "Search backward for the next thing you say, then select it"
    misspellings: ["trailed"]
    action: (input) ->
      term = input?.value or @storage.previousSearchTerm
      if term?.length
        @storage.previousSearchTerm = term
        @selectPreviousOccurrenceWithDistance term, input.distance
  'search.next.wordOccurrence':
    spoken: 'crew'
    description: "Search forward for the next thing you say, then select it"
    misspellings: ["crews", "cruise"]
    action: (input) ->
      term = input?.value or @storage.previousSearchTerm
      if term?.length
        @storage.previousSearchTerm = term
        @selectNextOccurrenceWithDistance term, input.distance

  'search.extendSelection.previous.wordOccurrence':
    spoken: 'seltrail'
    tags: ["search", "voicecode", "selection"]
    description: "Extend the selection backward until the next occurrence of the spoken argument"
    action: (input) ->
      term = input?.value or @storage.previousSearchTerm
      if term?.length
        @storage.previousSearchTerm = term
        @extendSelectionToPreviousOccurrenceWithDistance term, input.distance

  'search.extendSelection.next.wordOccurrence':
    spoken: 'selcrew'
    tags: ["search", "voicecode", "selection"]
    description: "Extend the selection forward until the next occurrence of the spoken argument"
    action: (input) ->
      term = input?.value or @storage.previousSearchTerm
      if term?.length
        @storage.previousSearchTerm = term
        @extendSelectionToFollowingOccurrenceWithDistance term, input.distance

  'search.previous.wordBySurroundingCharacters':
    spoken: 'trapreev'
    tags: ["search", "voicecode", "selection"]
    description: "Select the previous word by its surrounding characters, so the word 'ThxSrndSnd', would be selected by saying 'trapreev teek dell' - useful for unpronounceable or long words"
    action: (input) ->
      term = input?.value or @storage.previousTrapSearchTerm
      if term?.length
        @storage.previousTrapSearchTerm = term
        @selectSurroundedOccurrence
          expression: term
          distance: input.distance or 1
          direction: -1

  'search.next.wordBySurroundingCharacters':
    spoken: "trapneck"
    tags: ["search", "voicecode", "selection"]
    description: "select the next word by its surrounding characters, so the word 'ThxSrndSnd', would be selected by saying 'trapreev teek dell' - useful for unpronounceable or long words"
    action: (input) ->
      term = input?.value or @storage.previousTrapSearchTerm
      if term?.length
        @storage.previousTrapSearchTerm = term
        @selectSurroundedOccurrence
          expression: term
          distance: input.distance
          direction: 1
  'search.next.selectionOccurrence':
    spoken: "nexok"
    kind : "action"
    grammarType : "individual"
    description : "Select next occurrence of select text"
    inputRequired: false
    action : (input) ->
      switch @currentApplication().name
        when "Atom"
          @runAtomCommand "selectNextOccurrence",
            value: null
            distance: 1
        else
          if @canDetermineSelections() and @isTextSelected()
            term = @getSelectedText()
          else
            return
          @selectNextOccurrenceWithDistance term, 1
  "search.previous.selectionOccurrence":
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
      @selectPreviousOccurrenceWithDistance term, 1
