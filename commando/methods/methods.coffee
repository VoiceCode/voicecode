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
    Enables.update
      name: name,
    ,
      $set:
        enabled: true
        name: name
    ,
      upsert: true
    if @isSimulation
      Session.set "commandsAreDirty", true
    else
      @unblock()
      Commands.reloadGrammar()
  disableCommand: (name) ->
    Commands.mapping[name].enabled = false
    Enables.remove
      name: name
    if @isSimulation
      Session.set "commandsAreDirty", true
    else
      @unblock()
      Commands.reloadGrammar()
