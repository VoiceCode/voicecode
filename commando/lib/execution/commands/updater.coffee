@CommandUpdater = 
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
  activateScope: (scope) ->
    """

    tell application "#{@dictateName()}"
      try
        set g to group "#{scope}"
      on error errMsg number errNum
        tell application "#{@dictateName()}"
          set show Available Commands to true
          set wasListening to listening
          set listening to true
        end tell

        delay 0.3

        tell application "System Events"
          set currentName to name of first application process whose frontmost is true
        end tell

        tell application "#{scope}" to activate
        delay 0.5
        set g to group "#{scope}"

        tell application "#{@dictateName()}"
          set listening to false
        end tell
      end try
    end tell


    """
  getAllStatuses: (scope) ->
    console.log "getting all command statuses for: #{scope}"
    # digests = []
    Commands.loadConditionalModules()
    scope = scope or @globalName()
    script = ""
    script += CommandUpdater.activateScope(scope) unless scope is @globalName()
    script += """

    set prevDelimiter to AppleScript's text item delimiters
    set AppleScript's text item delimiters to "||"
    tell application "#{@dictateName()}"
      set show Available Commands to true
      delay 0.5
      set show Available Commands to false

      set names to (name of commands of (group "#{scope}")) as string
      set descriptions to (description of commands of (group "#{scope}")) as string
      set results to names & "||" & descriptions
    end tell
    set AppleScript's text item delimiters to prevDelimiter
    return results
    """

    script = """osascript <<EOD
    #{script}
    EOD
    """
    # Shell.exec script, async: true
    r = Execute script
    results = r.split("||")
    resultMap = {}
    names = results.splice(0, results.length / 2)
    _.each names, (item, index) ->
      if item.indexOf("/!Text!/") >= 0
        resultMap[item.trim()] = results[index]

    console.log resultMap

    _.each Commands.Utility.enabledCommandNames(), (name) ->
      command = new Commands.Base(name, null)
      digest = command.digest()
      dragonName = command.generateDragonCommandName()
      myScopes = command.getTriggerScopes()
      if _.contains myScopes, scope
        value = resultMap[dragonName]
        status = if value?
          if value.indexOf(digest) >= 0
            "current"
          else
            console.log name
            "dirty"
        else if command.needsDragonCommand()
          "missing"
        else
          "unspoken"
        delete resultMap[dragonName]

        # CommandStatuses.findOrCreate name, status, scope
        CommandStatuses.insert
          name: name
          status: status
          scope: scope

    _.each resultMap, (value, key) ->
      # CommandStatuses.findOrCreate key, "removed", scope
      CommandStatuses.insert
        name: key
        status: "removed"
        scope: scope




    # Meteor.setTimeout ->
    true


    # _.each _.keys(Commands.mapping), (key) ->
    #   CommandUpdater.getCommandStatus(key)

  getCommandStatus: (name) ->
    console.log "currentCommandStatus: #{name}, #{scope}"
    if Commands.mapping[name]?
      command = new Commands.Base(name, null)
      digest = command.digest()
      dragonName = command.generateDragonCommandName()
      scope = command.getTriggerScope()
      script = ""
      unless scope is @globalName()
        script += """

        tell application "System Events"
          set currentName to name of first application process whose frontmost is true
          set needsChange to (currentName is not "#{scope}")
        end tell

        if (needsChange) then
          tell application "#{scope}" to activate
          delay 4
        end if
        """
      script += """

      tell application "#{@dictateName()}"
        set doesExist to ((name of command "#{dragonName}" of group "#{scope}") is "#{dragonName}")
        if doesExist
          set c to content of command "#{dragonName}" of group "#{scope}"
          return c
        else
          return "not present"
        end if
      end tell
      """
      f = """osascript <<EOD
      #{script}
      EOD
      """
      # console.log f
      # e = Meteor.wrapAsync(Shell.exec, Shell)
      # Shell.exec f, (code, data) ->
      try
        data = Execute(f)
        status = if data?.length
          if data.indexOf("not present") > -1
            "missing"
          else if data.indexOf(digest) > -1
            "current"
          else
            "dirty"
      catch e
        console.log e
        status = "error"

      CommandStatuses.findOrCreate name, status, scope
    else
      status = "missing"
      CommandStatuses.findOrCreate name, status, scope

  updateAll: (scope) ->
    _.each CommandStatuses.find({scope: scope, status: "dirty"}, {limit: 90}).fetch(), (item) ->
      item.performReconciliation()
  createAll: (scope) ->
    _.each CommandStatuses.find({scope: scope, status: "missing"}, {limit: 90}).fetch(), (item) ->
      item.performReconciliation()
  deleteAll: (scope) ->
    _.each CommandStatuses.find({scope: scope, status: "removed"}, {limit: 90}).fetch(), (item) ->
      item.performReconciliation()
