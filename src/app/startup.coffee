global.app = require 'app'

# https://gist.github.com/dimatter/0206268704609de07119
Function::property = (prop, desc) ->
  Object.defineProperty @prototype, prop, desc

global.developmentMode = true
testing = true
# app.commandLine.appendSwitch('remote-debugging-port', '9222')


global.projectRoot = require('app-root-path').path
global.platform =
  switch process.platform
    when "darwin"
      "darwin"
    when "win32"
      "windows"
    when "linux"
      "linux"

if testing
  replify = require('replify')
  repl = require('http').createServer()
  replify 'vc', repl
  electronConnect = require('electron-connect').client

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

global.$ = require 'nodobjc'
global.path = require 'path'
global.Fiber = require 'fibers'
global.Events = require './event_emitter'
global.asyncblock = require 'asyncblock'
global.requireDirectory = require 'require-directory'
global.numberToWords = require '../lib/utility/numberToWords'
global.SelectionTransformer = require '../lib/utility/selectionTransformer'
global.Transforms = require '../lib/utility/transforms'
global.windowController = require '../app/window_controller'
require '../lib/utility/deep_extension' # _.deepExtend

global.menubar = require('menubar')
  index: "file://#{projectRoot}/src/frontend/main.html"
  icon: "#{projectRoot}/assets/vc_tray.png"
  width: 854
  height: 666
  x: 0
  y: 0
  windowPosition: 'trayRight'
  alwaysOnTop: true
  'always-on-top': true
  showDockIcon: false


menubar.on 'ready', ->
  # emit 'mainWindowReady', menubar
  menubar.showWindow()

menubar.on 'after-create-window', ->
  windowController.set 'main', menubar.window
  # menubar.window.webContents.executeJavaScript 'require("coffee-script/register")'
  # menubar.window.webContents.executeJavaScript 'require("node-cjsx").transform()'
  menubar.window.openDevTools()
  menubar.window.on 'closed', -> return
  menubar.window.on 'reload', -> Events.frontendClearSubscriptions()
  if testing
    electronConnect = electronConnect.create menubar.window

app.on 'ready', ->
  # emit 'appReady'#, app


process.on 'uncaughtException', (err) ->
  console.log chalk.white.bold.bgRed('   UNCAUGHT EXCEPTION   ')
  console.log err
  console.log err.stack
  process.emit 'exit'
  process.exit(1)

Events.on 'applicationShouldStart', ->
  funk = asyncblock.nostack
  if developmentMode
    funk = asyncblock
  funk (startupFlow) ->
    startupFlow.firstArgIsError = false
    global.Settings = require "../lib/platforms/#{platform}/settings"
    Settings.userAssetsPath = '~/voicecode_user'
    if developmentMode
      Settings.userAssetsPath = '~/voicecode_user_development'
    global.Packages = require '../lib/packages/packages'
    # A package for platform specific global commands
    Packages.register
      name: global.platform
      description: "#{_.startCase global.platform} "

    global.Commands = require '../lib/commands'
    global.Scope = require '../lib/scope'

    global.AssetsController = require './assets_controller'
    Events.once 'settingsAssetsLoaded', startupFlow.add 'settingsAssetsLoaded'
    AssetsController.getAssets 'settings', 'settings.coffee'
    startupFlow.wait 'settingsAssetsLoaded'

    global.Command = require '../lib/command'
    global.grammarContext = require '../lib/parser/grammarContext'
    global.GrammarState = require '../lib/parser/grammar_state'
    global.Grammar = require '../lib/parser/grammar'
    global.Chain = require '../lib/chain'
    global.HistoryController = require '../lib/history_controller'
    _.extend global, require './shell' # Execute, Applescript
    Commands.Utility = require '../lib/utility/utility'
    global.SlaveController = require './slave_controller'
    global.ParserController = require '../lib/parser/parser_controller'

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

    # requireDirectory module, '../packages/',
    #   exclude: (path) ->
    #     not /.*package\.js$/.test path
    #   visit: (required) ->
    #     if (not _.isEmpty required) and _.isObject required
    #       _.each required, (value, key) -> global[key] = value
    emit 'startupFlow:corePackagesLoaded'

    Events.once 'packageAssetsLoaded', startupFlow.add 'packageAssetsLoaded'
    AssetsController.getAssets 'package', 'packages/**/package.coffee'
    startupFlow.wait 'packageAssetsLoaded'
    emit 'startupFlow:userPackagesLoaded'

    Events.once 'userAssetsLoaded', startupFlow.add 'userAssetsLoaded'
    AssetsController.getAssets 'user', '**/*.coffee', (path) ->
      return true if /packages/.test path
      return true if /settings\.coffee/.test path
      return true if /generated/.test path
      return false
    startupFlow.wait 'userAssetsLoaded'
    emit 'startupFlow:userCodeLoaded'

    require './enabled_commands_manager'

    if developmentMode
      Settings.slaveMode = true
      Settings.dragonProcessControl = true


    if Settings.slaveMode or developmentMode
      _.each Commands.mapping, (command, name) ->
        Commands.enable name
      Commands.performCommandEdits('slaveModeEnableAllCommands')

    switch platform
      when "darwin"
        _path = "../lib/platforms/darwin/dragon"
        global.DragonController = require "#{_path}/dragon_controller"
        require("#{_path}/dragon_vocabulary_controller").start()
      # when "win32"
      # when "linux"

    unless Settings.slaveMode
      global.Synchronizer = require './synchronize'
      Synchronizer.synchronize()

    emit "startupFlow:complete"

# needed while developing ui
Events.once 'startupFlow:complete', -> global.startedUp = true

# benchmarking
if developmentMode
  Events.on 'chainDidExecute', ->
    console.timeEnd 'CHAIN'
  Events.on 'chainWillExecute', ->
    console.time 'CHAIN'
