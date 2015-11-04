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
application = require 'app'
BrowserWindow = require 'browser-window'
client = require('electron-connect').client

global.Settings = require './settings'
global.Events = require './event_emitter'
global.emit = _.bind Events.emit, Events
global.error = _.bind Events.error, Events
global.log = _.bind Events.log, Events
global.warning = _.bind Events.warning, Events
global.notify = _.bind Events.notify, Events
global.Fiber = require 'fibers'
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
require '../lib/utility/deep_extension'
global.userAssetsController = require './user_assets_controller'
global.SlaveController = require './slave_controller'
_.extend global, require './shell' # Execute, Applescript
_.extend global, require './settings_manager' # EnabledCommandsManager, SettingsManager
global.enabledCommandsManager = new EnabledCommandsManager
global.alphabet = require '../lib/alphabet'
global.Modifiers = require '../lib/modifiers'
global.Homonyms = require '../lib/utility/homonyms'
global.ParserController = require '../lib/parser/parser_controller'
Commands.initializationState = 'loadingFromSettings'
_.each enabledCommandsManager.settings, (enabled, name) ->
  if enabled
    Commands.enable name
  else
    Commands.disable name
Commands.initialize() # why do we even have this?
enabledCommandsManager.subscribeToEvents()
Commands.initializationState = 'loadingUserCode'
userAssetsController.runUserCode()
Commands.initializationState = 'loaded'


# DEVELOPER MODE ONLY
# Settings.slaveMode = true
Settings.dontMessWithMyDragon = true

switch platform
  when "darwin"
    global.$ = require('nodobjc')
    global.Actions = require '../lib/platforms/darwin/actions'
    global.darwinController = require '../lib/platforms/darwin/darwin_controller'
    unless Settings.slaveMode
      global.dragonController = require '../lib/platforms/darwin/dragon/dragon_controller'
  when "win32"
    global.Actions = require '../lib/platforms/windows/actions'
  when "linux"
    global.Actions = require '../lib/platforms/linux/actions'


# if Settings.slaveMode
#   _.each Commands.mapping, (command, name) ->
#     Commands.enable name

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
