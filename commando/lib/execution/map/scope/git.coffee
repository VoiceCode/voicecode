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

  "jet add": {}
  "jet bisect": {}
  "jet branch": {}
  "jet check out":
    git_command: "git checkout"
  "jet clone": {}
  "jet cherry pick":
    git_command: "git cherry-pick"
  "jet diff": {}
  "jet fetch": {}
  "jet in it":
    git_command: "git init"
  "jet log": {}
  "jet merge": {}
  "jet move":
    git_command: "git mv"
  "jet pull": {}
  "jet push": {}
  "jet rebase": {}
  "jet reset": {}
  "jet remove":
    git_command: "git rm"
  "jet show": {}
  "jet tag": {}

_.each git, (value, key) ->
  options = _.extend value,
    grammarType: "individual"
    tags: ["domain-specific", "git"]

  if not options.git_command?
    options.git_command = key.replace("jet", "git")

  if not options.description?
    options.description = options.git_command

  if not options.action?
    options.action = ->
      @string (options.git_command + " ")
    
  Commands.createDisabled key, options
