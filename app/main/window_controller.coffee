{BrowserWindow} = require 'electron' unless headlessMode
module.exports = new class WindowController
  constructor: ->
    return @ if headlessMode
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

  getFocused: ->
    for name, window of @windows
      return window if window.isFocused()
