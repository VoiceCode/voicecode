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
    body = command.generateDragonBody().replace(/["]/g, "\\\"").replace(/\\\\/g, "\\\\\\\\\\").replace(/\$/, "\\$")
    dragonName = command.generateDragonCommandName()
    scope = command.getTriggerScope()

    script = 
      """osascript <<EOD
      tell application "Dragon Dictate" to activate
      delay 0.1

      tell application "System Events"
        keystroke "k" using {command down}
      end tell

      delay 0.2

      tell application "System Events"
        tell process "Dragon Dictate"
          tell table 1 of scroll area 1 of splitter group 1 of window "Commands"
            select (row 1 where value of text field 1 is "#{scope}")
          end tell
        end tell
      end tell

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
      keystroke "s" 
      end tell

      tell application "System Events"
      key code "36" 
      end tell

      delay 0.1

      tell application "System Events"
        tell process "Dragon Dictate"
          set value of text area 1 of scroll area 3 of splitter group 1 of window "Commands"  to "#{body}"
        end tell
      end tell

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
      body = command.generateDragonBody().replace(/["]/g, "\\\"").replace(/\\\\/g, "\\\\\\\\\\").replace(/\$/, "\\$")
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
      body = command.generateDragonBody().replace(/["]/g, "\\\"").replace(/\\\\/g, "\\\\\\\\\\").replace(/\$/, "\\$")
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
  # compileApplescripts: ->
  #   _.each _.keys(Commands.mapping)
  updateDragonCommand: (name) ->
    command = new Commands.Base(name, null)
    body = command.generateDragonBody().replace(/["]/g, "\\\"").replace(/\\\\/g, "\\\\\\\\\\").replace(/\$/, "\\$")
    dragonName = command.generateDragonCommandName()
    script = """osascript <<EOD
    tell application "Dragon Dictate" to activate
    delay 0.3

    tell application "Dragon Dictate"
      reveal command "#{dragonName}" of group "Global"
    end tell


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

    EOD
    """
    console.log script
    Shell.exec script, async: true
    true
  findDragonCommand: (name) ->
    command = new Commands.Base(name, null)
    dragonName = command.generateDragonCommandName()
    # script = """
    # tell application "Dragon Dictate" to activate
    # delay 0.1
    # tell application "System Events"
    #   tell process "Dragon Dictate"
    #     set focused of (text field 1 of splitter group 1 of window "Commands") to true
    #     delay 0.2
    #     set value of text field 1 of splitter group 1 of window "Commands"  to "#{dragonName}"
    #   end tell
    # end tell
    # """
    script = """
    tell application "Dragon Dictate"
      reveal command "#{dragonName}" of group "Global"
    end tell
    """
    f = """osascript <<EOD
    #{script}
    EOD
    """
    # console.log f
    Shell.exec f, async: true
    true
  getAllCommandStatuses: ->
    try
      CommandStatuses.remove({})
      _.each Settings.dragonContexts, (context) ->
        CommandUpdater.getAllStatuses(context)
    catch e
      console.log e
  updateAllCommandStatuses: (scope) ->
    try
      CommandUpdater.updateAll(scope)
    catch e
      console.log e
  createAllCommandStatuses: (scope) ->
    try
      CommandUpdater.createAll(scope)
    catch e
      console.log e
  deleteAllCommandStatuses: (scope) ->
    try
      CommandUpdater.deleteAll(scope)
    catch e
      console.log e
  currentCommandStatus: (name, scope) ->
    CommandUpdater.getCommandStatus(name, scope)


