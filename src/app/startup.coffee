global.projectRoot = require('app-root-path').path
global.platform =
  switch process.platform
    when "darwin"
      "darwin"
    when "win32"
      "windows"
    when "linux"
      "linux"
# DEVELOPMENT
replify = require('replify')
repl = require('http').createServer()
replify 'vc', repl
# DEVELOPMENT

global._ = require 'lodash'
global.chalk = require 'chalk'
util = require('util')

global.debug = ->
  console.log chalk.white.bold.bgRed('   DEBUG   ')
  console.log util.inspect (_.toArray arguments), {showHidden: true, depth: 2, colors: true}

application = require 'app'
BrowserWindow = require 'browser-window'
client = require('electron-connect').client # DEVELOPMENT
global.$ = require('nodobjc')
global.Events = require './event_emitter'
global.Fiber = require 'fibers'
global.asyncblock = require 'asyncblock'
require '../lib/utility/deep_extension'

process.on 'uncaughtException', (err) ->
  console.log chalk.white.bold.bgRed('   UNCAUGHT EXCEPTION   ')
  console.log err.stack
  process.exit(1)

Events.on 'applicationStart', ->
  asyncblock (startupFlow) -> # DEVELOPMENT
  # asyncblock.nostack (startupFlow) ->
    startupFlow.firstArgIsError = false
    # startupFlow.taskTimeout = 3
    # startupFlow.timeoutIsError = false
    # startupFlow.errorCallback = debug

    global.Settings = require './settings'
    Settings.userAssetsPath = '~/voicecode_user_development' # DEVELOPMENT
    global.Homonyms = require '../lib/utility/homonyms'
    global.Packages = require '../lib/packages/packages'
    global.Commands = require '../lib/commands'
    global.Scope = require '../lib/scope'
    global.UserAssetsController = require './user_assets_controller'
    Events.once 'userAssetsLoaded', startupFlow.add 'user_settings'
    UserAssetsController.getAssets 'user_settings.coffee'
    startupFlow.wait 'user_settings'
    global.Command = require '../lib/command'
    global.Grammar = require '../lib/parser/grammar'
    global.Chain = require '../lib/chain'
    global.HistoryController = require '../lib/history_controller'
    requireDirectory = require 'require-directory'
    requireDirectory module, '../lib/execution/',
      visit: (required) ->
        if (not _.isEmpty required) and _.isObject required
          _.each required, (value, key) -> global[key] = value
    requireDirectory module, '../packages/',
      visit: (required) ->
        if (not _.isEmpty required) and _.isObject required
          _.each required, (value, key) -> global[key] = value
    Commands.Utility = require '../lib/utility/utility'
    global.SlaveController = require './slave_controller'
    _.extend global, require './shell' # Execute, Applescript
    global.Alphabet = require '../lib/alphabet'
    global.Repetition = require '../lib/repetition'
    global.Modifiers = require '../lib/modifiers'
    global.ParserController = require '../lib/parser/parser_controller'
    global.Synchronizer = require './synchronize'
    Commands.initialize()
    _.extend global, require './settings_manager' # EnabledCommandsManager, SettingsManager
    Events.once 'userCommandEditsPerformed', startupFlow.add 'user_code_loaded'
    UserAssetsController.getAssets '**/*.coffee', '**/user_settings.coffee' # wandering into asynchronous land
    startupFlow.wait 'user_code_loaded' # synchronous again
    if Settings.slaveMode
      _.each Commands.mapping, (command, name) ->
        Commands.enable name
      Commands.performCommandEdits('slaveModeEnableAllCommands')


    # DEVELOPER MODE ONLY
    Settings.slaveMode = true
    Settings.dontMessWithMyDragon = true

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

    # unless Settings.slaveMode
    Synchronizer.synchronize()

    mainWindow = null
    # application.on 'ready', ->
      # mainWindow = new BrowserWindow
      #   width: 900
      #   height: 600
      # mainWindow.loadUrl "file://#{projectRoot}/dist/frontend/main.html"
      # mainWindow.openDevTools()
      # mainWindow.on 'closed', ->
      #   mainWindow = null
      #
      # client = client.create mainWindow

emit 'applicationStart'
