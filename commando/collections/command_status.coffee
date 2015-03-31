@CommandStatuses = new Mongo.Collection("commandStatuses")

Schemas.CommandStatus = new SimpleSchema
  name:
    type: String
    index: 1
    unique: true
  status:
    type: String
  scope:
    type: String

CommandStatuses.attachSchema(Schemas.CommandStatus)

Meteor.startup ->
  if Meteor.isServer
    CommandStatuses.remove({})
  
CommandStatuses.findOrCreate = (name, status, scope) ->
  record = CommandStatuses.update
    name: name,
    scope: scope
  ,
    $set:
      name: name
      status: status
      scope: scope
  ,
    upsert: true

CommandStatuses.helpers
  performReconciliation: ->
    switch @status
      when "missing"
        @performCreate()
      when "removed"
        @performDelete()
      when "dirty"
        @performUpdate()
    CommandStatuses.remove @_id
  performCreate: ->
    command = @getCommand()
    body = command.generateFullCommandWithDigest().replace(/["]/g, "\\\"").replace(/\\\\/g, "\\\\\\\\\\")
    dragonName = command.generateDragonCommandName()
    scope = command.getTriggerScope()
    digest = command.digest()
    script = ""
    script += CommandUpdater.activateScope(scope) unless scope is "Global"
    script += """
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

      tell application "Dragon Dictate"
        set g to group "#{scope}"
        set myProperties to {name:"#{dragonName}", description:"#{digest}", content:"#{body}", active:true, command type:AppleScript, command mode:true, dictation mode:true, recognition training mode:true, sleep mode:false, user created:true, spelling mode:false, application name:"#{scope}"}
        set c to make new command at g with properties myProperties
        reveal c
      end tell

      delay 0.4

      tell application "System Events"
        tell process "Dragon Dictate"
          click button "Save" of splitter group 1 of window "Commands"
        end tell
      end tell

      """
    script = """osascript <<EOD
    #{script}
    EOD
    """
    # console.log script
    Execute script
    true

  performDelete: ->
    script = ""
    script += CommandUpdater.activateScope(@scope) unless @scope is "Global"
    script += """
      tell application "Dragon Dictate" to activate

      delay 0.2

      tell application "Dragon Dictate"
        reveal command "#{@name}" of group "#{@scope}"
      end tell

      delay 0.3

      tell application "System Events"
        tell process "Dragon Dictate"
          tell table 1 of scroll area 1 of splitter group 1 of window "Commands"
            select (row 1 where value of text field 1 is "#{@scope}")
          end tell
        end tell
      end tell
        
      tell application "Dragon Dictate"
        reveal command "#{@name}" of group "#{@scope}"
      end tell

      delay 2

      tell application "System Events"
        tell process "Dragon Dictate"
          set value of attribute "AXFocused" of button 2 of group 2 of splitter group 1 of window "Commands" to true
        end tell
      end tell

      delay 0.3
      
      tell application "System Events"
        key code 125
        delay 0.1
        key code 125
        delay 0.1
        key code 36
        delay 0.5
        key code 36
      end tell
      """
    script = """osascript <<EOD
    #{script}
    EOD
    """
    console.log script
    Execute script
    true
  performUpdate: ->
    command = @getCommand()
    body = command.generateFullCommandWithDigest().replace(/["]/g, "\\\"").replace(/\\\\/g, "\\\\\\\\\\")
    dragonName = command.generateDragonCommandName()
    scope = command.getTriggerScope()
    digest = command.digest()

    script = ""
    script += CommandUpdater.activateScope(scope) unless scope is "Global"
    script += """
    tell application "Dragon Dictate" to activate

    delay 0.2

    tell application "Dragon Dictate"
      reveal command "#{dragonName}" of group "#{scope}"
    end tell

    delay 0.3

    tell application "System Events"
      tell process "Dragon Dictate"
        tell table 1 of scroll area 1 of splitter group 1 of window "Commands"
          select (row 1 where value of text field 1 is "#{scope}")
        end tell
      end tell
    end tell
      
    tell application "Dragon Dictate"
      reveal command "#{dragonName}" of group "#{scope}"
    end tell


    tell application "System Events"
      tell process "Dragon Dictate"
        set value of attribute "AXFocused" of (text field 2 of splitter group 1 of window "Commands") to true
        delay 0.2
        keystroke "#{digest}"
        delay 0.2
        set value of text area 1 of scroll area 1 of group 3 of splitter group 1 of window "Commands" to "#{body}"
      end tell
    end tell
    delay 0.4

    tell application "System Events"
      tell process "Dragon Dictate"
        click button "Save" of splitter group 1 of window "Commands"
      end tell
    end tell
    """
    script = """osascript <<EOD
    #{script}
    EOD
    """
    # console.log script
    Execute script
    true
  getCommand: ->
    new Commands.Base(@name, null)
