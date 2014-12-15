_.extend Commands.mapping,
  "literal":
    kind: "text"
    grammarType: "textCapture"
    description: "words with spaces between"
    transform: "literal"
  "cram":
    kind: "text"
    grammarType: "textCapture"
    description: "camelCaseText"
    transform: "camel"
    aliases: ["crammed", "crams"]
  "decram":
    kind: "text"
    grammarType: "textCapture"
    description: "space camelCaseText"
    transform: "camel"
    padLeft: true
  "snake":
    kind: "text"
    grammarType: "textCapture"
    description: "snake_case_text"
    transform: "snake"
  "coalsnik":
    kind: "text"
    grammarType: "textCapture"
    description: ":snake_case_with_a_colon_at_the_front"
    transform: "rubySymbol"
  "lowcram":
    kind: "text"
    grammarType: "textCapture"
    description: "@camelCaseWithAtSign"
    transform: "@camelCase"
  "deznik":
    kind: "text"
    grammarType: "textCapture"
    description: "space snake_case_text"
    transform: "snake"
    padLeft: true
  "spine":
    kind: "text"
    grammarType: "textCapture"
    description: "spinal-case-text"
    transform: "spine"
  "despin":
    kind: "text"
    grammarType: "textCapture"
    description: "space spinal-case-text"
    transform: "spine"
    padLeft: true
  "criffed":
    kind: "text"
    description: "StudCaseText"
    aliases: ["chaffed"]
    grammarType: "textCapture"
    transform: "stud"
  "smash":
    kind: "text"
    grammarType: "textCapture"
    description: "lowercasewithnospaces"
    transform: "lowerSlam"
  "yellsmash":
    kind: "text"
    grammarType: "textCapture"
    description: "UPPERCASEWITHNOSPACES"
    transform: "upperSlam"
  "yeller":
    kind: "text"
    grammarType: "textCapture"
    description: "UPPER CASE WITH SPACES"
    transform: "upperCase"
  "yellsnik":
    kind: "text"
    grammarType: "textCapture"
    description: "UPPER_CASE_SNAKE"
    transform: "upperSnake"
  "yellspin":
    kind: "text"
    grammarType: "textCapture"
    description: "UPPER-CASE-SPINE"
    transform: "upperSpine"
  "pathway":
    kind: "text"
    grammarType: "textCapture"
    description: "separated/by/slashes"
    transform: "pathway"
  "dotsway":
    kind: "text"
    grammarType: "textCapture"
    description: "separated.by.dots"
    transform: "dotsWay"
  "tridal":
    kind: "text"
    grammarType: "textCapture"
    description: "Title Words With Spaces"
    transform: "titleSentance"
  "senchen":
    kind: "text"
    grammarType: "textCapture"
    description: "Sentence case with spaces"
    transform: "titleFirstSentance"
