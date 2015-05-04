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
    description: "git commit -a -m ''"
    triggerPhrase: "jet commit"
    action: ->
      @string "git commit -a -m ''"
      @key "Left"
  "git-add":
    description: "git add"
    triggerPhrase: "jet add"
    action: ->
      @string "git add "
  "git-diff":
    description: "git diff"
    triggerPhrase: "jet diff"
    action: ->
      @string "git diff "
  "git-init":
    description: "git init"
    triggerPhrase: "jet in it"
    action: ->
      @string "git init "
  "git-push":
    description: "git push"
    triggerPhrase: "jet push"
    action: ->
      @string "git push "
  "git-rebase":
    description: "git rebase"
    triggerPhrase: "jet rebase"
    action: ->
      @string "git rebase "
  "git-pull":
    description: "git pull"
    triggerPhrase: "jet pull"
    action: ->
      @string "git pull "

_.each git, (value, key) ->
  options = _.extend value,
    grammarType: "individual"
    tags: ["domain-specific", "git"]
  Commands.createDisabled key, options
