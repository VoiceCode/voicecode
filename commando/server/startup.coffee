console.log "Copyright (c) VoiceCode.io 2015 - all rights reserved"
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

@platform = detectPlatform()
@projectRoot = detectProjectRoot()

Meteor.startup ->
  @ParseGenerator = {}
  @Grammar = new Grammar
  repetition = new Repetition
  @userAssetsController = new UserAssetsController
  @enabledCommandsManager = new EnabledCommandsManager
  @alphabet = new Alphabet
  @modifiers = new Modifiers
  _.each enabledCommandsManager.settings, (command) ->
    Commands.enable command
  enabledCommandsManager.subscribeToEvents()
  userAssetsController.runUserCode()
  switch platform
    when "darwin"
      @$ = Meteor.npmRequire('nodobjc')
      @Actions = new Platforms.osx.actions()
      @darwinController = new DarwinController()
      unless Settings.slaveMode
        @dragonController = new DarwinDragonController()
    when "win32"
      @Actions = new Platforms.windows.actions()
    when "linux"
      @Actions = new Platforms.linux.actions()
  userAssetsController.watchForChanges()
  Commands.initialize()

  if Settings.slaveMode or true
    _.each Commands.mapping, (command, name) ->
      Commands.enable name

  unless Settings.slaveMode
    @vocabulary = new Vocabulary()
    if Settings.dragonCommandMode is 'new-school'
      @newSchoolCommandMode = new NewSchoolCommandMode
      @newSchoolCommandMode.generate(4).create()
    @synchronizer = new Synchronizer()
    synchronizer.synchronize()

  Commands.reloadGrammar()


  if Settings.mouseTracking
    @mouseTracker = new MouseTracker().start()
