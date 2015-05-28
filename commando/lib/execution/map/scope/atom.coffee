Commands.createDisabled
  "connector":
    description: "connect voicecode to atom"
    tags: ["atom"]
    triggerScopes: ["Atom"]
    action: (input) ->
      @openMenuBarPath(["Packages", "VoiceCode", "Connect"])
  "projector":
    description: "switch projects in Atom"
    tags: ["atom"]
    triggerScopes: ["Atom"]
    action: (input) ->
      @runAtomCommand "trigger", "project-manager:toggle"
  "jumpy":
    description: "open jump-to-symbol dialogue"
    tags: ["atom"]
    # triggerScopes: ["Atom"]
    action: (input) ->
      @runAtomCommand "trigger", "symbols-view:toggle-file-symbols"
  "marthis":
    kind: "action"
    grammarType: "individual"
    tags: ["atom"]
    description: "Use the currently selected text as a search term"
    triggerScope: "Atom"
    action: ->
      @key "e", ["command"]
