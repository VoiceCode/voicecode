git =
  "git-base":
    description: "git"
    triggerPhrase: "jet"
    action: ->
      @string "git "
  "git-status":
    description: "git status"
    triggerPhrase: "jet status"
    action: ->
      @string "git status \n"
  "git-commit":
    kind: "action"
    description: "git commit -a -m ''"
    triggerPhrase: "jet commit"
    action: ->
      @string "git commit -a -m ''"
      @key "Left"
  "git-add":
    kind: "action"
    description: "git add"
    triggerPhrase: "jet add"
    action: ->
      @string "git add "
  "git-diff":
    kind: "action"
    description: "git diff"
    triggerPhrase: "jet diff"
    action: ->
      @string "git diff "
  "git-init":
    kind: "action"
    description: "git init"
    triggerPhrase: "jet in it"
    action: ->
      @string "git init "
  "git-push":
    kind: "action"
    description: "git push"
    triggerPhrase: "jet push"
    action: ->
      @string "git push "
  "git-rebase":
    kind: "action"
    description: "git rebase"
    triggerPhrase: "jet rebase"
    action: ->
      @string "git rebase "
  "git-pull":
    kind: "action"
    description: "git pull"
    triggerPhrase: "jet pull"
    action: ->
      @string "git pull "

_.each git, (value, key) ->
  options = _.extend value,
    kind: "action"
    grammarType: "individual"
    tags: ["domain-specific", "git"]
  Commands.create key, options
