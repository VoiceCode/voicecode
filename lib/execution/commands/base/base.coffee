@Commands ?= {}
Commands.mapping = {}

class Commands.Base
  constructor: (@namespace, @input) ->
    @info = Commands.mapping[@namespace] 
    @kind = @info.kind
    @repeatable = @info.repeatable
    @actions = @info.actions
  code: (key) ->
    KeyCodes[key]
  transform: ->
    Transforms[@info.transform]
  generate: ->
    if @repeatable
      @generateRepeating(@repeatCount())
    else
      @generateBaseCommand()
  generateBaseCommand: ->
    switch @kind
      when "text"
        transformed = @applyTransform(@input or [])
        preCommand = if @info.padLeft
          @spacePad()
        else
          ""
        [preCommand, @makeTextCommand(transformed)].join("\n")
      when "number"
        preCommand = if @info.padLeft
          @spacePad()
        else
          ""
        [preCommand, @makeTextCommand "#{@input}"].join("\n")
      when "action"
        @joinActionCommands()
      when "modifier"
        @makeModifierCommand @input
  joinActionCommands: ->
    me = @
    _.map(@actions, (action) ->
      me.generateActionCommand(action)
    ).join("\n")
  generateActionCommand: (action) ->
    base = switch action.kind
      when "key"
        ms = @makeModifierString(action.modifiers)
        code = @code(action.key)
        kc = @makeKeycode(code, ms)
        @makeSystemEventsCommand(kc) + "\ndelay 0.01"
      when "keystroke"
        ms = @makeModifierString(action.modifiers)
        @makeTextCommand(action.keystroke, ms)
      when "script"
        action.script(@input)
      when "block"
        @makeBlockAction @input, action
    delay = if action.delay?
      "delay #{action.delay}"
    else
      ""
    [base, delay].join("\n")
  applyTransform: (textArray) ->
    transform = @transform()
    @transform()(textArray)
  repeatCount: ->
    n = parseInt(@input)
    if n? and n > 1
      n
    else
      1
  makeModifierCommand: (input) ->
    string = input.toString()
    if string.length
      code = ModifierTargets[string] or ModifierTargets[string.charAt(0)]
      if code?
        ms = @makeModifierString(@info.modifiers)
        kc = @makeKeycode(code, ms)
        @makeSystemEventsCommand kc
      else
        ""
    else
      ""
  generateRepeating: (number) ->
    """
    repeat #{number} times
    #{@generateBaseCommand()}
    end repeat
    """
  spacePad: ->
    """
    tell application "System Events"
    keystroke " "
    end tell
    """
  makeSystemEventsCommand: (lines) ->
    """
    tell application "System Events"
    #{lines}
    end tell
    """
  makeKeystroke: (text, modifierString = "") ->
    """
    keystroke "#{text}" #{modifierString}
    """
  makeKeycode: (code, modifierString = "") ->
    """
    key code "#{code}" #{modifierString}
    """
  makeTextCommand: (text, modifierString) ->
    console.log "make text command: #{text}"
    me = @
    strokes = _.map text.split(''), (character) ->
      result = if character is "."
        me.makeKeycode 47
      else if character is "/"
        me.makeKeycode 44
      else if character is "-"
        me.makeKeycode 27
      else if character is '"'
        me.makeKeystroke "\\\""
      else
        me.makeKeystroke character
      [result, modifierString].join(" ")
    joined = strokes.join("\ndelay 0.01\n") + "\ndelay 0.02"
    @makeSystemEventsCommand joined 
  makeBlockAction: (input, action) ->
    transformed = action.transform(input or [])
    @makeBlockCommand(transformed)
  makeBlockCommand: (text) ->
    """
    set theOriginal to the clipboard as record
    set newText to "#{@escapeString(text)}" as text
    set the clipboard to newText
    delay 0.05
    tell application "System Events"
    keystroke "v" using {command down}
    end tell
    delay 0.05
    set the clipboard to theOriginal as record
    """
  escapeString: (text) ->
    ("" + text).replace /["'\\\n\r]/g, (character) ->
      switch character
        when "\"", "'", "\\"
          "\\" + character
        when "\n"
          "\\n"
        when "\r"
          "\\r"
  makeModifierString: (modifiers) ->
    if modifiers?
      innerString = _.map(modifiers, (modifier) ->
        "#{modifier} down"
      ).join(', ')
      "using {#{innerString}}"
    else
      ""