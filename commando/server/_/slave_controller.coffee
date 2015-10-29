class @SlaveController
  # singleton
  instance = null
  throttledLog = null
  constructor: ->
    return instance if instance?
    instance = @
    @connectedSlaves = {}
    @target = null

  connect: ->
    return if _.isEmpty Settings.slaves
    for name, uri of Settings.slaves
      [host, port] = uri
      @createSocket name, host, port

  onConnect: (slaveSocket) ->
    notify 'slaveConnected', slaveSocket.name, "Connected to: #{slaveSocket.name}"
    @connectedSlaves[slaveSocket.name] = slaveSocket

  createSocket: (name, host, port) ->
    slaveSocket = new net.Socket()
    slaveSocket.name = name
    slaveSocket.on 'error', Meteor.bindEnvironment (error) =>
      @onError slaveSocket, error
    slaveSocket.on 'close', Meteor.bindEnvironment =>
      @onClose(slaveSocket)
    slaveSocket.on 'connect', Meteor.bindEnvironment =>
      @onConnect(slaveSocket)
    slaveSocket.connect port, host

  process: (commandPhrase) ->
    commandPhrase = commandPhrase.toLowerCase()
    if commandPhrase.replace(/\s+/g, '') is 'slaver'
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
      error 'slaveControllerError', {slave: slaveSocket.name, error: _error},
      "#{slaveSocket.name} socket: #{_error.code}"

  onClose: (slaveSocket) ->
    unless throttledLog?
      throttledLog = _.debounce ->
        notify 'slaveControllerDisconnected', slaveSocket.name, "Connection closed: #{slaveSocket.name}"
      , 1100, true
    throttledLog()
    @clearTarget()
    [host, port] = Settings.slaves[slaveSocket.name]
    reconnect = Meteor.setTimeout =>
      @createSocket slaveSocket.name, host, port
      slaveSocket.destroy()
      Meteor.clearTimeout reconnect
    , 1000

  isActive: ->
    @target?

  setTarget: (name) ->
    return if _.isEmpty Settings.slaves
    return if _.isEmpty name
    @target = Actions.fuzzyMatchKey Settings.slaves, name
    notify 'slaveModeToggle', @target, "Slave mode on: #{@target}"

  clearTarget: ->
    @target = null

@SlaveController = SlaveController

unless Settings.slaveMode
  invokeWith = if _.isEmpty Settings.slaves
    'createDisabled'
  else
    'create'

  Commands[invokeWith] "slaver",
    grammarType: "textCapture"
    kind: "action"
    continuous: false
    description: "Sets slave target if a parameter is given, otherwise returns to master"
    tags: ['voicecode']
    action: (input) ->
      slaveController.setTarget input
