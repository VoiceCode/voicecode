git =
  "jet":
    description: "git"
    action: ->
      @string "git "
  "jet status":
    description: "git status"
    action: ->
      @string "git status"
      switch @currentApplication()
        when "iTerm", "Terminal"
          @key "Return"
          
  "jet commit":
    description: "git commit -a -m ''"
    action: ->
      @string "git commit -a -m ''"
      @key "Left"
  "jet add":
    description: "git add"
    action: ->
      @string "git add "
  "jet diff":
    description: "git diff"
    action: ->
      @string "git diff "
  "jet in it":
    description: "git init"
    action: ->
      @string "git init "
  "jet push":
    description: "git push"
    action: ->
      @string "git push "
  "jet rebase":
    description: "git rebase"
    action: ->
      @string "git rebase "
  "jet pull":
    description: "git pull"
    action: ->
      @string "git pull "

_.each git, (value, key) ->
  options = _.extend value,
    grammarType: "individual"
    tags: ["domain-specific", "git"]
  Commands.createDisabled key, options
