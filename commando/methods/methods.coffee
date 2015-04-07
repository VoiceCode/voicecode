Meteor.methods
  performActionForCommandStatus: (id) ->
    s = CommandStatuses.findOne id
    if s
      if @isSimulation
        CommandStatuses.remove s._id
      else
        s.performReconciliation()
      
  enableCommand: (name) ->
    if @isSimulation
      Session.set "commandsAreDirty", true
    Commands.mapping[name].enabled = true
    Enables.update
      name: name,
    ,
      $set:
        enabled: true
        name: name
    ,
      upsert: true
  disableCommand: (name) ->
    if @isSimulation
      Session.set "commandsAreDirty", true
    Commands.mapping[name].enabled = false
    Enables.remove
      name: name