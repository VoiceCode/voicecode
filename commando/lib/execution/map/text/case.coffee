_.extend Commands.mapping,
  "vc-literal":
    kind: "text"
    grammarType: "textCapture"
    description: "words with spaces between. This command is for internal grammar use (not spoken)"
    tags: ["text"]
    transform: "literal"
  "cram":
    kind: "text"
    grammarType: "textCapture"
    description: "camelCaseText"
    tags: ["text"]
    transform: "camel"
    aliases: ["crammed", "crams", "tram", "kram"]
    contextSensitive: true
    fallbackService: "vc case cram"
  "decram":
    kind: "text"
    grammarType: "textCapture"
    description: "space camelCaseText"
    tags: ["text", "combo"]
    transform: "camel"
    prefix: " "
  "dockram":
    kind: "text"
    grammarType: "textCapture"
    description: "space camelCaseText"
    tags: ["text", "combo"]
    transform: "camel"
    prefix: "."
  "snake":
    kind: "text"
    grammarType: "textCapture"
    description: "snake_case_text"
    tags: ["text"]
    transform: "snake"
    contextSensitive: true
    fallbackService: "vc case snake"
  "coalsnik":
    kind: "text"
    grammarType: "textCapture"
    description: ":snake_case_with_a_colon_at_the_front"
    tags: ["text", "combo"]
    transform: "snake"
    prefix: ":"
  "lowcram":
    kind: "text"
    grammarType: "textCapture"
    description: "@camelCaseWithAtSign"
    tags: ["text", "combo"]
    transform: "camel"
    prefix: "@"
  "dollcram":
    kind: "text"
    grammarType: "textCapture"
    description: "$camelCaseWithDollarSign"
    tags: ["text"]
    transform: "camel"
    prefix: "$"
  "deznik":
    kind: "text"
    grammarType: "textCapture"
    description: "space snake_case_text"
    tags: ["text", "combo"]
    transform: "snake"
    prefix: " "
  "spine":
    kind: "text"
    grammarType: "textCapture"
    description: "spinal-case-text"
    tags: ["text"]
    transform: "spine"
    contextSensitive: true
    fallbackService: "vc case spine"
  "despin":
    kind: "text"
    grammarType: "textCapture"
    description: "space spinal-case-text"
    tags: ["text"]
    transform: "spine"
    prefix: " "
  "criffed":
    kind: "text"
    description: "StudCaseText"
    tags: ["text"]
    aliases: ["chaffed"]
    grammarType: "textCapture"
    transform: "stud"
    contextSensitive: true
    fallbackService: "vc case criffed"
  "decriffed":
    kind: "text"
    description: "space StudCaseText"
    tags: ["text", "combo"]
    aliases: ["chaffed"]
    grammarType: "textCapture"
    transform: "stud"
    contextSensitive: true
    prefix: " "
  "dockriffed":
    kind: "text"
    description: "space StudCaseText"
    tags: ["text", "combo"]
    aliases: ["chaffed"]
    grammarType: "textCapture"
    transform: "stud"
    contextSensitive: true
    prefix: "."
  "dollkriffed":
    kind: "text"
    description: "space StudCaseText"
    tags: ["text", "combo"]
    aliases: ["chaffed"]
    grammarType: "textCapture"
    transform: "stud"
    contextSensitive: true
    prefix: "$"
  "smash":
    kind: "text"
    grammarType: "textCapture"
    description: "lowercasewithnospaces"
    tags: ["text"]
    transform: "lowerSlam"
    contextSensitive: true
    fallbackService: "vc case smash"
  "yellsmash":
    kind: "text"
    grammarType: "textCapture"
    description: "UPPERCASEWITHNOSPACES"
    tags: ["text"]
    transform: "upperSlam"
    contextSensitive: true
    fallbackService: "vc case yellsmash"
  "yeller":
    kind: "text"
    grammarType: "textCapture"
    description: "UPPER CASE WITH SPACES"
    tags: ["text"]
    transform: "upperCase"
    contextSensitive: true
    fallbackService: "vc case yeller"
  "yellsnik":
    kind: "text"
    grammarType: "textCapture"
    description: "UPPER_CASE_SNAKE"
    tags: ["text"]
    transform: "upperSnake"
    contextSensitive: true
    fallbackService: "vc case yellsnik"
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
    contextSensitive: true
    fallbackService: "vc case tridal"
  "senchen":
    kind: "text"
    grammarType: "textCapture"
    description: "Sentence case with spaces"
    tags: ["text"]
    transform: "titleFirstSentance"
    contextSensitive: true
    fallbackService: "vc case senchen"
  "datsun":
    kind: "text"
    grammarType: "textCapture"
    description: "Sentence case with spaces"
    tags: ["text"]
    transform: "titleFirstSentance"
    contextSensitive: true
    prefix: ". "
