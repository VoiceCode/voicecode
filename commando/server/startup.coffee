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
  switch platform
    when "darwin"
      @$ = Meteor.npmRequire('nodobjc')
      @Actions = new Platforms.osx.actions()
      @darwinController = new DarwinController()
    when "win32"
      @Actions = new Platforms.windows.actions()
    when "linux"
      @Actions = new Platforms.linux.actions()


  @ParseGenerator = {}
  @Grammar = new Grammar
  @alphabet = new Alphabet
  repetition = new Repetition
  @modifiers = new Modifiers
  @enabledCommandsManager = new EnabledCommandsManager
  @userAssetsController = new UserAssetsController

  if Settings.slaveMode
    _.each Commands.mapping, (command, name) ->
      Commands.enable name

  Commands.initialize()

  unless Settings.slaveMode
    @vocabulary = new Vocabulary()
    if Settings.dragonCommandMode is 'new-school'
      @newSchoolCommandMode = new NewSchoolCommandMode
      @newSchoolCommandMode.generate(4).create()


  unless Settings.slaveMode
    @synchronizer = new Synchronizer()
    synchronizer.synchronize()


  Commands.reloadGrammar()

  if Settings.mouseTracking
    @mouseTracker = new MouseTracker().start()



  # booster = new Booster
  # booster.gogo()
