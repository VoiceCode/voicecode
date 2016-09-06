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


global.bundleId = 'io.voicecode.app'
global.app = require 'app'
global.Fiber = require 'fibers'
global.asyncblock = require 'asyncblock'
global.Reflect = require 'harmony-reflect'
settings =
  userAssetsPath: '~/voicecode'
  license: ''
  email: ''
global.Settings = Object.create new Proxy settings,
  get: (target, property, receiver) ->
    if pack = Packages.get property
      pack.settings()
    else
      Reflect.get target, property, receiver
  set: (target, property, value, receiver) ->
    if target[property]?
      Reflect.set target, property, value, receiver
    else if Packages? and p = Packages.get property
      p.settings value
    else
      Events.once "#{property}PackageReady", ({pack})->
        pack.settings value

global._s = require 'underscore.string' # ?
global._ = require 'lodash'
require('../lib/utility/deepExtend')
global.path = require 'path'
global.$ = require 'nodobjc'
global.Events = require './event_emitter'
global.PackagesManager = require './packages_manager'
global.requireDirectory = require 'require-directory'
global.numberToWords = require '../lib/utility/numberToWords'
global.SelectionTransformer = require '../lib/utility/selectionTransformer'
global.Transforms = require '../lib/utility/transforms'
global.windowController = require './window_controller'
menubarOptions =
  index: "file://#{projectRoot}/frontend/main.html"
  icon: "#{projectRoot}/assets/vc_tray.png"
  width: 800
  height: 1020
  # x: 0
  # y: 0
  windowPosition: 'trayRight'
  alwaysOnTop: true
  'always-on-top': true
  showDockIcon: false

global.menubar = require('menubar') menubarOptions

unless developmentMode
  _.each process.mainModule.paths, (path) ->
    require('module').globalPaths.push path

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
    electronConnect = electronConnect.create window
    window.openDevTools()

app.on 'ready', ->
  # emit 'appReady'#, app


process.on 'uncaughtException', (err) ->
  error 'UNCAUGHT EXCEPTION', err.stack, err.message

Events.once 'applicationShouldStart', ->
  platformLib = path.join '../lib', 'platforms', platform
  funk = asyncblock.nostack
  if developmentMode
    funk = asyncblock
  funk (startupFlow) ->
    startupFlow.firstArgIsError = false
    _.extend global, require './shell' # Execute, Applescript
    if developmentMode
      Settings.userAssetsPath = '~/voicecode_development'
    global.Packages = require '../lib/packages/packages'
    # A package for platform specific global commands
    Packages.register
      name: global.platform
      description: "#{_.startCase global.platform}"

    global.Commands = require '../lib/commands'
    global.Scope = require '../lib/scope'
    global.Actions = require "#{platformLib}/actions"
    Events.once 'assetsControllerReady', startupFlow.add 'assetsControllerReady'
    global.AssetsController = require './assets_controller'
    startupFlow.wait 'assetsControllerReady'
    global.Command = require '../lib/command'
    global.grammarContext = require '../lib/parser/grammarContext'
    global.GrammarState = require '../lib/parser/grammar_state'
    global.Grammar = require '../lib/parser/grammar'
    global.Chain = require '../lib/chain'
    global.HistoryController = require '../lib/history_controller'
    Commands.Utility = require '../lib/utility/utility'
    global.SlaveController = require './slave_controller'
    global.ParserController = require '../lib/parser/parser_controller'
    global.VocabularyController = require "#{platformLib}/dragon/dragon_vocabulary_controller"

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

    global.EnabledCommandsManager = require './enabled_commands_manager'

    if Settings.core.slaveMode or developmentMode
      Commands.enableAll()


    if developmentMode
      Settings.core.slaveMode = true

    global.MainController = require "#{platformLib}/main_controller"

    unless Settings.core.slaveMode
      global.SystemInfo = require "#{platformLib}/system_info"
      VocabularyController.start()
      global.Synchronizer = require './synchronize'
      Synchronizer.synchronize()

    emit "startupComplete"

# benchmarking
if developmentMode
  Events.on 'chainDidExecute', ->
    console.timeEnd 'CHAIN'
  Events.on 'chainWillExecute', ->
    console.time 'CHAIN'


# auto update
unless developmentMode
  autoUpdater = require 'auto-updater'
  version = app.getVersion()
  _platform = if platform is 'darwin' then 'osx' else 'win'
  autoUpdater.setFeedURL "http://updates.voicecode.io:31337/update/#{_platform}/#{version}"
  global.checkForUpdates = do ->
    lastCheck = Date.now()
    ->
      # if last checked more than 24 hours ago
      if Date.now() - lastCheck >= 86400
        log 'checkingForUpdates'
        if autoUpdater.checkForUpdates()
          autoUpdater.quitAndInstall()
        lastCheck = Date.now()

  checkForUpdates()
  setInterval checkForUpdates, 86400
