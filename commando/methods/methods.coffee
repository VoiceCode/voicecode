Meteor.methods
  performActionForCommandStatus: (id) ->
    s = CommandStatuses.findOne id
    if s
      if @isSimulation
        CommandStatuses.remove s._id
      else
        s.performReconciliation()

  enableCommand: (name) ->
    Commands.mapping[name].enabled = true
    if @isSimulation

    else
      @unblock()
      enabledCommandsManager.enable(name)
      Commands.reloadGrammar()
      synchronizer.synchronize()
      modifiers.checkVocabulary()
  disableCommand: (name) ->
    Commands.mapping[name].enabled = false
    if @isSimulation
      Session.set "commandsAreDirty", true
    else
      @unblock()
      enabledCommandsManager.disable(name)
      Commands.reloadGrammar()
      synchronizer.synchronize()
      modifiers.checkVocabulary()
