Commands.create
  "tennis":
    kind: "text"
    grammarType: "textCapture"
    description: "formats spoken arguments in NSUpperCamelCase (automatically inserts the 'NS' part)"
    tags: ["text", "objective-c", "domain-specific"]
    transform: "stud"
    prefix: "NS"
    transformWhenBlank: true
  "youey":
    kind: "text"
    grammarType: "textCapture"
    description: "formats spoken arguments in UIUpperCamelCase - automatically inserts the 'UI' part. (pronounced like U-turn)"
    tags: ["text", "objective-c", "domain-specific"]
    transform: "stud"
    prefix: "UI"
    transformWhenBlank: true
