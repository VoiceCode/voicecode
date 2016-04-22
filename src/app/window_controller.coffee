BrowserWindow = require 'browser-window'
module.exports = new class WindowController
  constructor: ->
    @windows = {}
    Events.on 'windowCreated', (window) ->
      window.webContents.executeJavaScript "window.developmentMode = #{!!developmentMode}"


  new: (id, params) ->
    window = @set id, new BrowserWindow params


  get: (id) ->
    @windows[id] or null

  set: (id, window) ->
    @windows[id] = window
    emit 'windowCreated', window
    window.webContents.executeJavaScript "window.init == null || window.init()"
    window
