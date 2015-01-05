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
        Commands.previous.generated
    ]
