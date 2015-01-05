_.extend Commands.mapping,
  "shellmakedir":
    kind: "action"
    grammarType: "individual"
    description: "make a directory in the shell"
    tags: ["domain-specific", "shell"]
    actions: [
      kind: "keystroke"
      keystroke: "mkdir "
    ]
  "shellseedee":
    kind: "action"
    grammarType: "individual"
    description: "change directory"
    tags: ["domain-specific", "shell"]
    actions: [
      kind: "keystroke"
      keystroke: "cd "
    ]
  "shelless":
    kind: "action"
    grammarType: "textCapture"
    description: "list directory contents (takes dynamic arguments)"
    tags: ["domain-specific", "shell"]
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
