detectPlatform = ->
  switch process.platform
    when "darwin"
      "darwin"
    when "win32"
      "windows"
    when "linux"
      "linux"

detectProjectRoot = ->
  switch platform
    when "darwin"
      process.env.PWD
    when "windows"
      process.cwd().split("\\.meteor")[0]
    when "linux"
      process.env.PWD


Meteor.startup ->
  console.log "Copyright (c) VoiceCode.io 2015 - all rights reserved"
  @platform = detectPlatform()
  @projectRoot = detectProjectRoot()

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
  synchronizer.synchronize()
