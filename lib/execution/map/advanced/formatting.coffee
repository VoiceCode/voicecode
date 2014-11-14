_.extend Commands.mapping,
  "shark":
    kind: "action"
    grammarType: "textCapture"
    description: "inserts a common abbreviation"
    contextSensitive: true
    actions: [
      kind: "script"
      script: (input) ->
        Scripts.insertAbbreviation((input or []).join(" "))
    ]
