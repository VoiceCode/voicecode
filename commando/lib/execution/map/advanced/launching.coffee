_.extend Commands.mapping,
  "webs":
    kind: "action"
    grammarType: "textCapture"
    description: "opens a website by name"
    tags: ["system", "launching"]
    actions: [
      kind: "script"
      script: (input) ->
        Scripts.openWebsite((input or []).join(" "))
    ]
