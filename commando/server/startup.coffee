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
  unless Settings.slaveMode
    Commands.reloadGrammar()
    @synchronizer = new Synchronizer()
    synchronizer.synchronize()
  if Settings.slaveMode
    _.each Commands.mapping, (command, name) ->
      Commands.mapping[name].enabled = true
    enabledCommandsManager.enable(_.keys Commands.mapping)
    Commands.reloadGrammar()
  if Settings.mouseTracking
    @mouseTracker = new MouseTracker().start()
