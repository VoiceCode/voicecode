Commands.createDisabledWithDefaults
  grammarType: "singleSearch"
  tags: ["search", "voicecode", "selection"]
,
  "trail":
    description: "search backward for the next thing you say, then select it"
    action: (input) ->
      term = input?.value or @storage.previousSearchTerm
      if term?.length
        @storage.previousSearchTerm = term
        switch @currentApplication()
          when "Atom"
            @runAtomCommand "selectPreviousOccurrence",
              value: term
              distance: input.distance or 1
          else
            @selectPreviousOccurrenceWithDistance term, input.distance
  "crew":
    description: "search forward for the next thing you say, then select it"
    aliases: ["crews", "cruise"]
    action: (input) ->
      term = input?.value or @storage.previousSearchTerm
      if term?.length
        @storage.previousSearchTerm = term
        switch @currentApplication()
          when "Atom"
            @runAtomCommand "selectNextOccurrence",
              value: term
              distance: input.distance or 1
          else
            @selectNextOccurrenceWithDistance term, input.distance

  "seltrail":
    tags: ["search", "voicecode", "selection"]
    action: (input) ->
      term = input?.value or @storage.previousSearchTerm
      if term?.length
        @storage.previousSearchTerm = term
        switch @currentApplication()
          when "Atom"
            @runAtomCommand "selectToPreviousOccurrence",
              value: term
              distance: input.distance or 1
          else
            @extendSelectionToPreviousOccurrenceWithDistance term, input.distance
  "selcrew":
    tags: ["search", "voicecode", "selection"]
    action: (input) ->
      term = input?.value or @storage.previousSearchTerm
      if term?.length
        @storage.previousSearchTerm = term
        switch @currentApplication()
          when "Atom"
            @runAtomCommand "selectToNextOccurrence",
              value: term
              distance: input.distance or 1
          else
            @extendSelectionToFollowingOccurrenceWithDistance term, input.distance
  "trapreev":
    tags: ["search", "voicecode", "selection"]
    action: (input) ->
      term = input?.value or @storage.previousTrapSearchTerm
      if term?.length
        @storage.previousTrapSearchTerm = term
        switch @currentApplication()
          when "Atom"
            @runAtomCommand "selectSurroundedOccurrence",
              expression: term
              distance: input.distance or 1
              direction: -1
          else
            @selectSurroundedOccurrence
              expression: term
              distance: input.distance or 1
              direction: -1
  "trapneck":
    tags: ["search", "voicecode", "selection"]
    action: (input) ->
      term = input?.value or @storage.previousTrapSearchTerm
      if term?.length
        @storage.previousTrapSearchTerm = term
        switch @currentApplication()
          when "Atom"
            @runAtomCommand "selectSurroundedOccurrence",
              expression: term
              distance: input.distance or 1
              direction: 1
          else
            @selectSurroundedOccurrence
              expression: term
              distance: input.distance
              direction: 1
