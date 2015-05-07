Commands.createDisabled
  "vc-literal":
    kind: "text"
    grammarType: "textCapture"
    description: "words with spaces between. This command is for internal grammar use (not spoken)"
    tags: ["text", "recommended"]
    isSpoken: false
    transform: "literal"
  "cram":
    kind: "text"
    grammarType: "textCapture"
    description: "camelCaseText"
    tags: ["text", "recommended"]
    transform: "camel"
    aliases: ["crammed", "crams", "tram", "kram"]
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
    tags: ["text", "recommended"]
    transform: "snake"
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
    tags: ["text", "recommended"]
    transform: "spine"
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
    tags: ["text", "recommended"]
    aliases: ["chaffed", "crisped"]
    grammarType: "textCapture"
    transform: "stud"
    fallbackService: "vc case criffed"
  "decriffed":
    kind: "text"
    description: "space StudCaseText"
    tags: ["text", "combo"]
    aliases: ["chaffed"]
    grammarType: "textCapture"
    transform: "stud"
    prefix: " "
  "dockriffed":
    kind: "text"
    description: "space StudCaseText"
    tags: ["text", "combo"]
    aliases: ["chaffed"]
    grammarType: "textCapture"
    transform: "stud"
    prefix: "."
  "dollkriffed":
    kind: "text"
    description: "space StudCaseText"
    tags: ["text", "combo"]
    aliases: ["chaffed"]
    grammarType: "textCapture"
    transform: "stud"
    prefix: "$"
  "smash":
    kind: "text"
    grammarType: "textCapture"
    description: "lowercasewithnospaces"
    tags: ["text", "recommended"]
    transform: "lowerSlam"
    fallbackService: "vc case smash"
  "yellsmash":
    kind: "text"
    grammarType: "textCapture"
    description: "UPPERCASEWITHNOSPACES"
    tags: ["text"]
    transform: "upperSlam"
    fallbackService: "vc case yellsmash"
  "yeller":
    kind: "text"
    grammarType: "textCapture"
    description: "UPPER CASE WITH SPACES"
    tags: ["text", "recommended"]
    transform: "upperCase"
    fallbackService: "vc case yeller"
  "yellsnik":
    kind: "text"
    grammarType: "textCapture"
    description: "UPPER_CASE_SNAKE"
    tags: ["text"]
    transform: "upperSnake"
    fallbackService: "vc case yellsnik"
  "yellspin":
    kind: "text"
    grammarType: "textCapture"
    description: "UPPER-CASE-SPINE"
    tags: ["text"]
    transform: "upperSpine"
    fallbackService: "vc case yellspin"
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
    tags: ["text", "recommended"]
    transform: "titleSentance"
    fallbackService: "vc case tridal"
  "senchen":
    kind: "text"
    grammarType: "textCapture"
    description: "Sentence case with spaces"
    tags: ["text", "recommended"]
    transform: "titleFirstSentance"
    fallbackService: "vc case senchen"
  "datsun":
    kind: "text"
    grammarType: "textCapture"
    description: "Sentence case with spaces"
    tags: ["text", "recommended"]
    transform: "titleFirstSentance"
    prefix: ". "
