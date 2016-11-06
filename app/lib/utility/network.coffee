isOnline = require 'is-online'

class Network
  instance = null
  constructor: ->
    return instance if instance?
    @online = false
    Events.once 'startupComplete', =>
      @interval = setInterval @check.bind(@), 300000 # 5 minutes
      Events.on 'shouldCheckNetworkStatus', @check.bind(@)

  check: ->
    isOnline @updateStatus.bind @
  updateStatus: (err, status = false) ->
    if err
      error 'networkStatusError', err
    @online = status
    emit 'networkStatus', @online
  checkSync: (callback) ->
    isOnline (err, status) ->
      @updateStatus err, status
      callback err, status

module.exports = new Network
