@Commands ?= {}
Commands.mapping = {}
Commands.history = []

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
          Scripts.spacePad()
        else
          ""
        [preCommand, Scripts.makeTextCommand(transformed)].join("\n")
      when "number"
        preCommand = if @info.padLeft
          Scripts.spacePad()
        else
          ""
        [preCommand, Scripts.makeTextCommand "#{@input}"].join("\n")
      when "action"
        @joinActionCommands()
      when "modifier"
        @makeModifierCommand @input
      when "word"
        transformed = Transforms.identity([@info.word].concat(@input or []))
        Scripts.makeTextCommand(transformed)
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
        kc = Scripts.makeKeycode(code, ms)
        Scripts.makeSystemEventsCommand(kc) + "\ndelay 0.01"
      when "keystroke"
        ms = @makeModifierString(action.modifiers)
        Scripts.makeTextCommand(action.keystroke, ms)
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
        kc = Scripts.makeKeycode(code, ms)
        Scripts.makeSystemEventsCommand kc
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
    ("" + text).replace /["\\\n\r]/g, (character) ->
      switch character
        when "\"", "\\" #, "'"
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
  getTriggerPhrase: () ->
    @info.triggerPhrase or @namespace
  generateFullCommand: () ->
    commandText = @generateBaseCommand()
    space = @info.namespace or @namespace
    if @info.contextSensitive
      """
      on srhandler(vars)
        set dictatedText to (varText of vars)
        set encodedText to (do shell script "/usr/bin/python -c 'import sys, urllib; print urllib.quote(sys.argv[1],\\"\\")' " & quoted form of dictatedText)
        set space to "#{space}"
        set toExecute to "curl http://commando:5000/parse/" & space & "/" & encodedText
        do shell script toExecute
      end srhandler
      """
    else
      """
      on srhandler(vars)
        set dictatedText to (varText of vars)
        if dictatedText = "" then
        #{commandText}
        set toExecute to "curl http://commando:5000/parse/miss/#{space}"
        do shell script toExecute
        else
        set encodedText to (do shell script "/usr/bin/python -c 'import sys, urllib; print urllib.quote(sys.argv[1],\\"\\")' " & quoted form of dictatedText)
        set space to "#{space}"
        set toExecute to "curl http://commando:5000/parse/" & space & "/" & encodedText
        do shell script toExecute
        end if
      end srhandler
      """
  generateDragonCommandName: () ->
    "#{@getTriggerPhrase()} /!Text!/"