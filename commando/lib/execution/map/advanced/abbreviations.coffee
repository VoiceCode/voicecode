_.extend Commands.mapping,
  "frank":
    kind: "action"
    grammarType: "textCapture"
    description: "inserts a common abbreviation"
    aliases: ["sharks"]
    tags: ["text"]
    contextSensitive: true
    actions: [
      kind: "script"
      script: (input) ->
        Scripts.insertAbbreviation((input or []).join(" "))
    ]
  "skoofrank":
    kind: "action"
    grammarType: "textCapture"
    description: "inserts a common abbreviation preceded by a space"
    contextSensitive: true
    tags: ["text"]
    actions: [
      kind: "script"
      script: (input) ->
        Scripts.insertAbbreviation((input or []).join(" "), " ")
    ]
  "quinn":
    kind: "action"
    grammarType: "textCapture"
    description: "inserts an IDE code snippet"
    contextSensitive: true
    tags: ["text"]
    actions: [
      kind: "script"
      script: (input) ->
        Scripts.codeSnippet((input or []).join(" "))
    ]
