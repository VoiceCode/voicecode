BrowserWindow = require 'browser-window'
module.exports = new class WindowController
  constructor: ->
    @windows = {}
    Events.on 'windowCreated', ({id, window}) ->
      window.webContents.executeJavaScript "window.developmentMode = #{!!developmentMode}"
  new: (id, params) ->
    window = @set id, new BrowserWindow params


  get: (id) ->
    @windows[id] or null

  set: (id, window) ->
    @windows[id] = window
    window.on 'focus', ->
      if Actions?.setCurrentApplication?
        Actions.setCurrentApplication
          bundleId: global.bundleId
          currentWindow: id
    emit 'windowCreated', {id, window}
    window.webContents.executeJavaScript "window.init == null || window.init()"
    window
