_.extend Commands.mapping,
  "creek":
    kind: "action"
    grammarType: "individual"
    description: "repeat last command"
    contextSensitive: true
    tags: ["system", "voicecode"]
    actions: [
      kind: "script"
      script: (input) ->
        previous = PreviousCommands.find({}, {sort: {createdAt: -1}, limit: 1}).fetch()[0]
        previous?.generated
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