_.extend Commands.mapping,
  "frank":
    kind: "action"
    grammarType: "textCapture"
    description: "inserts a common abbreviation"
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
  "trassword":
    kind: "action"
    grammarType: "textCapture"
    description: "inserts a password from the predefined passwords list"
    tags: ["text", "utility"]
    contextSensitive: true
    actions: [
      kind: "block"
      transform: (input) ->
        if input?.length
          Scripts.levenshteinMatch CommandoSettings.passwords, input.join(' ')
        else
          ""
    ]
  "treemail":
    kind: "action"
    grammarType: "textCapture"
    description: "inserts an email from the predefined emails list"
    tags: ["text", "utility"]
    contextSensitive: true
    actions: [
      kind: "block"
      transform: (input) ->
        if input?.length
          Scripts.levenshteinMatch CommandoSettings.emails, input.join(' ')
        else
          ""
    ]
  "trusername":
    kind: "action"
    grammarType: "textCapture"
    description: "inserts a username from the predefined usernames list"
    tags: ["text", "utility"]
    contextSensitive: true
    actions: [
      kind: "block"
      transform: (input) ->
        if input?.length
          Scripts.levenshteinMatch CommandoSettings.usernames, input.join(' ')
        else
          ""
    ]
