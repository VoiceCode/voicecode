Meteor.methods
  performActionForCommandStatus: (id) ->
    s = CommandStatuses.findOne id
    if s
      if @isSimulation
        CommandStatuses.remove s._id
      else
        s.performReconciliation()

  enableCommands: (names) ->
    console.log enabling: names
    for name in names
      Commands.mapping[name].enabled = true
    if @isSimulation

    else
      @unblock()
      enabledCommandsManager.enable(names)
      Commands.reloadGrammar()
      unless Settings.slaveMode
        synchronizer.synchronize()
        modifiers.checkVocabulary()
  disableCommands: (names) ->
    console.log disabling: names
    for name in names
      Commands.mapping[name].enabled = false
    if @isSimulation

    else
      @unblock()
      enabledCommandsManager.disable(names)
      Commands.reloadGrammar()
      unless Settings.slaveMode
        synchronizer.synchronize()
        modifiers.checkVocabulary()
