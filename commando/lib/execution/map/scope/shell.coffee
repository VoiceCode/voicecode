_.extend Commands.mapping,
  "shell-cd":
    kind: "action"
    grammarType: "individual"
    description: "change directory"
    tags: ["domain-specific", "shell"]
    triggerScope: "iTerm"
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
    triggerScope: "iTerm"
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
    triggerScope: "iTerm"
    actions: [
      kind: "text"
      text: (input) -> "history #{input}"
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
    triggerScope: "iTerm"
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
    triggerScope: "iTerm"
    actions: [
      kind: "key"
      key: "O"
      modifiers: ["command", "option", "control", "shift"]
      delay: 0.15
    ,
      kind: "keystroke"
      keystroke: "$EDITOR "
    ,
      kind: "key"
      key: "V"
      modifiers: ["command"]
    ,
      kind: "key"
      key: "Return"
    ]  
  "durrup":
    kind: "action"
    description: "navigate to the parent directory"
    grammarType: "individual"
    tags: ["domain-specific", "shell"]
    triggerScope: "iTerm"
    actions: [
      kind: "keystroke"
      keystroke: "cd ..; ls \n"
    ]  
  "shell-direct":
    kind: "action"
    grammarType: "textCapture"
    description: "changes directory to any directory in the predefined list"
    tags: ["text", "domain-specific", "shell"]
    contextSensitive: true
    triggerPhrase: "direct"
    contextualActions:
      "terminal": 
        requirements: [
          application: "iTerm"
        ,
          application: "Terminal"
        ]
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
    actions: [
      kind: "script"
      script: (input) ->
        Scripts.openApplication("iTerm")
      delay: 0.5
    ,
      kind: "key"
      key: "T"
      modifiers: ["command"]
      delay: 0.5
    ,
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
  "shell":
    kind: "action"
    grammarType: "textCapture"
    description: "insert a shell command from the predefined shell commands list"
    tags: ["text", "shell"]
    contextSensitive: true
    aliases: ["shall"]
    actions: [
      kind: "text"
      text: (input) ->
        if input?.length
          Scripts.levenshteinMatch CommandoSettings.shellCommands, input.join(' ')
        else
          ""
    ]
