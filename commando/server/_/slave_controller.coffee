class @SlaveController
  # singleton
  instance = null
  constructor: ->
    return instance if instance?
    instance = @
    @connectedSlaves = {}
    @target = null
    @debug = false

  connect: ->
    return if _.isEmpty Settings.slaves
    for name, uri of Settings.slaves
      [host, port] = uri
      slaveSocket = @createSocket name, host, port

  onConnect: (slaveSocket) ->
    console.log "Connected to: #{slaveSocket.name}"
    @connectedSlaves[slaveSocket.name] = slaveSocket

  createSocket: (name, host, port) ->
    slaveSocket = new net.Socket()
    slaveSocket.name = name
    slaveSocket.on 'error', (error) =>
      @onError slaveSocket, error
    slaveSocket.on 'close', () =>
      @onClose(slaveSocket)
    slaveSocket.on 'connect', () =>
      @onConnect(slaveSocket)
    slaveSocket.connect port, host

  process: (commandPhrase) ->
    commandPhrase = commandPhrase.toLowerCase()
    if commandPhrase.replace(/\s+/g, '') is 'slaver'
      console.log 'Slave mode: off'
      Notify 'Slave mode: off'
      @clearTarget()
      return false
    console.log "Executing '#{commandPhrase}' on #{@target}"
    @sendToSlave commandPhrase
    return true

  sendToSlave: (commandPhrase, target = @target) ->
    @connectedSlaves[target].write commandPhrase

  onError: (slaveSocket, error) ->
    @clearTarget()
    console.error "Error in #{slaveSocket.name} socket" if @debug
    console.error error if @debug

  onClose: (slaveSocket) ->
    console.log "Connection closed: #{slaveSocket.name}"
    @clearTarget()
    [host, port] = Settings.slaves[slaveSocket.name]
    reconnect = setTimeout =>
      @createSocket slaveSocket.name, host, port
      slaveSocket.destroy()
      clearTimeout reconnect
    , 1000

  isActive: ->
    @target?

  setTarget: (name) ->
    return if _.isEmpty Settings.slaves
    return if _.isEmpty name
    @target = Actions.fuzzyMatch _.object(_.keys(Settings.slaves), _.keys(Settings.slaves)), name
    console.log "Slave mode on: #{@target}"
    Notify "Slave mode on: #{@target}"

  clearTarget: ->
    @target = null

@SlaveController = SlaveController

unless Settings.slaveMode
  invokeWith = 'createDisabled'
  invokeWith = 'create' if not _.isEmpty Settings.slaves
  Commands[invokeWith] "slaver",
    grammarType: "textCapture"
    kind: "action"
    continuous: false
    description: "Sets slave target if a parameter is given, otherwise returns to master"
    tags: ['voicecode']
    action: (input) ->
      slaveController.setTarget input
