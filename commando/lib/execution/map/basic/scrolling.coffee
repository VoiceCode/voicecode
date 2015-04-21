Commands.create
  "scroll-page-up":
    kind: "action"
    description: "press PageUp key [N] times"
    grammarType: "numberCapture"
    triggerPhrase: "page up"
    tags: ["scroll", "up", "recommended"]
    action: (input) ->
      _(input or 1).times =>
        @key "PageUp"
  "scroll-page-down":
    kind: "action"
    description: "press PageDown key [N] times"
    grammarType: "numberCapture"
    triggerPhrase: "page down"
    tags: ["scroll", "down", "recommended"]
    action: (input) ->
      _(input or 1).times =>
        @key "PageDown"
  "scrodge":
    kind: "action"
    description: "scroll down"
    grammarType: "numberCapture"
    tags: ["scroll", "down", "recommended"]
    action: (input) ->
      @scrollDown(input or 1)
  "scroop":
    kind: "action"
    description: "scroll up"
    grammarType: "numberCapture"
    tags: ["scroll", "up", "recommended"]
    action: (input) ->
      @scrollUp(input or 1)
  "scrodgeway":
    kind: "action"
    description: "scroll way down"
    grammarType: "individual"
    tags: ["scroll", "down", "recommended"]
    action: (input) ->
      @scrollDown(999)
  "scroopway":
    kind: "action"
    description: "scroll way up"
    grammarType: "individual"
    tags: ["scroll", "up", "recommended"]
    action: (input) ->
      @scrollUp(999)
  "sweeper":
    kind: "action"
    description: "scroll right"
    grammarType: "numberCapture"
    tags: ["scroll", "right"]
    action: (input) ->
      @scrollRight(input or 1)
  "sweeple":
    kind: "action"
    description: "scroll left"
    grammarType: "numberCapture"
    tags: ["scroll", "left"]
    action: (input) ->
      @scrollLeft(input or 1)
