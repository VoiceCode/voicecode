Commands.createDisabled
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
  "craggle":
    kind: "text"
    grammarType: "textCapture"
    description: "formats spoken arguments in CGUpperCamelCase (automatically inserts the 'CG' part)"
    tags: ["text", "objective-c", "domain-specific"]
    transform: "stud"
    prefix: "CG"
    transformWhenBlank: true
  "lowcoif":
    kind: "action"
    grammarType: "individual"
    tags: ["symbol", "quotes", "objective-c", "domain-specific"]
    description: "inserts objective-c quotes (@\"\") leaving cursor inside them. If text is selected, will wrap the selected text"
    action: ->
      @string '@""'
      @key "Left"
