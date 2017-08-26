# https://gist.github.com/dimatter/0206268704609de07119
Function::property = (prop, desc) ->
  Object.defineProperty @prototype, prop, desc

process.env.NODE_ENV = 'production' # needed for react

global.developmentMode = 'develop' in process.argv
global.headlessMode = process.argv0  == 'node'
if headlessMode
  process.nextTick () ->
    Events.on 'logger', console.log.bind(console)
unless headlessMode
  global.electron = require('electron')
  global.app  =  electron.app
  electron.powerSaveBlocker.start('prevent-app-suspension')
else
  global.app = {on: ->}

if developmentMode
  process.env.NODE_ENV = 'development'
  electronConnect = require('electron-connect').client

global.projectRoot = require('app-root-path').path
global.platform = switch process.platform
  when "darwin"
    "darwin"
  when "win32"
    "windows"
  when "linux"
    "linux"

replify = require('replify')
# repl = require('http').createServer()
suffix = process.env.NODE_ENV
# replify {name: "voicecode_#{suffix}"}, repl


global.bundleId = 'io.voicecode.app'
if developmentMode
  global.bundleId = 'com.github.electron'
global.appVersion = require('../package.json').version
global.Fiber = require 'fibers'
global.asyncblock = require 'asyncblock'
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

global._ = require 'lodash'
require('../lib/utility/deepExtend')
global.path = require 'path'
global.$ = require 'nodobjc'
global.Events = require './event_emitter'
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
  windowPosition: 'trayRight'
  alwaysOnTop: true
  'always-on-top': true
  showDockIcon: true

# if developmentMode
#   menubarOptions.icon = "#{projectRoot}/assets/vc_tray_develop.png"
#   menubarOptions.x = 0
#   menubarOptions.y = 0

# global.menubar = require('menubar') menubarOptions

_.each process.mainModule.paths, (path) ->
  require('module').globalPaths.push path

global.Network = require '../lib/utility/network'
global.BadgeCounter = require '../lib/utility/badge_counter'
unless headlessMode
  Config = require('electron-config')
  config = new Config()

  app.once 'ready', ->

    # TODO persist this to restore preferred window position
    mainWindowState = config.get 'mainWindowState'
    mainWindowState ?=
      width: 1200
      height: 800

    main = windowController.new 'main',
      width: mainWindowState.width
      height: mainWindowState.height
      x: mainWindowState.x
      y: mainWindowState.y
      # closable: false
      acceptFirstMouse: true
      titleBarStyle: 'hidden-inset'
      show: false
      center: true

    main.on 'close', ->
      config.set 'mainWindowState', main.getBounds()

    main.once 'show', ->
      require('./menu.coffee')

    main.once 'ready-to-show', ->
      setTimeout ->
        main.show()
        app.on 'activate', ->
          main.show()
      , 400
      # menubar.showWindow()
      # unless developmentMode
      #   menubar.hideWindow()

      Events.on 'toggleStickyWindow', ({id, shouldStick}) ->
        if id is 'main'
          if main.isAlwaysOnTop()
            main.setAlwaysOnTop false
          else
            main.setAlwaysOnTop true, 'floating'

      if developmentMode
        main.on 'reload', ->
          Events.frontendClearSubscriptions()
        electronConnect = electronConnect.create main
        main.openDevTools()

    main.loadURL("file://#{projectRoot}/frontend/main.html")

    Events.on 'printCurrentWindow', ->
      windowController.getFocused()?.webContents.print()

    # app.on 'activate', ->
    #   unless windowController.get('main').isVisible()
    #     menubar.showWindow()
    # Events.on 'currentApplicationChanged', (to) ->
    #   if to.bundleId is global.bundleId
    #     unless windowController.get('main').isVisible()
    #       menubar.showWindow()

# menubar.on 'after-create-window', ->
#   window = menubar.window
#   windowController.set 'main', window
#   window.on 'blur', ->
#     unless developmentMode or window.isSticky
#       menubar.hideWindow()
#   Events.on 'toggleStickyWindow', ({id, shouldStick}) ->
#     if id is 'main'
#       window.isSticky = shouldStick
#   # window.webContents.executeJavaScript 'require("coffee-script/register")'
#   # window.webContents.executeJavaScript 'require("node-cjsx").transform()'
#   if developmentMode
#     window.on 'reload', ->
#       Events.frontendClearSubscriptions()
#     electronConnect = electronConnect.create window
#     window.openDevTools()

# app.on 'ready', ->
  # emit 'appReady'#, app


# process.on 'uncaughtException', (err) ->
#   error 'UNCAUGHT EXCEPTION', err.stack, err.message


applicationShouldStart = ->
  platformLib = path.join '../lib', 'platforms', platform
  funk = asyncblock.nostack
  if developmentMode
    funk = asyncblock
  funk (startupFlow) ->
    startupFlow.firstArgIsError = false
    Events.once 'networkStatus', startupFlow.add 'networkStatus'
    Network.check()
    startupFlow.wait 'networkStatus'
    _.extend global, require './shell' # Execute, Applescript
    if developmentMode
      Settings.userAssetsPath = '~/voicecode_development'
    global.FileManager = require('./file_manager')
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

    Events.once 'packagesManagerReady', startupFlow.add 'packagesManagerReady'
    global.PackagesManager = require './packages_manager'
    startupFlow.wait 'packagesManagerReady'
    global.Command = require '../lib/command'
    global.grammarContext = require '../lib/parser/grammarContext'
    global.GrammarState = require '../lib/parser/grammar_state'
    global.Grammar = require '../lib/parser/grammar'
    global.Chain = require '../lib/chain'
    global.HistoryController = require '../lib/history_controller'
    Commands.Utility = require '../lib/utility/utility'
    global.SlaveController = require './slave_controller'
    global.ParserController = require '../lib/parser/parser_controller'
    if platform is 'darwin'# yuck
      global.VocabularyController = require "#{platformLib}/dragon/dragon_vocabulary_controller"
    Events.once 'packageAssetsLoaded', startupFlow.add 'packageAssetsLoaded'
    AssetsController.getAssets 'package', ['packages/*/package.coffee', 'packages/*/package.js']
    startupFlow.wait 'packageAssetsLoaded'

    Events.once 'settingsAssetsLoaded', startupFlow.add 'settingsAssetsLoaded'
    AssetsController.getAssets 'settings', 'settings.coffee'
    startupFlow.wait 'settingsAssetsLoaded'

    Events.once 'userAssetsLoaded', startupFlow.add 'userAssetsLoaded'
    AssetsController.getAssets 'user', ['**/*.coffee', '**/*.js'], (path) ->
      return true if /packages/.test path
      return true if /settings\.coffee/.test path
      return true if /generated/.test path
      return true if /node_modules/.test path
      return true if /package_settings/.test path
      return true if /misc\//.test path
      return false
    startupFlow.wait 'userAssetsLoaded'

    global.EnabledCommandsManager = require './enabled_commands_manager'

    if Settings.core.slaveMode or developmentMode or platform isnt 'darwin'
      Commands.enableAll()


    if developmentMode
      Settings.core.slaveMode = true
    global.MainController = require "#{platformLib}/main_controller"

    unless Settings.core.slaveMode
      global.SystemInfo = require "#{platformLib}/system_info"
      VocabularyController.start()
      # global.Synchronizer = require './synchronize'
      # Synchronizer.synchronize()

    global.startupComplete = true
    emit "startupComplete"


app.on 'window-all-closed', ->
  app.quit()

Events.on 'applicationShouldQuit', ->
  app.quit()

Events.on 'applicationShouldRestart', ->
  electron.app.relaunch()
  emit('applicationShouldQuit')


# benchmarking
if developmentMode
  Events.on 'chainDidExecute', ->
    console.timeEnd 'CHAIN'
  Events.on 'chainWillExecute', ->
    console.time 'CHAIN'


if headlessMode
  process.nextTick applicationShouldStart
else
  Events.once 'applicationShouldStart', applicationShouldStart
