@CommandStatuses = new Mongo.Collection("commandStatuses")

Schemas.CommandStatus = new SimpleSchema
  name:
    type: String
    index: false
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
  locale: ->
    Settings.localeSettings[Settings.locale]
  dictateName: ->
    @locale().dragonApplicationName or "Dragon Dictate"
  commandsWindowName: ->
    @locale().dragonCommandsWindowName or "Commands"
  saveButtonName: ->
    @locale().dragonSaveButtonName or "Save"
  globalName: ->
    @locale().dragonGlobalName or "Global"
  performCreate: ->
    command = @getCommand()
    body = command.generateDragonBody().replace(/["]/g, "\\\"").replace(/\\\\/g, "\\\\\\\\\\").replace(/\$/, "\\$")
    dragonName = command.generateDragonCommandName()
    scope = @scope
    digest = command.digest()
    script = ""
    script += CommandUpdater.activateScope(scope) unless scope is @globalName()
    script += """
      tell application "#{@dictateName()}" to activate
      delay 0.1

      tell application "System Events"
        keystroke "k" using {command down}
      end tell

      delay 0.2

      tell application "System Events"
        tell process "#{@dictateName()}"
          tell table 1 of scroll area 1 of splitter group 1 of window "#{@commandsWindowName()}"
            select (row 1 where value of text field 1 is "#{scope}")
          end tell
        end tell
      end tell

      tell application "#{@dictateName()}"
        set g to group "#{scope}"
        set myProperties to {name:"#{dragonName}", description:"#{digest}", content:"#{body}", active:true, command type:shell script, command mode:true, dictation mode:true, recognition training mode:true, sleep mode:false, user created:true, spelling mode:false, application name:"#{scope}"}
        set c to make new command at g with properties myProperties
        reveal c
      end tell

      delay 0.4

      tell application "System Events"
        tell process "#{@dictateName()}"
          click button "#{@saveButtonName()}" of splitter group 1 of window "#{@commandsWindowName()}"
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
    script += CommandUpdater.activateScope(@scope) unless @scope is @globalName()
    script += """
      tell application "#{@dictateName()}" to activate

      delay 0.2

      tell application "#{@dictateName()}"
        reveal command "#{@name}" of group "#{@scope}"
      end tell

      delay 0.3

      tell application "System Events"
        tell process "#{@dictateName()}"
          tell table 1 of scroll area 1 of splitter group 1 of window "#{@commandsWindowName()}"
            select (row 1 where value of text field 1 is "#{@scope}")
          end tell
        end tell
      end tell

      tell application "#{@dictateName()}"
        reveal command "#{@name}" of group "#{@scope}"
      end tell

      delay 2

      tell application "System Events"
        tell process "#{@dictateName()}"
          set value of attribute "AXFocused" of button 2 of group 2 of splitter group 1 of window "#{@commandsWindowName()}" to true
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
    body = command.generateDragonBody().replace(/["]/g, "\\\"").replace(/\\\\/g, "\\\\\\\\\\").replace(/\$/, "\\$")
    dragonName = command.generateDragonCommandName()
    scope = @scope
    digest = command.digest()

    script = ""
    script += CommandUpdater.activateScope(scope) unless scope is @globalName()
    script += """
    tell application "#{@dictateName()}" to activate

    delay 0.2

    tell application "#{@dictateName()}"
      set c to command "#{dragonName}" of group "#{scope}"
      tell c to reveal
    end tell

    delay 0.3

    tell application "System Events"
      tell process "#{@dictateName()}"
        tell table 1 of scroll area 1 of splitter group 1 of window "#{@commandsWindowName()}"
          select (row 1 where value of text field 1 is "#{scope}")
        end tell
      end tell
    end tell

    tell application "#{@dictateName()}"
      reveal command "#{dragonName}" of group "#{scope}"
    end tell

    tell application "System Events"
      tell process "#{@dictateName()}"
        click pop up button 1 of splitter group 1 of window "#{@commandsWindowName()}"
      end tell
    end tell

    tell application "System Events"
    keystroke "s"
    end tell

    tell application "System Events"
    key code 36
    key code 48
    end tell

    delay 0.1

    tell application "System Events"
      tell process "#{@dictateName()}"
        set value of attribute "AXFocused" of (text field 2 of splitter group 1 of window "#{@commandsWindowName()}") to true
        delay 0.2
        keystroke "#{digest}"
        delay 0.2
        set value of text area 1 of scroll area 3 of splitter group 1 of window "#{@commandsWindowName()}"  to "#{body}"
      end tell
    end tell
    delay 0.4

    delay 0.3
    tell application "System Events"
    key code 48
    end tell
    delay 0.3


    tell application "System Events"
      tell process "#{@dictateName()}"
        click button "#{@saveButtonName()}" of splitter group 1 of window "#{@commandsWindowName()}"
      end tell
    end tell
    """
    script = """osascript <<EOD
    #{script}
    EOD
    """
    console.log script
    Execute script
    true
  getCommand: ->
    new Commands.Base(@name, null)
