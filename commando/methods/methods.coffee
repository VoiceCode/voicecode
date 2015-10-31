Meteor.methods
  enableCommands: (names) ->
    console.log enabling: names
    for name in names
      Commands.enable name
    @unblock()
    Commands.reloadGrammar()
    unless Settings.slaveMode
      synchronizer.synchronize()
      modifiers.checkVocabulary()
  disableCommands: (names) ->
    console.log disabling: names
    for name in names
      Commands.disable name
    @unblock()
