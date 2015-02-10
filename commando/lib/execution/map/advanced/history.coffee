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
    description: "repeat last command"
    tags: ["system", "voicecode"]
    actions: [
      kind: "key"
      key: "Space"
      modifiers: ["option"]
    ,
      kind: "block"
      transform: () ->
        "vc  "
    ]
