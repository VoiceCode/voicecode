_.extend Commands.mapping,
  "gitstatus":
    kind: "action"
    grammarType: "individual"
    description: "git status"
    triggerPhrase: "jet status"
    tags: ["domain-specific", "git"]
    actions: [
      kind: "block"
      transform: () ->
        "git status "
    ,
      kind: "key"
      key: "Return"
    ]  
  "gitcommit":
    kind: "action"
    grammarType: "individual"
    description: "git commit -a -m ''"
    triggerPhrase: "jet commit"
    tags: ["domain-specific", "git"]
    actions: [
      kind: "block"
      transform: () ->
        "git commit -a -m ''"
    ,
      kind: "key"
      key: "Left"
    ]
  "gitadd":
    kind: "action"
    grammarType: "individual"
    description: "git add"
    triggerPhrase: "jet add"
    tags: ["domain-specific", "git"]
    actions: [
      kind: "block"
      transform: () ->
        "git add "
    ]
