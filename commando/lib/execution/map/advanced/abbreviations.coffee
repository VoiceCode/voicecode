Commands.createDisabled
  "shrink":
    grammarType: "textCapture"
    description: "inserts a common abbreviation"
    tags: ["text", "snippet"]
    action: (input) ->
      if input?.length
        result = @fuzzyMatch Settings.abbreviations, input.join(' ')
        @string result
  "quinn":
    grammarType: "textCapture"
    description: "inserts an IDE code snippet"
    tags: ["text", "snippet"]
    action: (input) ->
      if input?.length
        snippet = @fuzzyMatch Settings.codeSnippets, input.join(" ")
        @string snippet
        @delay 200
        completion = Settings.codeSnippetCompletions[@currentApplication()] or "Tab"
        @key completion
  "trassword":
    grammarType: "textCapture"
    description: "inserts a password from the predefined passwords list"
    tags: ["text", "snippet"]
    action: (input) ->
      if input?.length
        result = @fuzzyMatch Settings.passwords, input.join(' ')
        @string result
  "treemail":
    grammarType: "textCapture"
    description: "inserts an email from the predefined emails list"
    tags: ["text", "snippet"]
    action: (input) ->
      if input?.length
        result = @fuzzyMatch Settings.emails, input.join(' ')
        @string result
  "trusername":
    grammarType: "textCapture"
    description: "inserts a username from the predefined usernames list"
    tags: ["text", "snippet"]
    action: (input) ->
      if input?.length
        result = @fuzzyMatch Settings.usernames, input.join(' ')
        @string result
