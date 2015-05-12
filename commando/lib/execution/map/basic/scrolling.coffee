Commands.createDisabled
  "page up":
    description: "press PageUp key [N] times"
    grammarType: "numberCapture"
    tags: ["scroll", "up", "recommended"]
    continuous: false
    action: (input) ->
      _(input or 1).times =>
        @key "PageUp"
        @delay 200
  "page down":
    description: "press PageDown key [N] times"
    grammarType: "numberCapture"
    tags: ["scroll", "down", "recommended"]
    continuous: false
    action: (input) ->
      _(input or 1).times =>
        @key "PageDown"
        @delay 200
  "scrodge":
    description: "scroll down"
    grammarType: "numberCapture"
    tags: ["scroll", "down", "recommended"]
    action: (input) ->
      @scrollDown(input or 10)
  "scroop":
    description: "scroll up"
    grammarType: "numberCapture"
    tags: ["scroll", "up", "recommended"]
    action: (input) ->
      @scrollUp(input or 10)
  "scrodgeway":
    description: "scroll way down"
    tags: ["scroll", "down", "recommended"]
    action: (input) ->
      @scrollDown(999)
  "scroopway":
    description: "scroll way up"
    tags: ["scroll", "up", "recommended"]
    action: (input) ->
      @scrollUp(999)
  "sweeper":
    description: "scroll right"
    grammarType: "numberCapture"
    tags: ["scroll", "right"]
    action: (input) ->
      @scrollRight(input or 1)
  "sweeple":
    description: "scroll left"
    grammarType: "numberCapture"
    tags: ["scroll", "left"]
    action: (input) ->
      @scrollLeft(input or 1)
