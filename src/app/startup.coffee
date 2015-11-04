global.projectRoot = require('app-root-path').path
global.platform =
  switch process.platform
    when "darwin"
      "darwin"
    when "win32"
      "windows"
    when "linux"
      "linux"

global._ = require 'lodash'
global.chalk = require 'chalk'
global.debug = ->
  console.trace "%s \n", chalk.white.bold.bgRed('   DEBUG   '),
  _.toArray(arguments)
replify = require('replify')
repl = require('http').createServer()
replify 'vc', repl


application = require 'app'
BrowserWindow = require 'browser-window'
client = require('electron-connect').client
global.$ = require('nodobjc')
global.Events = require './event_emitter'
global.Fiber = require 'fibers'
global.asyncblock = require 'asyncblock'
# PRODUCTION:
# asyncblock.nostack (startupFlow) ->
asyncblock (startupFlow) ->
  startupFlow.firstArgIsError = false
  global.Settings = require './settings'
  global.UserAssetsController = require './user_assets_controller'
  # startupFlow.taskTimeout = 3
  # startupFlow.timeoutIsError = false
  startupFlow.errorCallback = debug
  Events.once 'userAssetEvaluation', startupFlow.add 'user_settings'
  UserAssetsController.getAssets 'user_settings.coffee'
  startupFlow.wait 'user_settings'
  global.Command = require '../lib/command'
  global.Grammar = require '../lib/parser/grammar'
  global.Commands = require '../lib/commands'
  global.Chain = require '../lib/chain'
  requireDirectory = require 'require-directory'
  requireDirectory module, '../lib/execution/',
    visit: (required)->
      if (not _.isEmpty required) and _.isObject required
        _.each required, (value, key) -> global[key] = value
  Commands.Utility = require '../lib/utility/utility'
  global.SlaveController = require './slave_controller'
  _.extend global, require './shell' # Execute, Applescript
  _.extend global, require './settings_manager' # EnabledCommandsManager, SettingsManager
  global.Alphabet = require '../lib/alphabet'
  global.Repetition = require '../lib/repetition'
  global.Modifiers = require '../lib/modifiers'
  global.ParserController = require '../lib/parser/parser_controller'
  Commands.initializationState = 'loadingFromSettings'
  _.each EnabledCommandsManager.settings, (enabled, name) ->
    if enabled
      Commands.enable name
    else
      Commands.disable name
  Commands.initialize() # why do we even have this?
  EnabledCommandsManager.subscribeToEvents()
  Commands.initializationState = 'loadingUserCode'
  UserAssetsController.getAssets '**/*.coffee', 'user_settings.coffee'
  Commands.initializationState = 'loaded'


  # DEVELOPER MODE ONLY
  Settings.slaveMode = false
  # Settings.dontMessWelectronithMyDragon = false

  switch platform
    when "darwin"
      global.Actions = require '../lib/platforms/darwin/actions'
      global.DarwinController = require '../lib/platforms/darwin/darwin_controller'
      unless Settings.slaveMode
        global.DragonController = require '../lib/platforms/darwin/dragon/dragon_controller'
    when "win32"
      global.Actions = require '../lib/platforms/windows/actions'
    when "linux"
      global.Actions = require '../lib/platforms/linux/actions'


  if Settings.slaveMode
    _.each Commands.mapping, (command, name) ->
      Commands.enable name

  ParserController.generateParser()

  mainWindow = null
  application.on 'ready', ->
    # mainWindow = new BrowserWindow
    #   width: 900
    #   height: 600
    # mainWindow.loadUrl "file://#{projectRoot}/dist/frontend/main.html"
    # mainWindow.openDevTools()
    # mainWindow.on 'closed', ->
    #   mainWindow = null

    # client = client.create mainWindow
