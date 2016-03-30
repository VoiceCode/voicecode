BrowserWindow = require 'browser-window'
module.exports = new class WindowController
  constructor: ->
    @windows = {}

  new: (id, params) ->
    @windows[id] = new BrowserWindow params
    @windows[id]

  get: (id) ->
    @windows[id] or null

  set: (id, window) ->
    @windows[id] = window
