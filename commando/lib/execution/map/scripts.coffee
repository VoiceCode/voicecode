@Scripts =
  dubCap: ->
    """
    do shell script "/usr/local/bin/cliclick dc:+0,+0"
    delay 0.1
    tell application "System Events"
      keystroke "c" using {command down}
    end tell
    set theData to (the clipboard as text)
    set result to do shell script "ruby ~/Code/dragon/snake.rb liz '" & theData & "'"
    set the clipboard to result as text
    tell application "System Events"
      keystroke "v" using {command down}
    end tell
    """
  openDropDown: (name) ->
    """
    tell application "System Events" to tell (process 1 where frontmost is true)
      click menu bar item "#{name}" of menu bar 1
    end tell
    """
  openWebsite: (name) ->
    address = Scripts.levenshteinMatch CommandoSettings.websites, name
    keystroke = if name.length and address?
      """
      keystroke "#{address}"
      key code "36"
      """
    else
      ""
    """
    tell application "#{CommandoSettings.defaultBrowser}" to activate
    delay 0.2
    tell application "System Events"
    keystroke "t" using {command down}
    #{keystroke}
    end tell
    """
  openWebTab: (name) ->
    """
    tell application "#{CommandoSettings.defaultBrowser}" to activate
    tell application "System Events"
    keystroke "t" using {command down}
    end tell
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
    strokes = _.map text.split(''), (character) ->
      result = if character is "."
        Scripts.makeKeycode 47
      else if character is "/"
        Scripts.makeKeycode 44
      else if character is "-"
        Scripts.makeKeycode 27
      else if character is '"'
        Scripts.makeKeystroke "\\\""
      else if character >= '0' and character <= '9'
        Scripts.makeKeycode KeyCodes["n#{character}"]
      else
        Scripts.makeKeystroke character
      [result, modifierString].join(" ")
    joined = strokes.join("\ndelay 0.01\n") + "\ndelay 0.02"
    Scripts.makeSystemEventsCommand joined 
  insertAbbreviation: (name, prepend="", append="") ->
    abbreviation = Scripts.levenshteinMatch CommandoSettings.abbreviations, name
    keystroke = if name.length and abbreviation?
      """
      tell application "System Events"
      keystroke "#{prepend}#{abbreviation}#{append}"
      end tell
      """
    else
      ""
  codeSnippet: (name) ->
    snippet = Scripts.levenshteinMatch CommandoSettings.codeSnippets, name
    keystroke = if name.length and snippet?
      """
      tell application "System Events"
      keystroke "#{snippet}"
      delay 0.15
      #{CommandoSettings.codeSnippetCompletionKeystroke}
      end tell
      """
    else
      ""
  levenshteinMatch: (list, term) ->
    if list[term]?
      list[term]
    else
      results = {}
      _.each list, (item, key) ->
        totalDistance = _.levenshtein(key, term)
        # tokens = key.split(" ")
        # cumulativeDistance = 0
        # matchCount = 0
        # _.each tokens, (token) ->
        #   _.each term.split(" "), (innerToken) ->
        #     matchCount++
        #     cumulativeDistance += _.levenshtein(token, innerToken)
        # averageDistance = cumulativeDistance / matchCount
        # results[key] = averageDistance + cumulativeDistance
        results[key] = totalDistance
      best = _.min _.keys(results), (k) ->
        results[k]
      # console.log results
      # console.log best
      list[best]
  openApplication: (name) ->
    application = Scripts.levenshteinMatch CommandoSettings.applications, name
    """
    tell application "#{application}" to activate
    """
  selectBlock: ->
    """
    set theOriginal to the clipboard as record
    tell application "System Events"
    key code "8" using {command down}
    end tell
    delay 0.03
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to "\\r"
    set selText to (the clipboard as text)
    set results to (count selText's text items)
    set AppleScript's text item delimiters to astid
    tell application "System Events"
    key code "123"
    key code "123" using {command down}
    key code "123" using {command down}
    repeat (results - 1) times
    key code "125" using {shift down}
    end repeat
    key code "124" using {command down, shift down}
    end tell
    set the clipboard to theOriginal as record
    """
  symmetricSelectionExpansion: (value) ->
    """
    set theOriginal to the clipboard as record
    tell application "System Events"
    key code "8" using {command down}
    end tell
    delay 0.03
    set selText to (the clipboard as text)
    set results to (length of selText)
    set the clipboard to theOriginal as record
    tell application "System Events"
    key code "123"
    repeat (#{value}) times
    key code "123"
    end repeat
    repeat (results + #{value} + #{value}) times
    key code "124" using {shift down}
    end repeat
    end tell
    """
  verticalSelectionExpansion: (value) ->
    """
    set theOriginal to the clipboard as record
    tell application "System Events"
    key code "8" using {command down}
    end tell
    delay 0.03
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to "\\r"
    set selText to (the clipboard as text)
    set results to (count selText's text items)
    set the clipboard to theOriginal as record
    set AppleScript's text item delimiters to astid
    tell application "System Events"
    key code "123"
    repeat (#{value}) times
    key code "126"
    end repeat
    repeat (results + #{value} + #{value} - 1) times
    key code "125" using {shift down}
    end repeat
    end tell
    """
  singleLetter: (letter, more) ->
    extras = more or []
    letters = "#{letter}#{extras.join('')}"
    """
    tell application "System Events"
    keystroke "#{letters}"
    end tell
    """
  singleModifier: (letter, modifiers) ->
    code = KeyCodes[letter]
    mods = _.map modifiers, (m) -> "#{m} down"
    """
    tell application "System Events"
    key code "#{code}" using {#{mods.join(', ')}}
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
        key code "123" using {command down}
        key code "124" using {command down, shift down}
        delay 0.05
        key code "8" using {command down}
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
        key code "123"
        repeat distanceLeft times
        key code "124"
        end repeat
        repeat (totalLength - distanceLeft - distanceRight) times
        key code "124" using {shift down}
        end repeat
        end tell
        set the clipboard to theOriginal as record
        """
      else
        """
        set theOriginal to the clipboard as record
        tell application "System Events"
        key code "123" using {command down}
        key code "124" using {command down, shift down}
        delay 0.05
        key code "8" using {command down}
        delay 0.3
        end tell

        set astid to AppleScript's text item delimiters

        set AppleScript's text item delimiters to "#{first}"
        set selText to (the clipboard as text)
        set sections1 to every text item of selText

        set AppleScript's text item delimiters to astid

        set distanceLeft to length of item 1 of sections1
        
        tell application "System Events"
        key code "123"
        repeat distanceLeft times
        key code "124"
        end repeat
        repeat #{first.length} times
        key code "124" using {shift down}
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
        key code "123"
        key code "124"
        repeat 20 times
        key code "126" using {shift down}
        end repeat
        delay 0.05
        key code "8" using {command down}
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
        key code "124"
        repeat (distanceRight) times
        key code "123"
        end repeat
        repeat (distanceLeft + #{first.length} - distanceRight) times
        key code "123" using {shift down}
        end repeat
        end tell
        set the clipboard to theOriginal as record
        """
      else
        """
        set theOriginal to the clipboard as record
        tell application "System Events"
        key code "123"
        key code "124"
        repeat 20 times
        key code "126" using {shift down}
        end repeat
        delay 0.05
        key code "8" using {command down}
        delay 0.3
        end tell

        set astid to AppleScript's text item delimiters

        set AppleScript's text item delimiters to "#{first}"
        set selText to (the clipboard as text)
        set sections1 to every text item of selText

        set AppleScript's text item delimiters to astid

        set distanceLeft to length of item -1 of sections1
        
        tell application "System Events"
        key code "124"
        repeat distanceLeft times
        key code "123"
        end repeat
        repeat #{first.length} times
        key code "123" using {shift down}
        end repeat
        end tell
        set the clipboard to theOriginal as record
        """
    else
      ""
  selectFollowingOccurrence: (textArray) ->
    if textArray?.length
      first = textArray[0]
      last = textArray[1]
      if last?.length
        """
        set theOriginal to the clipboard as record
        tell application "System Events"
        key code "124"
        key code "123"
        repeat 20 times
        key code "125" using {shift down}
        end repeat
        delay 0.05
        key code "8" using {command down}
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
        key code "123"
        repeat (distanceLeft) times
        key code "124"
        end repeat
        repeat (distanceRight + #{last.length} - distanceLeft) times
        key code "124" using {shift down}
        end repeat
        end tell
        set the clipboard to theOriginal as record
        """
      else
        """
        set theOriginal to the clipboard as record
        tell application "System Events"
        key code "124"
        key code "123"
        repeat 20 times
        key code "125" using {shift down}
        end repeat
        delay 0.05
        key code "8" using {command down}
        delay 0.3
        end tell

        set astid to AppleScript's text item delimiters

        set AppleScript's text item delimiters to "#{first}"
        set selText to (the clipboard as text)
        set sections1 to every text item of selText

        set AppleScript's text item delimiters to astid

        set distanceLeft to length of item 1 of sections1
        
        tell application "System Events"
        key code "123"
        repeat distanceLeft times
        key code "124"
        end repeat
        repeat #{first.length} times
        key code "124" using {shift down}
        end repeat
        end tell
        set the clipboard to theOriginal as record
        """
    else
      ""

      
      