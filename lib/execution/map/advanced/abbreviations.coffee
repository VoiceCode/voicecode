_.extend Commands.mapping,
  "shark":
    kind: "action"
    grammarType: "textCapture"
    description: "inserts a common abbreviation"
    aliases: ["sharks"]
    contextSensitive: true
    actions: [
      kind: "script"
      script: (input) ->
        Scripts.insertAbbreviation((input or []).join(" "))
    ]
  "skooshark":
    kind: "action"
    grammarType: "textCapture"
    description: "inserts a common abbreviation preceded by a space"
    contextSensitive: true
    actions: [
      kind: "script"
      script: (input) ->
        Scripts.insertAbbreviation((input or []).join(" "), " ")
    ]