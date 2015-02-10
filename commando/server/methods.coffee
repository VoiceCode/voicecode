# BrowserPolicy.content.allowEval()
# BrowserPolicy.content.allowConnectOrigin("http://grammar.voicecode.io")
# BrowserPolicy.content.allowConnectOrigin("http://commando:5000/")

Meteor.methods
  parseGeneratorString: ->
    ParseGenerator.string

  execute: (phrase) ->
    chain = new Commands.Chain(phrase)
    results = chain.execute(true)

  makeDragonCommand: (name) ->
    command = new Commands.Base(name, null)
    body = command.generateFullCommand().replace(/["]/g, "\\\"").replace(/\\\\/g, "\\\\\\\\\\")
    dragonName = command.generateDragonCommandName()

    script = 
      """osascript <<EOD
      tell application "Dragon Dictate" to activate
      delay 0.1

      tell application "System Events"
        tell process "Dragon Dictate"
          click button 1 of group 2 of splitter group 1 of window "Commands"
        end tell
      end tell

      delay 0.2

      tell application "System Events"
        tell process "Dragon Dictate"
          set value of text field 3 of splitter group 1 of window "Commands" to "#{dragonName}"
        end tell
      end tell

      tell application "System Events"
        tell process "Dragon Dictate"
          click pop up button 1 of splitter group 1 of window "Commands"
        end tell
      end tell

      tell application "System Events"
      key code "0" 
      end tell

      tell application "System Events"
      key code "36" 
      end tell

      delay 0.1

      tell application "System Events"
        tell process "Dragon Dictate"
          set value of text area 1 of scroll area 1 of group 3 of splitter group 1 of window "Commands" to "#{body}"
        end tell
      end tell

      delay 0.1

      tell application "System Events"
        tell process "Dragon Dictate"
          click button "Compile" of splitter group 1 of window "Commands"
        end tell
      end tell
      
      delay 0.4

      tell application "System Events"
        tell process "Dragon Dictate"
          click button "Save" of splitter group 1 of window "Commands"
        end tell
      end tell

      tell application "Chrome" to activate

      EOD
      """
    console.log script
    Shell.exec script, async: true
    true
  makeDragonCommandsForModifier: (modifier) ->
    final = []
    _.each commandLetters, (value, key) ->
      command = new Commands.Base("#{modifier}#{value}", null)
      body = command.generateFullCommand().replace(/["]/g, "\\\"").replace(/\\\\/g, "\\\\\\\\\\")
      dragonName = command.generateDragonCommandName()
      script = 
        """
        tell application "Dragon Dictate" to activate
        delay 0.1

        tell application "System Events"
          tell process "Dragon Dictate"
            click button 1 of group 2 of splitter group 1 of window "Commands"
          end tell
        end tell

        delay 0.2

        tell application "System Events"
          tell process "Dragon Dictate"
            set value of text field 3 of splitter group 1 of window "Commands" to "#{dragonName}"
          end tell
        end tell

        tell application "System Events"
          tell process "Dragon Dictate"
            click pop up button 1 of splitter group 1 of window "Commands"
          end tell
        end tell

        delay 0.1

        tell application "System Events"
        key code "0" 
        end tell
        
        delay 0.1

        tell application "System Events"
        key code "36" 
        end tell

        delay 0.1

        tell application "System Events"
          tell process "Dragon Dictate"
            set value of text area 1 of scroll area 1 of group 3 of splitter group 1 of window "Commands" to "#{body}"
          end tell
        end tell

        delay 0.1

        tell application "System Events"
          tell process "Dragon Dictate"
            click button "Compile" of splitter group 1 of window "Commands"
          end tell
        end tell
        
        delay 0.4

        tell application "System Events"
          tell process "Dragon Dictate"
            click button "Save" of splitter group 1 of window "Commands"
          end tell
        end tell

        delay 0.9
        """
      final.push script

    f =
      """osascript <<EOD
      #{final.join("\n")}
      EOD
      """
    # console.log f
    Shell.exec f, async: true
    true
    
  # Meteor.call("makeDragonCommandsForList", a)
  makeDragonCommandsForList: (keys) ->
    final = []
    _.each keys, (key) ->
      command = new Commands.Base(key, null)
      body = command.generateFullCommand().replace(/["]/g, "\\\"").replace(/\\\\/g, "\\\\\\\\\\")
      dragonName = command.generateDragonCommandName()
      script = 
        """
        tell application "Dragon Dictate" to activate
        delay 0.1

        tell application "System Events"
          tell process "Dragon Dictate"
            click button 1 of group 2 of splitter group 1 of window "Commands"
          end tell
        end tell

        delay 0.2

        tell application "System Events"
          tell process "Dragon Dictate"
            set value of text field 3 of splitter group 1 of window "Commands" to "#{dragonName}"
          end tell
        end tell

        tell application "System Events"
          tell process "Dragon Dictate"
            click pop up button 1 of splitter group 1 of window "Commands"
          end tell
        end tell

        delay 0.1

        tell application "System Events"
        key code "0" 
        end tell
        
        delay 0.1

        tell application "System Events"
        key code "36" 
        end tell

        delay 0.1

        tell application "System Events"
          tell process "Dragon Dictate"
            set value of text area 1 of scroll area 1 of group 3 of splitter group 1 of window "Commands" to "#{body}"
          end tell
        end tell

        delay 0.1

        tell application "System Events"
          tell process "Dragon Dictate"
            click button "Compile" of splitter group 1 of window "Commands"
          end tell
        end tell
        
        delay 0.4

        tell application "System Events"
          tell process "Dragon Dictate"
            click button "Save" of splitter group 1 of window "Commands"
          end tell
        end tell

        delay 0.9
        """
      final.push script

    f =
      """osascript <<EOD
      #{final.join("\n")}
      EOD
      """
    # console.log f
    Shell.exec f, async: true
    true
