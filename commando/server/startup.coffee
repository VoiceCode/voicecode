Meteor.startup ->
  console.log "Copyright (c) VoiceCode.io 2015 - all rights reserved"
  @Grammar = new Grammar()
  @alphabet = new Alphabet()
  repetition = new Repetition()
  abbreviation = new Abbreviation()
  vocabulary = new Vocabulary()
  @enabledCommandsManager = new EnabledCommandsManager()
  Commands.loadConditionalModules(enabledCommandsManager.settings)
  @ParseGenerator = {}
  Commands.reloadGrammar()
  @synchronizer = new Synchronizer()
  synchronizer.updateAllCommands(true)
