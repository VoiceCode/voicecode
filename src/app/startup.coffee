# https://gist.github.com/dimatter/0206268704609de07119
Function::property = (prop, desc) ->
  Object.defineProperty @prototype, prop, desc

global.developmentMode = true
testing = true

global.projectRoot = require('app-root-path').path
global.platform =
  switch process.platform
    when "darwin"
      "darwin"
    when "win32"
      "windows"
    when "linux"
      "linux"

if developmentMode or testing
  replify = require('replify')
  repl = require('http').createServer()
  replify 'vc', repl
  client = require('electron-connect').client

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


global.$ = require('nodobjc')
global.Events = require './event_emitter'
global.path = require 'path'
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
  menubar.window.on 'reload', -> Events.frontendClearSubscriptions()
  if developmentMode
    client = client.create menubar.window


process.on 'uncaughtException', (err) ->
  console.log chalk.white.bold.bgRed('   UNCAUGHT EXCEPTION   ')
  console.log err.stack
  process.exit(1)

Events.on 'applicationStart', ->
  funk = asyncblock.nostack
  if developmentMode
    funk = asyncblock
  funk (startupFlow) ->
    startupFlow.firstArgIsError = false
    global.Settings = require "../lib/platforms/#{platform}/settings"
    Settings.userAssetsPath = '~/voicecode_user_development' # DEVELOPMENT
    global.Packages = require '../lib/packages/packages'
    # A package for platform specific global commands
    Packages.register
      name: global.platform
      description: "#{_.startCase global.platform} "

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
        _path = path.join '../lib', 'platforms', 'darwin'
        global.Actions = require "#{_path}/actions"
        global.SystemInfo = require "#{_path}/system_info"
        global.DarwinController = require "#{_path}/darwin_controller"
      when "win32"
        global.Actions = require '../lib/platforms/windows/actions'
      when "linux"
        global.Actions = require '../lib/platforms/linux/actions'

    requireDirectory = require 'require-directory'

    requireDirectory module, '../lib/execution/',
      visit: (required) ->
        if (not _.isEmpty required) and _.isObject required
          _.each required, (value, key) -> global[key] = value

    requireDirectory module, '../packages/', # do we need to pass module in here?
      exclude: (path) ->
        not /.*package\.js$/.test path
      visit: (required) ->
        if (not _.isEmpty required) and _.isObject required
          _.each required, (value, key) -> global[key] = value

    Commands.Utility = require '../lib/utility/utility'
    global.SlaveController = require './slave_controller'
    global.ParserController = require '../lib/parser/parser_controller'

    Commands.initialize()

    Events.once 'userCommandEditsPerformed', startupFlow.add 'user_code_loaded'
    UserAssetsController.getAssets 'packages/**/package.coffee'
    UserAssetsController.getAssets '**/*.coffee', (path) ->
      return true if /packages/.test path
      return true if /settings\.coffee/.test path
      return true if /generated/.test path
      return false
    startupFlow.wait 'user_code_loaded'
    require './enabled_commands_manager'

    if developmentMode
      Settings.slaveMode = true
      Settings.chromeExtension = false
      # Settings.dontMessWithMyDragon = true


    if Settings.slaveMode or developmentMode
      _.each Commands.mapping, (command, name) ->
        Commands.enable name
      Commands.performCommandEdits('slaveModeEnableAllCommands')

    switch platform
      when "darwin"
        _path = "../lib/platforms/darwin/dragon"
        global.DragonController = require "#{_path}/dragon_controller"
        global.DragonVocabularyController = require "#{_path}/dragon_vocabulary_controller"
      # when "win32"
      # when "linux"

    unless Settings.slaveMode
      global.Synchronizer = require './synchronize'
      Synchronizer.synchronize()

    emit "startupFlowComplete"

# needed while developing ui
Events.once 'startupFlowComplete', -> global.startedUp = true


# benchmarking
Events.on 'chainDidExecute', ->
  console.timeEnd 'CHAIN'
Events.on 'chainWillExecute', ->
  console.time 'CHAIN'




emit 'applicationStart'
