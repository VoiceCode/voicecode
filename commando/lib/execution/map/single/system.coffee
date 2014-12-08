_.extend Commands.mapping,
  "swash":
    kind: "action"
    grammarType: "oneArgument"
    description: "opens drop-down menu by name"
    actions: [
      kind: "script"
      script: (input) ->
        Scripts.openDropDown(input)
    ]
