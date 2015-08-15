Commands.createDisabled
  "spark":
    grammarType: "oneArgument"
    description: "paste the clipboard (or named item from 'stoosh' command)"
    aliases: ["sparked"]
    tags: ["clipboard", "recommended"]
    spaceBefore: true
    action: (input) ->
      if input?
        previous = @retrieveClipboardWithName(input)
        if previous?.length
          @setClipboard(previous)
          @delay 50
          @key "V", "command"
      else
        @key "V", "command"
  "allspark":
    description: "select all then paste the clipboard"
    tags: ["clipboard", "selection", "recommended"]
    action: ->
      @key "A", "command"
      @key "V", "command"
  "sparky":
    description: "paste the alternate clipboard"
    tags: ["clipboard"]
    action: ->
      @key "V", "command shift"
  "skoopark":
    grammarType: "oneArgument"
    description: "insert space then paste the clipboard (or named item from 'stoosh' command)"
    tags: ["clipboard", "recommended"]
    action: (input) ->
      @key "Space"
      @do "spark", input
  "stooshwick":
    description: "copy whatever is selected then switch applications"
    tags: ["clipboard", "application", "system", "combo", "recommended"]
    action: ->
      @key "C", "command"
      @key "Tab", "command"
      @delay 250
  "stoosh":
    grammarType: "oneArgument"
    description: "copy whatever is selected (if an argument is given whatever is copied is stored with that name and can be pasted via `spark [name]`)"
    tags: ["clipboard", "recommended"]
    action: (input) ->
      @key "C", "command"
      if input?
        @waitForClipboard()
        @storeCurrentClipboardWithName(input)
  "allstoosh":
    description: "select all then copy whatever is selected"
    tags: ["clipboard", "selection", "recommended"]
    action: ->
      @key "A", "command"
      @key "C", "command"
  "snatch":
    description: "cut whatever is selected"
    tags: ["clipboard", "recommended"]
    aliases: ["snatched"]
    action: ->
      @key "X", "command"