_.extend Commands.mapping,
  "shellmakedir":
    kind: "action"
    grammarType: "individual"
    description: "make a directory in the shell"
    tags: ["domain-specific", "shell"]
    applications: ["iTerm"]
    actions: [
      kind: "keystroke"
      keystroke: "mkdir "
    ]
  "shell-cd":
    kind: "action"
    grammarType: "individual"
    description: "change directory"
    tags: ["domain-specific", "shell"]
    applications: ["iTerm"]
    triggerPhrase: "cd"
    actions: [
      kind: "keystroke"
      keystroke: "cd ; ls"
    ,
      kind: "key"
      key: "Left"
    ,
      kind: "key"
      key: "Left"
    ,
      kind: "key"
      key: "Left"
    ,
      kind: "key"
      key: "Left"
    ]
  "shell-list":
    kind: "action"
    grammarType: "textCapture"
    description: "list directory contents (takes dynamic arguments)"
    tags: ["domain-specific", "shell"]
    applications: ["iTerm"]
    triggerPhrase: "shell list"
    actions: [
      kind: "script"
      script: (input) ->
        options = _.map((input or []), (item) ->
          """
          keystroke " "
          key code "27"
          keystroke "#{item}"
          """
        ).join("\n")
        """
        tell application "System Events"
        keystroke "ls "
        #{options}
        keystroke return
        end tell
        """
    ]
  "shell-history":
    kind: "action"
    grammarType: "numberCapture"
    description: "display the last [n](default all) shell commands executed"
    tags: ["domain-specific", "shell"]
    triggerPhrase: "shell history"
    applications: ["iTerm"]
    actions: [
      kind: "script"
      script: (input) ->
        Scripts.makeTextCommand "history #{input}"
    ,
      kind: "key"
      key: "Return"
    ]
  "shell-recall":
    kind: "action"
    grammarType: "individual"
    description: "hovering the mouse over the left-hand number of a result from the history output, this will re-execute the command"
    tags: ["domain-specific", "shell"]
    triggerPhrase: "shell recall"
    applications: ["iTerm"]
    actions: [
      kind: "key"
      key: "P"
      modifiers: ["command", "option", "control", "shift"]
      delay: 0.1
    ,
      kind: "keystroke"
      keystroke: "!"
    ,
      kind: "key"
      key: "V"
      modifiers: ["command"]
    ,
      kind: "key"
      key: "Return"
    ]
  "shell-edit":
    kind: "action"
    description: "open file in editor"
    grammarType: "individual"
    tags: ["domain-specific", "shell"]
    triggerPhrase: "shell edit"
    applications: ["iTerm"]
    actions: [
      kind: "key"
      key: "O"
      modifiers: ["command", "option", "control", "shift"]
      delay: 0.15
    ,
      kind: "block"
      transform: () ->
        "$EDITOR "
    ,
      kind: "key"
      key: "V"
      modifiers: ["command"]
    ,
      kind: "key"
      key: "Return"
    ]  
  "shell-direct":
    kind: "action"
    grammarType: "textCapture"
    description: "changes directory to any directory in the predefined list"
    tags: ["text", "domain-specific", "shell"]
    applications: ["iTerm"]
    contextSensitive: true
    triggerPhrase: "direct"
    actions: [
      kind: "block"
      transform: (input) ->
        if input?.length
          directory = Scripts.levenshteinMatch CommandoSettings.directories, input.join(' ')
          "cd #{directory} ; ls"
        else
          ""
    ,
      kind: "key"
      key: "Return"
    ]
