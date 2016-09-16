class SlaveController
  # singleton
  instance = null
  throttledLog = null
  constructor: ->
    return instance if instance?
    instance = @
    @connectedSlaves = {}
    @target = null
    Events.on 'slaveControllerTarget', @setTarget.bind(@)
    Events.on 'packageSettingsChanged'
    ,({pack, property, value, oldValue}) =>
      if pack.name is 'core' and property is 'slaves'
        _.each _.difference(_.keys(value), _.keys(oldValue))
        , @connect.bind(@)

  connect: (slaveId)->
    [host, port] = Settings.core.slaves[slaveId]
    @createSocket slaveId, host, port

  onConnect: (slaveSocket) ->
    notify 'slaveConnected', slaveSocket.name
    , "Connected to: #{slaveSocket.name}"
    slaveSocket.once 'close',
      notify 'slaveDisconnected', slaveSocket.name
      , "Connection closed: #{slaveSocket.name}"
    @connectedSlaves[slaveSocket.name] = slaveSocket

  createSocket: (name, host, port) ->
    slaveSocket = new require('net').Socket()
    slaveSocket.name = name
    slaveSocket.on 'error', (error) =>
      @onError slaveSocket, error
    slaveSocket.on 'close', =>
      @onClose(slaveSocket)
    slaveSocket.on 'connect', =>
      @onConnect(slaveSocket)
    slaveSocket.connect port, host

  process: (commandPhrase) ->
    commandPhrase = commandPhrase.toLowerCase()
    if commandPhrase.replace(/\s+/g, '') is Commands.mapping['core:slave-control'].spoken
      notify 'slaveModeToggle', null, 'Slave mode off'
      @clearTarget()
    else
      @sendToSlave commandPhrase
      log 'slaveModeExecutedRemote', commandPhrase,
      "Executing '#{commandPhrase}' on #{@target}"

  sendToSlave: (commandPhrase, target = @target) ->
    @connectedSlaves[target].write commandPhrase

  onError: (slaveSocket, _error) ->
    delete @connectedSlaves[slaveSocket.name]
    @clearTarget()
    unless _error.code is 'ECONNREFUSED'
      error 'slaveError', {slave: slaveSocket.name, error: _error},
      "#{slaveSocket.name} socket: #{_error.code}"

  onClose: (slaveSocket) ->
    delete @connectedSlaves[slaveSocket.name]
    @clearTarget()
    [host, port] = Settings.core.slaves[slaveSocket.name]
    setTimeout =>
      @createSocket slaveSocket.name, host, port
      slaveSocket.destroy()
    , Settings.core.slaveReconnectInterval

  isActive: ->
    @target?

  setTarget: (name = null) ->
    return @clearTarget() if _.isEmpty name
    return if _.isEmpty Settings.core.slaves
    @target = Actions.fuzzyMatchKey Settings.core.slaves, name
    notify 'slaveModeToggle', @target, "Slave mode on: #{@target}"

  clearTarget: ->
    @target = null

module.exports = new SlaveController
