Application = require 'app'
BrowserWindow = require 'browser-window'
Application.on 'ready', ->
  mainWindow = new BrowserWindow
    width: 900
    height: 600
