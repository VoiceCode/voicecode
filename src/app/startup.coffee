# global.bundleId = 'io.voicecode.app'
global.bundleId = 'com.github.electron'
global.app = require 'app'

# https://gist.github.com/dimatter/0206268704609de07119
Function::property = (prop, desc) ->
  Object.defineProperty @prototype, prop, desc

process.env.NODE_ENV = 'production' # needed for react
global.developmentMode = process.argv[2]  == 'develop'
if developmentMode
  process.env.NODE_ENV = 'development'
  electronConnect = require('electron-connect').client

global.projectRoot = require('app-root-path').path
global.platform =
  switch process.platform
    when "darwin"
      "darwin"
    when "win32"
      "windows"
    when "linux"
      "linux"

replify = require('replify')
repl = require('http').createServer()
suffix = process.env.NODE_ENV
replify {name: "voicecode_#{suffix}"}, repl


global._ = require 'lodash'
require('../lib/utility/deepExtend')
global._s = require 'underscore.string' # ?
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
  menubar.showWindow()
  unless developmentMode
    menubar.hideWindow()

menubar.on 'after-create-window', ->
  window = menubar.window
  windowController.set 'main', window
  window.on 'blur', ->
    unless developmentMode or window.isSticky
      window.hide()
  Events.on 'toggleStickyWindow', ({id, shouldStick}) ->
    if id is 'main'
      window.isSticky = shouldStick
  # window.webContents.executeJavaScript 'require("coffee-script/register")'
  # window.webContents.executeJavaScript 'require("node-cjsx").transform()'
  window.on 'closed', -> debug 'window closed, what to do?'
  if developmentMode
    window.on 'reload', ->
      Events.frontendClearSubscriptions()
    window.openDevTools()
    electronConnect = electronConnect.create window

app.on 'ready', ->
  # emit 'appReady'#, app


process.on 'uncaughtException', (err) ->
  error 'UNCAUGHT EXCEPTION', err.stack, err.message

Events.once 'applicationShouldStart', ->
  funk = asyncblock.nostack
  if developmentMode
    funk = asyncblock
  funk (startupFlow) ->
    startupFlow.firstArgIsError = false
    global.Settings = {extend: (k, v) -> _.deepExtend Settings, {"#{k}": v}}
    _.deepExtend Settings, require "../lib/platforms/#{platform}/settings"
    Settings.userAssetsPath = '~/voicecode'
    if developmentMode
      Settings.userAssetsPath = '~/voicecode_development'
    global.Packages = require '../lib/packages/packages'
    # A package for platform specific global commands
    Packages.register
      name: global.platform
      description: "#{_.startCase global.platform} "

    global.Commands = require '../lib/commands'
    global.Scope = require '../lib/scope'

    global.AssetsController = require './assets_controller'
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
        global.VocabularyController = require("#{_path}/dragon/dragon_vocabulary_controller")
      when "windows"
        global.Actions = require '../lib/platforms/windows/actions'
      when "linux"
        global.Actions = require '../lib/platforms/linux/actions'

    # requireDirectory module, '../packages/',
    #   exclude: (path) ->
    #     not /.*package\.js$/.test path
    #   visit: (required) ->
    #     if (not _.isEmpty required) and _.isObject required
    #       _.each required, (value, key) -> global[key] = value

    Events.once 'packageAssetsLoaded', startupFlow.add 'packageAssetsLoaded'
    AssetsController.getAssets 'package', 'packages/**/package.coffee'
    startupFlow.wait 'packageAssetsLoaded'

    Events.once 'settingsAssetsLoaded', startupFlow.add 'settingsAssetsLoaded'
    AssetsController.getAssets 'settings', 'settings.coffee'
    startupFlow.wait 'settingsAssetsLoaded'

    Events.once 'userAssetsLoaded', startupFlow.add 'userAssetsLoaded'
    AssetsController.getAssets 'user', '**/*.coffee', (path) ->
      return true if /packages/.test path
      return true if /settings\.coffee/.test path
      return true if /generated/.test path
      return false
    startupFlow.wait 'userAssetsLoaded'

    require './enabled_commands_manager'

    if Settings.slaveMode or developmentMode
      Commands.enableAll()

    switch platform
      when "darwin"
        _path = "../lib/platforms/darwin/dragon"
        global.DragonController = require "#{_path}/dragon_controller"
        VocabularyController.start()
      # when "win32"
      # when "linux"

    if developmentMode
      Settings.slaveMode = true

    unless Settings.slaveMode
      global.Synchronizer = require './synchronize'
      Synchronizer.synchronize()

    emit "startupComplete"

# needed while developing ui
Events.once 'startupComplete', -> global.startedUp = true

# benchmarking
if developmentMode
  Events.on 'chainDidExecute', ->
    console.timeEnd 'CHAIN'
  Events.on 'chainWillExecute', ->
    console.time 'CHAIN'
