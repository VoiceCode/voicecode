Platforms.osx.applescript =
  openDropDown: (name) ->
    """
    tell application "System Events" to tell (process 1 where frontmost is true)
      click menu bar item "#{name}" of menu bar 1
    end tell
    """
  openWebsite: (name) ->
    address = Actions.fuzzyMatch Settings.web.websites, name
    keystroke = if name.length and address?
      """
      keystroke "#{address}"
      key code 36
      """
    else
      ""
    """
    tell application "#{Settings.os.defaultBrowser}" to activate
    delay 0.2
    tell application "System Events"
    keystroke "t" using {command down}
    #{keystroke}
    end tell
    """
  openWebTab: (name) ->
    """
    tell application "#{Settings.os.defaultBrowser}" to activate
    delay 0.1
    tell application "System Events"
    keystroke "t" using {command down}
    delay 0.1
    end tell
    """
  makeSystemEventsCommand: (lines) ->
    """
    tell application "System Events"
    #{lines}
    end tell
    """
  makeKeystroke: (text, modifiers) ->
    """
    keystroke "#{text}" #{Scripts.makeModifierString(modifiers)}
    """
  makeKeycode: (code, modifiers) ->
    """
    key code #{code} #{Scripts.makeModifierString(modifiers)}
    """
  makeModifierString: (modifiers) ->
    if modifiers?
      innerString = _.map(modifiers, (modifier) ->
        "#{modifier} down"
      ).join(', ')
      "using {#{innerString}}"
    else
      ""
  generateRepeating: (content, times, delay) ->
    delayString = if delay?
      "delay #{delay}"
    else
      ""
    """
    repeat #{times} times
    #{content}
    #{delayString}
    end repeat
    """
  makeTextCommand: (text, modifiers) ->
    strokes = _.map text.split(''), (character) ->
      result = switch character
        when "."
          Scripts.makeKeycode 47, modifiers
        when "/"
          Scripts.makeKeycode 44, modifiers
        when "-"
          Scripts.makeKeycode 27, modifiers
        when "+"
          Scripts.makeKeycode 24, ["shift"]
        when "="
          Scripts.makeKeycode 24, modifiers
        when "`"
          Scripts.makeKeycode 50, modifiers
        when "$"
          Scripts.makeKeycode 21, ["shift"]
        when "*"
          Scripts.makeKeycode 28, ["shift"]
        when "'"
          Scripts.makeKeycode 39, modifiers
        when '"'
          Scripts.makeKeycode 39, ["shift"]
        when '\\'
          Scripts.makeKeycode 42, modifiers
        when '\n'
          Scripts.makeKeycode 36, modifiers
        else
          if character >= '0' and character <= '9'
            Scripts.makeKeycode KeyCodes["n#{character}"], modifiers
          else
            Scripts.makeKeystroke character, modifiers
      result
    joined = strokes.join("\ndelay 0.01\n") + "\ndelay 0.02"
    Scripts.makeSystemEventsCommand joined
  joinActionCommands: (actions, input) ->
    _.map(actions, (action) ->
      Scripts.generateActionCommand(action, input)
    ).join("\n")
  generateActionCommand: (action, input) ->
    base = switch action.kind
      when "key"
        kc = Scripts.makeKeycode(KeyCodes[action.key], action.modifiers)
        Scripts.makeSystemEventsCommand(kc) + "\ndelay 0.01"
      when "keystroke"
        # ms = Scripts.makeModifierString(action.modifiers)
        Scripts.makeTextCommand(action.keystroke, action.modifiers)
      when "script"
        action.script(input)
      when "text"
        Scripts.makeTextCommand(action.text(input))
      when "block"
        Scripts.makeBlockAction input, action
      when "mimic"
        command = new Command(action.command, action.parameters)
        command.generate()
    delay = if action.delay?
      "delay #{action.delay}"
    else
      ""
    [base, delay].join("\n")
  makeBlockAction: (input, action) ->
    transformed = action.transform(input or [])
    Scripts.makeBlockCommand(transformed)
  makeBlockCommand: (text) ->
    """
    set theOriginal to the clipboard as record
    set newText to "#{Scripts.escapeString(text)}" as text
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
  openApplication: (name) ->
    application = Actions.fuzzyMatch Settings.os.applications, name
    """
    tell application "#{application}" to activate
    """
  selectBlock: ->
    """
    set theOriginal to the clipboard as record
    tell application "System Events"
    key code 8 using {command down}
    end tell
    delay 0.03
    set results to (count paragraphs of (get the clipboard))
    tell application "System Events"
    key code 123
    key code 123 using {command down}
    repeat (results) times
    key code 125 using {shift down, option down}
    end repeat
    end tell
    set the clipboard to theOriginal as record
    """
  symmetricSelectionExpansion: (value) ->
    """
    set theOriginal to the clipboard as record
    tell application "System Events"
    key code 8 using {command down}
    end tell
    delay 0.03
    set selText to (the clipboard as text)
    set results to (length of selText)
    set the clipboard to theOriginal as record
    tell application "System Events"
    key code 123
    repeat (#{value}) times
    key code 123
    end repeat
    repeat (results + #{value} + #{value}) times
    key code 124 using {shift down}
    end repeat
    end tell
    """
  singleLetter: (letter, more) ->
    extras = more or []
    Scripts.makeTextCommand "#{letter}#{extras.join('')}"
  singleModifier: (letter, modifiers) ->
    code = KeyCodes[letter]
    mods = _.map modifiers, (m) -> "#{m} down"
    """
    tell application "System Events"
    key code #{code} using {#{mods.join(', ')}}
    end tell
    """
  runWorkflow: (path) ->
    """
    set workflowpath to "#{path}"
    set qtdworkflowpath to quoted form of (Posix path of workflowpath)
    set c to "/usr/bin/automator " & qtdworkflowpath
    set output to do shell script c
    """
  selectCurrentOccurrence: (textArray) ->
    if textArray?.length
      first = textArray[0]
      last = textArray[1]
      if last?.length
        """
        set theOriginal to the clipboard as record
        tell application "System Events"
        key code 123 using {command down}
        key code 124 using {command down, shift down}
        delay 0.05
        key code 8 using {command down}
        delay 0.3
        end tell

        set astid to AppleScript's text item delimiters

        set AppleScript's text item delimiters to "#{first}"
        set selText to (the clipboard as text)
        set sections1 to every text item of selText

        set AppleScript's text item delimiters to "#{last}"
        set sections2 to every text item of selText

        set AppleScript's text item delimiters to astid

        set totalLength to length of selText

        set distanceLeft to length of item 1 of sections1
        set distanceRight to length of item -1 of sections2

        tell application "System Events"
        key code 123
        repeat distanceLeft times
        key code 124
        end repeat
        repeat (totalLength - distanceLeft - distanceRight) times
        key code 124 using {shift down}
        end repeat
        end tell
        set the clipboard to theOriginal as record
        """
      else
        """
        set theOriginal to the clipboard as record
        tell application "System Events"
        key code 123 using {command down}
        key code 124 using {command down, shift down}
        delay 0.05
        key code 8 using {command down}
        delay 0.3
        end tell

        set astid to AppleScript's text item delimiters

        set AppleScript's text item delimiters to "#{first}"
        set selText to (the clipboard as text)
        set sections1 to every text item of selText

        set AppleScript's text item delimiters to astid

        set distanceLeft to length of item 1 of sections1

        tell application "System Events"
        key code 123
        repeat distanceLeft times
        key code 124
        end repeat
        repeat #{first.length} times
        key code 124 using {shift down}
        end repeat
        end tell
        set the clipboard to theOriginal as record
        delay 1
        """
    else
      ""
  selectPreviousOccurrence: (textArray) ->
    if textArray?.length
      first = textArray[0]
      last = textArray[1]
      if last?.length
        """
        set theOriginal to the clipboard as record
        tell application "System Events"
        key code 123
        key code 124
        repeat 20 times
        key code 126 using {shift down}
        end repeat
        delay 0.05
        key code 8 using {command down}
        delay 0.3
        end tell

        set astid to AppleScript's text item delimiters

        set AppleScript's text item delimiters to "#{first}"
        set selText to (the clipboard as text)
        set sections1 to every text item of selText

        set AppleScript's text item delimiters to "#{last}"
        set sections2 to every text item of selText

        set AppleScript's text item delimiters to astid

        set totalLength to length of selText

        set distanceLeft to length of item -1 of sections1
        set distanceRight to length of item -1 of sections2

        tell application "System Events"
        key code 124
        repeat (distanceRight) times
        key code 123
        end repeat
        repeat (distanceLeft + #{first.length} - distanceRight) times
        key code 123 using {shift down}
        end repeat
        end tell
        set the clipboard to theOriginal as record
        """
      else
        """
        set theOriginal to the clipboard as record
        tell application "System Events"
        key code 124
        repeat 20 times
        key code 126 using {shift down}
        end repeat
        delay 0.05
        key code 8 using {command down}
        delay 0.3
        end tell

        set astid to AppleScript's text item delimiters

        set AppleScript's text item delimiters to "#{first}"
        set selText to (the clipboard as text)
        set sections1 to every text item of selText

        set AppleScript's text item delimiters to astid

        set distanceLeft to length of item -1 of sections1

        tell application "System Events"
        key code 124
        repeat distanceLeft times
        key code 123
        end repeat
        repeat #{first.length} times
        key code 123 using {shift down}
        end repeat
        end tell
        set the clipboard to theOriginal as record
        """
    else
      ""
  selectNextOccurrence: (textArray) ->
    if textArray?.length
      first = textArray[0]
      last = textArray[1]
      if last?.length
        """
        set theOriginal to the clipboard as record
        tell application "System Events"
        key code 124
        key code 123
        repeat 20 times
        key code 125 using {shift down}
        end repeat
        delay 0.05
        key code 8 using {command down}
        delay 0.3
        end tell

        set astid to AppleScript's text item delimiters

        set AppleScript's text item delimiters to "#{first}"
        set selText to (the clipboard as text)
        set sections1 to every text item of selText

        set AppleScript's text item delimiters to "#{last}"
        set sections2 to every text item of selText

        set AppleScript's text item delimiters to astid

        set totalLength to length of selText

        set distanceLeft to length of item 1 of sections1
        set distanceRight to length of item 1 of sections2

        tell application "System Events"
        key code 123
        repeat (distanceLeft) times
        key code 124
        end repeat
        repeat (distanceRight + #{last.length} - distanceLeft) times
        key code 124 using {shift down}
        end repeat
        end tell
        set the clipboard to theOriginal as record
        """
      else
        """
        set theOriginal to the clipboard as record
        tell application "System Events"
        key code 124
        key code 123
        repeat 20 times
        key code 125 using {shift down}
        end repeat
        delay 0.05
        key code 8 using {command down}
        delay 0.3
        end tell

        set astid to AppleScript's text item delimiters

        set AppleScript's text item delimiters to "#{first}"
        set selText to (the clipboard as text)
        set sections1 to every text item of selText

        set AppleScript's text item delimiters to astid

        set distanceLeft to length of item 1 of sections1

        tell application "System Events"
        key code 123
        repeat distanceLeft times
        key code 124
        end repeat
        repeat #{first.length} times
        key code 124 using {shift down}
        end repeat
        end tell
        set the clipboard to theOriginal as record
        """
    else
      ""
  applicationScope: (scopeCases, fallback) ->
    scopeMapGenerated = _.map scopeCases, (scenario) ->
      conditionArray = _.map scenario.requirements, (requirement) ->
        innerConditions = _.map requirement, (value, key) ->
          if key is "application"
            "(currentApplication = \"#{value}\")"
          else if key is "context"
            "(currentContext = \"#{value}\")"
        "(" + innerConditions.join(" and ") + ")"
      conditionString = conditionArray.join(" or ")
      """
      if #{conditionString}
        #{scenario.generated}
      """

    """
    tell application "System Events"
      set currentApplication to name of first application process whose frontmost is true
    end tell


    set theOutputFolder to path to preferences folder from user domain as string
    set plist_file to theOutputFolder & "voicecode.plist"

    try
      tell application "System Events"
        tell property list file plist_file
          tell contents
            set currentContext to value of property list item "context" as string
          end tell
        end tell
      end tell
    on error
      set currentContext to "global"
    end try


    #{scopeMapGenerated.join("\nelse ")}
    else
      #{fallback}
    end if
    """
  outOfContext: (name) ->
    """
    display notification "wrong context for command" with title "VoiceCode" subtitle "#{name}" sound name "Sosumi"
    """
  keyCodes:
    A: 0
    S: 1
    D: 2
    F: 3
    H: 4
    G: 5
    Z: 6
    X: 7
    C: 8
    V: 9
    Section: 10
    B: 11
    Q: 12
    W: 13
    E: 14
    R: 15
    Y: 16
    T: 17
    n1: 18
    n2: 19
    n3: 20
    n4: 21
    n6: 22
    n5: 23
    Equal: 24
    n9: 25
    n7: 26
    Minus: 27
    n8: 28
    n0: 29
    RightBracket: 30
    O: 31
    U: 32
    LeftBracket: 33
    I: 34
    P: 35
    Return: 36
    L: 37
    J: 38
    Quote: 39
    K: 40
    Semicolon: 41
    Backslash: 42
    Comma: 43
    Slash: 44
    N: 45
    M: 46
    Period: 47
    Tab: 48
    Space: 49
    Grave: 50
    Delete: 51
    Escape: 53
    Command: 55
    Shift: 56
    CapsLock: 57
    Option: 58
    Control: 59
    RightShift: 60
    RightOption: 61
    RightControl: 62
    Function: 63
    F17: 64
    KeypadDecimal: 65
    KeypadMultiply: 67
    KeypadPlus: 69
    KeypadClear: 71
    VolumeUp: 72
    VolumeDown: 73
    Mute: 74
    KeypadDivide: 75
    KeypadEnter: 76
    KeypadMinus: 78
    F18: 79
    F19: 80
    KeypadEquals: 81
    Keypad0: 82
    Keypad1: 83
    Keypad2: 84
    Keypad3: 85
    Keypad4: 86
    Keypad5: 87
    Keypad6: 88
    Keypad7: 89
    F20: 90
    Keypad8: 91
    Keypad9: 92
    JIS_Yen: 93
    JIS_Underscore: 94
    JIS_KeypadComma: 95
    F5: 96
    F6: 97
    F7: 98
    F3: 99
    F8: 100
    F9: 101
    JIS_Eisu: 102
    F11: 103
    JIS_Kana: 104
    F13: 105
    F16: 106
    F14: 107
    F10: 109
    F12: 111
    F15: 113
    Help: 114
    Home: 115
    PageUp: 116
    ForwardDelete: 117
    F4: 118
    End: 119
    F2: 120
    PageDown: 121
    F1: 122
    Left: 123
    Right: 124
    Down: 125
    Up: 126
    Tilde: 192
