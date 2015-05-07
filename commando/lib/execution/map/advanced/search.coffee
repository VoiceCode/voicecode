Commands.createDisabled
  "trail":
    grammarType: "singleSearch"
    description: "search backward for the next thing you say, then select it"
    tags: ["search", "voicecode", "selection"]
    action: (input) ->
      if input?.value?
        switch @currentApplication()
          when "Atom"
            @runAtomCommand "selectPreviousOccurrence",
              value: input.value
              distance: input.distance or 1
          else
            @selectPreviousOccurrenceWithDistance input.value, input.distance
  "crew":
    grammarType: "singleSearch"
    description: "search forward for the next thing you say, then select it"
    aliases: ["crews", "cruise"]
    tags: ["search", "voicecode", "selection"]
    action: (input) ->
      if input?.value?
        switch @currentApplication()
          when "Atom"
            @runAtomCommand "selectNextOccurrence",
              value: input.value
              distance: input.distance or 1
          else
            @selectFollowingOccurrenceWithDistance input.value, input.distance

  "seltrail":
    grammarType: "singleSearch"
    description: "search backward for the next thing you say, then select from current position until found position"
    tags: ["search", "voicecode", "selection"]
    action: (input) ->
      if input?.value?
        switch @currentApplication()
          when "Atom"
            @runAtomCommand "selectToPreviousOccurrence",
              value: input.value
              distance: input.distance or 1
          else
            @extendSelectionToPreviousOccurrenceWithDistance input.value, input.distance
  "selcrew":
    grammarType: "singleSearch"
    description: "search forward for the next thing you say, then select from current position until found position"
    tags: ["search", "voicecode", "selection"]
    action: (input) ->
      if input?.value?
        switch @currentApplication()
          when "Atom"
            @runAtomCommand "selectToNextOccurrence",
              value: input.value
              distance: input.distance or 1
          else
            @extendSelectionToFollowingOccurrenceWithDistance input.value, input.distance
    