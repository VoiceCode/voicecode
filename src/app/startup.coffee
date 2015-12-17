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
global._s = require 'underscore.string'
global.chalk = require 'chalk'
global.util = require('util')

global.debug = do ->
  previous = Date.now()
  ->
    console.log chalk.white.bold.bgRed('   ' + ((c = Date.now()) - previous) + '   ')
    console.log util.inspect (_.toArray arguments), {showHidden: false, depth: 10, colors: true}
    previous = c

client = require('electron-connect').client # DEVELOPMENT
global.$ = require('nodobjc')
global.Events = require './event_emitter'
global.Fiber = require 'fibers'
global.asyncblock = require 'asyncblock'
global.numberToWords = require '../lib/utility/numberToWords'
global.SelectionTransformer = require '../lib/utility/selectionTransformer'
global.Transforms = require '../lib/utility/transforms'
require '../lib/utility/deep_extension' # _.deepExtend?

mb = require 'menubar'
global.menubar = mb
  index: "file://#{projectRoot}/dist/frontend/main.html"
  icon: "#{projectRoot}/assets/vc_tray.png"
  width: 900
  height: 800
  x: 0
  y: 0
  'window-position': 'trayRight'
  'always-on-top': true
  showDockIcon: false

menubar.on 'ready', ->
  # menubar.showWindow()

menubar.on 'after-create-window', ->
  menubar.window.openDevTools()
  menubar.window.on 'closed', -> return
  client = client.create menubar.window
  client.on 'reload', -> Events.frontendClearSubscriptions()


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

    global.Settings = require "../lib/platforms/#{platform}/settings"
    Settings.userAssetsPath = '~/voicecode_user_development' # DEVELOPMENT
    global.Packages = require '../lib/packages/packages'
    global.Commands = require '../lib/commands'
    global.Scope = require '../lib/scope'
    global.UserAssetsController = require './user_assets_controller'
    Events.once 'userAssetsLoaded', startupFlow.add 'user_settings'
    UserAssetsController.getAssets 'settings.coffee'
    startupFlow.wait 'user_settings'
    global.Command = require '../lib/command'
    global.grammarContext = require '../lib/parser/grammarContext'
    global.GrammarState = require '../lib/parser/grammar_state'
    global.Grammar = require '../lib/parser/grammar'
    global.Chain = require '../lib/chain'
    global.HistoryController = require '../lib/history_controller'
    _.extend global, require './shell' # Execute, Applescript

    switch platform
      when "darwin"
        global.Actions = require '../lib/platforms/darwin/actions'
        global.SystemInfo = require '../lib/platforms/darwin/system_info'
        global.DarwinController = require '../lib/platforms/darwin/darwin_controller'
      when "win32"
        global.Actions = require '../lib/platforms/windows/actions'
      when "linux"
        global.Actions = require '../lib/platforms/linux/actions'

    requireDirectory = require 'require-directory'

    requireDirectory module, '../lib/execution/',
      visit: (required) ->
        if (not _.isEmpty required) and _.isObject required
          _.each required, (value, key) -> global[key] = value

    requireDirectory module, '../packages/',
      exclude: /.*node_modules.*/
      visit: (required) ->
        if (not _.isEmpty required) and _.isObject required
          _.each required, (value, key) -> global[key] = value

    Commands.Utility = require '../lib/utility/utility'
    global.SlaveController = require './slave_controller'
    global.Alphabet = require '../lib/alphabet'
    global.Repetition = require '../lib/repetition'
    global.Modifiers = require '../lib/modifiers'
    global.ParserController = require '../lib/parser/parser_controller'

    Commands.initialize()

    _.extend global, require './settings_manager' # EnabledCommandsManager, SettingsManager
    Events.once 'userCommandEditsPerformed', startupFlow.add 'user_code_loaded'
    UserAssetsController.getAssets '**/*.coffee', '**/settings.coffee' # wandering into asynchronous land
    startupFlow.wait 'user_code_loaded' # synchronous again

    # DEVELOPER MODE ONLY
    # Settings.slaveMode = true
    Settings.chromeExtension = true
    # Settings.dontMessWithMyDragon = true


    if Settings.slaveMode
      _.each Commands.mapping, (command, name) ->
        Commands.enable name
      Commands.performCommandEdits('slaveModeEnableAllCommands')

    switch platform
      when "darwin"
        if true
          global.DragonController = require '../lib/platforms/darwin/dragon/dragon_controller'
          global.DragonVocabularyController = require '../lib/platforms/darwin/dragon/dragon_vocabulary_controller'
      # when "win32"
      # when "linux"

    unless Settings.slaveMode
      global.Synchronizer = require './synchronize'
      Synchronizer.synchronize()

    emit "startupFlowComplete"

# needed while developing ui
Events.once 'startupFlowComplete', -> global.startedUp = true

emit 'applicationStart'
