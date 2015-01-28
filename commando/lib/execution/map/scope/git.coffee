_.extend Commands.mapping,
  "git-status":
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
  "git-commit":
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
  "git-add":
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
  "git-diff":
    kind: "action"
    grammarType: "individual"
    description: "git add"
    triggerPhrase: "jet diff"
    tags: ["domain-specific", "git"]
    actions: [
      kind: "block"
      transform: () ->
        "git diff "
    ]
  "git-init":
    kind: "action"
    grammarType: "individual"
    description: "git init"
    triggerPhrase: "jet init"
    tags: ["domain-specific", "git"]
    actions: [
      kind: "block"
      transform: () ->
        "git init "
    ]
  "git-push":
    kind: "action"
    grammarType: "individual"
    description: "git push"
    triggerPhrase: "jet push"
    tags: ["domain-specific", "git"]
    actions: [
      kind: "block"
      transform: () ->
        "git push "
    ]
  "git-rebase":
    kind: "action"
    grammarType: "individual"
    description: "git rebase"
    triggerPhrase: "jet rebase"
    tags: ["domain-specific", "git"]
    actions: [
      kind: "block"
      transform: () ->
        "git rebase "
    ]
  "git-pull":
    kind: "action"
    grammarType: "individual"
    description: "git pull"
    triggerPhrase: "jet pull"
    tags: ["domain-specific", "git"]
    actions: [
      kind: "block"
      transform: () ->
        "git pull "
    ]
