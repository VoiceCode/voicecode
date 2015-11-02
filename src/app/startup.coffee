global.projectRoot = require('app-root-path')
global.platform =
  switch process.platform
    when "darwin"
      "darwin"
    when "win32"
      "windows"
    when "linux"
      "linux"

global._ = require 'lodash'
application = require 'app'
BrowserWindow = require 'browser-window'
client = require('electron-connect').client

global.Command = require '../lib/command'
EventEmitter = require './event_emitter'
global.Events = new EventEmitter
global.emit = _.bind Events.emit, Events
global.error = _.bind Events.error, Events
global.log = _.bind Events.log, Events
global.warning = _.bind Events.warning, Events
global.notify = _.bind Events.notify, Events

global.ParseGenerator = {}
global.Command = require '../lib/command'
global.Grammar = require '../lib/parser/grammar'
global.Settings = require './settings'
global.Commands = require '../lib/commands'
Commands.Utility = require '../lib/execution/commands/utility'
global.userAssetsController = require './user_assets_controller'
_.extend global, require './settings_manager'
global.enabledCommandsManager = new EnabledCommandsManager
global.Alphabet = require '../lib/execution/map/text/alphabet'
global.Modifiers = require '../lib/execution/map/basic/modifiers'
_.each enabledCommandsManager.settings, (enabled, name) ->
  if enabled
    Commands.enable name
  else
    Commands.disable name
enabledCommandsManager.subscribeToEvents()
userAssetsController.runUserCode()
Settings.slaveMode = true
Settings.dontMessWithMyDragon = true
switch platform
  when "darwin"
    global.$ = require('nodobjc')
    global.$ = {}
    global.Actions = require '../lib/platforms/darwin/actions'
    global.darwinController = require '../lib/platforms/darwin/darwin_controller'
    unless Settings.slaveMode
      global.dragonController = require '../lib/platforms/darwin/dragon/dragon_controller'
  when "win32"
    global.Actions = require '../lib/platforms/windows/actions'
  when "linux"
    global.Actions = require '../lib/platforms/linux/actions'

Commands.initialize()

mainWindow = null
application.on 'ready', ->
  # mainWindow = new BrowserWindow
  #   width: 900
  #   height: 600
  # mainWindow.loadUrl "file://#{projectRoot}/dist/frontend/main.html"
  # mainWindow.openDevTools()
  # mainWindow.on 'closed', ->
  #   mainWindow = null
  #
  # client = client.create mainWindow




fingerprint =
  data:
    license: 'x7xs3h7RVc3fBPNQmUD8nBZbs2GN9Q'
    email: 'dimatter@gmail.com'
    grammar: Grammar.build()
