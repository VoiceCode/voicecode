_.extend Commands.mapping,
  "number":
    kind: "number"
    grammarType: "none"
    description: "not spoken. used indirectly by other commands"
  "gyping":
    kind: "number"
    grammarType: "numberCapture"
    pronunciation: "jipping"
    description: "a number with no space before it"
    tags: ["number", "padded"]
  "gypsy":
    kind: "number"
    grammarType: "numberCapture"
    pronunciation: "jipsee"
    description: "a number with a space before it"
    tags: ["number"]
    padLeft: true
