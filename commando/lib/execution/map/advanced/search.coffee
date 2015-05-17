Commands.createDisabled
  "trail":
    grammarType: "singleSearch"
    description: "search backward for the next thing you say, then select it"
    tags: ["search", "voicecode", "selection"]
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
    grammarType: "singleSearch"
    description: "search forward for the next thing you say, then select it"
    aliases: ["crews", "cruise"]
    tags: ["search", "voicecode", "selection"]
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
    grammarType: "singleSearch"
    description: "search backward for the next thing you say, then select from current position until found position"
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
    grammarType: "singleSearch"
    description: "search forward for the next thing you say, then select from current position until found position"
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
    grammarType: "singleSearch"
    description: "search backwards for the next word that starts and ends with the given two letters, i.e. trapreev [char etch] would select the preceding occurrence of 'CoTrSee' - good for unpronounceable words"
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
    grammarType: "singleSearch"
    description: "search forward for the next word that starts and ends with the given two letters, i.e. trapneck [char dell] would select the preceding occurrence of 'cKred' - good for unpronounceable words"
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
