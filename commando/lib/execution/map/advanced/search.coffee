Commands.create
  "trail":
    kind: "action"
    grammarType: "singleSearch"
    description: "search backward for the next thing you say, then select it"
    tags: ["search", "voicecode", "selection"]
    action: (input) ->
      if input?.value?
        @selectPreviousOccurrenceWithDistance input.value, input.distance
  "crew":
    kind: "action"
    grammarType: "singleSearch"
    description: "search forward for the next thing you say, then select it"
    aliases: ["crews", "cruise"]
    tags: ["search", "voicecode", "selection"]
    action: (input) ->
      if input?.value?
        @selectFollowingOccurrenceWithDistance input.value, input.distance
  "seltrail":
    kind: "action"
    grammarType: "singleSearch"
    description: "search backward for the next thing you say, then select from current position until found position"
    tags: ["search", "voicecode", "selection"]
    action: (input) ->
      if input?.value?
        @extendSelectionToPreviousOccurrenceWithDistance input.value, input.distance
  "selcrew":
    kind: "action"
    grammarType: "singleSearch"
    description: "search forward for the next thing you say, then select from current position until found position"
    tags: ["search", "voicecode", "selection"]
    action: (input) ->
      if input?.value?
        @extendSelectionToFollowingOccurrenceWithDistance input.value, input.distance
    