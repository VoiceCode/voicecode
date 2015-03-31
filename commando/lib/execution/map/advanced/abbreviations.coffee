_.extend Commands.mapping,
  "frank":
    kind: "action"
    grammarType: "textCapture"
    description: "inserts a common abbreviation"
    tags: ["text"]
    aliases: ["franca"]
    contextSensitive: true
    actions: [
      kind: "script"
      script: (input) ->
        if input?.length
          result = Scripts.levenshteinMatch CommandoSettings.abbreviations, input.join(' ')
          Scripts.makeTextCommand result
        else
          ""
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
        if input?.length
          result = Scripts.levenshteinMatch CommandoSettings.abbreviations, input.join(' ')
          Scripts.makeTextCommand " #{result}"
        else
          ""
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
      kind: "script"
      script: (input) ->
        if input?.length
          result = Scripts.levenshteinMatch CommandoSettings.passwords, input.join(' ')
          Scripts.makeTextCommand result
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
      kind: "script"
      script: (input) ->
        if input?.length
          result = Scripts.levenshteinMatch CommandoSettings.emails, input.join(' ')
          Scripts.makeTextCommand result
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
      kind: "script"
      script: (input) ->
        if input?.length
          result = Scripts.levenshteinMatch CommandoSettings.usernames, input.join(' ')
          Scripts.makeTextCommand result
        else
          ""
    ]
