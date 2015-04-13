Commands.create
  "tennis":
    kind: "text"
    grammarType: "textCapture"
    description: "formats spoken arguments in NSUpperCamelCase (automatically inserts the 'NS' part)"
    tags: ["text", "objective-c", "domain-specific"]
    transform: "stud"
    prefix: "NS"
    transformWhenBlank: true