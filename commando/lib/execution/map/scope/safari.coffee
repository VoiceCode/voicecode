Commands.createDisabled
  "show tabs":
    description: "show all the tabs open in safari"
    tags: ["safari"]
    triggerScopes: ["Safari"]
    action: (input) ->
      @key "\\", 'command shift'