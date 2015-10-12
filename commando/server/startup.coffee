Meteor.startup ->
  console.log "Copyright (c) VoiceCode.io 2015 - all rights reserved"
  @Grammar = new Grammar()
  @alphabet = new Alphabet()
  repetition = new Repetition()
  @modifiers = new Modifiers()
  @enabledCommandsManager = new EnabledCommandsManager()
  @vocabulary = new Vocabulary() unless Settings.slaveMode
  Commands.performCommandEdits()
  Commands.loadConditionalModules(enabledCommandsManager.settings)
  modifiers.checkVocabulary() unless Settings.slaveMode
  @ParseGenerator = {}
  Commands.reloadGrammar()
  unless Settings.slaveMode
    @synchronizer = new Synchronizer()
    synchronizer.synchronize()

  if Settings.mouseTracking
    @mouseTracker = new MouseTracker().start()
