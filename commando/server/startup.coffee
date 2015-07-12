detectPlatform = ->
  switch process.platform
    when "darwin"
      "osx"
    when "win32"
      "windows"
    when "linux"
      "linux"

Meteor.startup ->
  console.log "Copyright (c) VoiceCode.io 2015 - all rights reserved"
  @platform = detectPlatform()
  @Grammar = new Grammar()
  @alphabet = new Alphabet()
  repetition = new Repetition()
  @modifiers = new Modifiers()
  @enabledCommandsManager = new EnabledCommandsManager()
  @vocabulary = new Vocabulary()
  Commands.loadConditionalModules(enabledCommandsManager.settings)
  modifiers.checkVocabulary()
  @ParseGenerator = {}
  Commands.reloadGrammar()
  @synchronizer = new Synchronizer()
  synchronizer.synchronize(true)
