_.extend Commands.mapping,
  "creek":
    kind: "action"
    grammarType: "numberCapture"
    description: "repeat last complete spoken phrase [n] times (default 1)"
    contextSensitive: true
    tags: ["system", "voicecode"]
    actions: [
      kind: "script"
      script: (input) ->
        Scripts.generateRepeating(Commands.lastFullCommand or "", (input or 1))
    ]
  "wink":
    kind: "action"
    grammarType: "individual"
    description: "repeat last individual command once"
    aliases: ["tash", "tesh", "tiush", "tosh", "–", "tisch"]
    contextSensitive: true
    ignoreHistory: true
    aliases: ["sun"]
    tags: ["system", "voicecode"]
    actions: [
      kind: "script"
      script: (input) ->
        Commands.lastIndividualCommand or ""
    ]
  "twain":
    kind: "action"
    grammarType: "individual"
    description: "repeat last individual command twice"
    aliases: ["wayne"]
    contextSensitive: true
    ignoreHistory: true
    tags: ["system", "voicecode"]
    actions: [
      kind: "script"
      script: (input) ->
        times = if Commands.repetitionIndex is 0
          2
        else
          1
        Commands.isBeginningOfCommand = false
        Scripts.generateRepeating(Commands.lastIndividualCommand or "", times)
    ]
  "trace":
    kind: "action"
    grammarType: "individual"
    description: "repeat last individual command 3 times"
    contextSensitive: true
    ignoreHistory: true
    tags: ["system", "voicecode"]
    actions: [
      kind: "script"
      script: (input) ->
        times = if Commands.repetitionIndex is 0
          3
        else
          2
        Commands.isBeginningOfCommand = false
        Scripts.generateRepeating(Commands.lastIndividualCommand or "", times)
    ]
  "quarr":
    kind: "action"
    grammarType: "individual"
    description: "repeat last individual command 4 times"
    contextSensitive: true
    ignoreHistory: true
    tags: ["system", "voicecode"]
    actions: [
      kind: "script"
      script: (input) ->
        times = if Commands.repetitionIndex is 0
          4
        else
          3
        Commands.isBeginningOfCommand = false
        Scripts.generateRepeating(Commands.lastIndividualCommand or "", times)
    ]
  "fypes":
    kind: "action"
    grammarType: "individual"
    description: "repeat last individual command 5 times"
    contextSensitive: true
    ignoreHistory: true
    tags: ["system", "voicecode"]
    actions: [
      kind: "script"
      script: (input) ->
        times = if Commands.repetitionIndex is 0
          5
        else
          4
        Commands.isBeginningOfCommand = false
        Scripts.generateRepeating(Commands.lastIndividualCommand or "", times)
    ]
  "repple":
    kind: "action"
    grammarType: "numberCapture"
    description: "Repeats an individual command component. Right after any command say [repple X] to repeat it X times"
    tags: ["system", "voicecode", "repetition"]
    ignoreHistory: true
    contextSensitive: true
    actions: [
      kind: "script"
      script: (times) ->
        n = parseInt(times)
        if n?
          times = if Commands.repetitionIndex is 0
            n or 1
          else
            (n or 1) - 1
          Scripts.generateRepeating(Commands.lastIndividualCommand or "", times)
        else
          ""
    ]
  "recon":
    kind: "action"
    grammarType: "individual"
    description: "show previous commands in Alfred"
    tags: ["system", "voicecode", "alfred"]
    actions: [
      kind: "key"
      key: "Space"
      modifiers: ["option"]
    ,
      kind: "block"
      transform: () ->
        "vc  "
    ]
  "flak":
    kind: "action"
    grammarType: "textCapture"
    description: "execute predefined voice script"
    tags: ["voicecode"]
    contextSensitive: true
    actions: [
      kind: "script"
      script: (input) ->
        if input?.length
          workflow = Scripts.levenshteinMatch CommandoSettings.workflows, input.join(' ')
          chain = new Commands.Chain(workflow + " ")
          chain.generateNestedInterpretation()
        else
          ""
    ]
  "keeper":
    kind: "action"
    grammarType: "none" # treated specially in the grammar
    description: "whatever follows this command will be interpreted literally"
    tags: ["voicecode"]
    contextSensitive: true
    actions: [
      kind: "script"
      script: (input) ->
        if input?
          Scripts.makeTextCommand(input.join(" "))
    ]
  "voicecode-context":
    kind: "action"
    grammarType: "textCapture"
    description: "change voicecode command execution context"
    tags: ["system", "voicecode"]
    triggerPhrase: "context"
    contextSensitive: true
    actions: [
      kind: "script"
      script: (input) ->
        if input?.length
          context = Scripts.levenshteinMatch CommandoSettings.contexts, input.join(' ')
          Commands.context = context
          """
          set theOutputFolder to path to preferences folder from user domain as string
          set plist_file to theOutputFolder & "voicecode.plist"
          set theContext to "#{context}" as string
          try
            tell application "System Events"
              tell property list file plist_file
                tell contents
                  set value of property list item "context" to theContext
                end tell
              end tell
            end tell
          on error
            tell application "System Events"
              if not (exists file plist_file) then
                tell application "System Events"
                  tell (make new property list file with properties {name:plist_file})
                    make new property list item at end with properties {kind:string, name:"context", value:theContext}
                  end tell
                end tell
              end if
            end tell
          end try
          tell application "System Events"
            tell property list file plist_file
              tell contents
                set currentContext to value of property list item "context" as string
                display notification currentContext
              end tell
            end tell
          end tell
          """
        else
          ""
    ]