_.extend Commands.mapping,
  "swash":
    kind: "action"
    grammarType: "oneArgument"
    description: "opens drop-down menu by name"
    tags: ["application", "system"]
    actions: [
      kind: "script"
      script: (input) ->
        Scripts.openDropDown(input)
    ]
