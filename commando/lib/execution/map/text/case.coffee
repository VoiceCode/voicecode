_.extend Commands.mapping,
  "literal":
    kind: "text"
    grammarType: "textCapture"
    description: "words with spaces between"
    tags: ["text"]
    transform: "literal"
  "cram":
    kind: "text"
    grammarType: "textCapture"
    description: "camelCaseText"
    tags: ["text"]
    transform: "camel"
    aliases: ["crammed", "crams", "tram"]
  "decram":
    kind: "text"
    grammarType: "textCapture"
    description: "space camelCaseText"
    tags: ["text"]
    transform: "camel"
    padLeft: true
  "snake":
    kind: "text"
    grammarType: "textCapture"
    description: "snake_case_text"
    tags: ["text"]
    transform: "snake"
  "coalsnik":
    kind: "text"
    grammarType: "textCapture"
    description: ":snake_case_with_a_colon_at_the_front"
    tags: ["text"]
    transform: "rubySymbol"
  "lowcram":
    kind: "text"
    grammarType: "textCapture"
    description: "@camelCaseWithAtSign"
    tags: ["text"]
    transform: "@camelCase"
  "deznik":
    kind: "text"
    grammarType: "textCapture"
    description: "space snake_case_text"
    tags: ["text"]
    transform: "snake"
    padLeft: true
  "spine":
    kind: "text"
    grammarType: "textCapture"
    description: "spinal-case-text"
    tags: ["text"]
    transform: "spine"
  "despin":
    kind: "text"
    grammarType: "textCapture"
    description: "space spinal-case-text"
    tags: ["text"]
    transform: "spine"
    padLeft: true
  "criffed":
    kind: "text"
    description: "StudCaseText"
    tags: ["text"]
    aliases: ["chaffed"]
    grammarType: "textCapture"
    transform: "stud"
  "smash":
    kind: "text"
    grammarType: "textCapture"
    description: "lowercasewithnospaces"
    tags: ["text"]
    transform: "lowerSlam"
  "yellsmash":
    kind: "text"
    grammarType: "textCapture"
    description: "UPPERCASEWITHNOSPACES"
    tags: ["text"]
    transform: "upperSlam"
  "yeller":
    kind: "text"
    grammarType: "textCapture"
    description: "UPPER CASE WITH SPACES"
    tags: ["text"]
    transform: "upperCase"
  "yellsnik":
    kind: "text"
    grammarType: "textCapture"
    description: "UPPER_CASE_SNAKE"
    tags: ["text"]
    transform: "upperSnake"
  "yellspin":
    kind: "text"
    grammarType: "textCapture"
    description: "UPPER-CASE-SPINE"
    tags: ["text"]
    transform: "upperSpine"
  "pathway":
    kind: "text"
    grammarType: "textCapture"
    description: "separated/by/slashes"
    tags: ["text"]
    transform: "pathway"
  "dotsway":
    kind: "text"
    grammarType: "textCapture"
    description: "separated.by.dots"
    tags: ["text"]
    transform: "dotsWay"
  "tridal":
    kind: "text"
    grammarType: "textCapture"
    description: "Title Words With Spaces"
    tags: ["text"]
    transform: "titleSentance"
  "senchen":
    kind: "text"
    grammarType: "textCapture"
    description: "Sentence case with spaces"
    tags: ["text"]
    transform: "titleFirstSentance"
