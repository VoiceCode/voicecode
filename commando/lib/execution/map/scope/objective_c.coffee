_.extend Commands.mapping,
  "tennis":
    kind: "text"
    grammarType: "textCapture"
    contextSensitive: true
    description: "formats spoke in arguments in NSUpperCamelCase (automatically inserts the 'NS' part)"
    tags: ["text"]
    transform: "nsObjectiveC"