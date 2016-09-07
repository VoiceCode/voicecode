class SlaveController
  # singleton
  instance = null
  throttledLog = null
  constructor: ->
    return instance if instance?
    instance = @
    @connectedSlaves = {}
    @target = null
    Events.once 'corePackageReady', @connect.bind(@)
    Events.on 'slaveControllerTarget', @setTarget.bind(@)
  connect: ->
    return if _.isEmpty Settings.core.slaves
    for name, uri of Settings.core.slaves
      [host, port] = uri
      @createSocket name, host, port

  onConnect: (slaveSocket) ->
    notify 'slaveConnected', slaveSocket.name
    , "Connected to: #{slaveSocket.name}"
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
    @clearTarget()
    unless _error.code is 'ECONNREFUSED'
      error 'slaveError', {slave: slaveSocket.name, error: _error},
      "#{slaveSocket.name} socket: #{_error.code}"

  onClose: (slaveSocket) ->
    unless throttledLog?
      throttledLog = _.debounce ->
        notify 'slaveDisconnected', slaveSocket.name
        , "Connection closed: #{slaveSocket.name}"
      , 3000, true
    throttledLog()
    @clearTarget()
    [host, port] = Settings.core.slaves[slaveSocket.name]
    reconnect = setTimeout =>
      @createSocket slaveSocket.name, host, port
      slaveSocket.destroy()
      clearTimeout reconnect
    , 1000

  isActive: ->
    @target?

  setTarget: (name = null) ->
    return @clearTarget() if _.isEmpty name
    return if _.isEmpty Settings.core.slaves
    @target = Actions.fuzzyMatchKey Settings.core.slaves, name
    notify 'slaveModeToggle', @target, "Slave mode on: #{@target}"

  clearTarget: ->
    notify 'slaveModeToggle', null, "Slave mode off"
    @target = null

module.exports = new SlaveController
