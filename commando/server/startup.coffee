Meteor.startup ->
  console.log "Copyright (c) VoiceCode.io 2015 - all rights reserved"
  @ParseGenerator = {}
  @userAssetsController = new UserAssetsController
  userAssetsController.init()
  @Grammar = new Grammar()
  @alphabet = new Alphabet()
  repetition = new Repetition()
  @modifiers = new Modifiers()
  @enabledCommandsManager = new EnabledCommandsManager()

  if Settings.slaveMode
    _.each Commands.mapping, (command, name) ->
      Commands.enable name

  Commands.initialize()

  unless false
    @vocabulary = new Vocabulary()
    if Settings.dragonCommandMode is 'new-school'
      @newSchoolCommandMode = new @NewSchoolCommandMode
      @newSchoolCommandMode.generate(4).create()


  unless false
    @synchronizer = new Synchronizer()
    synchronizer.synchronize()


  Commands.reloadGrammar()

  if Settings.mouseTracking
    @mouseTracker = new MouseTracker().start()
