Commands.createDisabled
  "trail":
    grammarType: "singleSearch"
    description: "search backward for the next thing you say, then select it"
    tags: ["search", "voicecode", "selection"]
    action: (input) ->
      term = input.value or @storage.previousSearchTerm
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
    grammarType: "singleSearch"
    description: "search forward for the next thing you say, then select it"
    aliases: ["crews", "cruise"]
    tags: ["search", "voicecode", "selection"]
    action: (input) ->
      term = input.value or @storage.previousSearchTerm
      if term?.length
        @storage.previousSearchTerm = term
        switch @currentApplication()
          when "Atom"
            @runAtomCommand "selectNextOccurrence",
              value: term
              distance: input.distance or 1
          else
            @selectFollowingOccurrenceWithDistance term, input.distance

  "seltrail":
    grammarType: "singleSearch"
    description: "search backward for the next thing you say, then select from current position until found position"
    tags: ["search", "voicecode", "selection"]
    action: (input) ->
      term = input.value or @storage.previousSearchTerm
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
    grammarType: "singleSearch"
    description: "search forward for the next thing you say, then select from current position until found position"
    tags: ["search", "voicecode", "selection"]
    action: (input) ->
      term = input.value or @storage.previousSearchTerm
      if term?.length
        @storage.previousSearchTerm = term
        switch @currentApplication()
          when "Atom"
            @runAtomCommand "selectToNextOccurrence",
              value: term
              distance: input.distance or 1
          else
            @extendSelectionToFollowingOccurrenceWithDistance term, input.distance
    