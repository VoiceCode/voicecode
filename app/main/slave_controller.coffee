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
    @connectedSlaves[slaveSocket.name] = slaveSocket

    notify 'slaveConnected', slaveSocket.name
    , "Connected to: #{slaveSocket.name}"
    slaveSocket.once 'close', ->
      notify 'slaveDisconnected', slaveSocket.name
      , "Connection closed: #{slaveSocket.name}"

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

  process: (phrase, chain = null) ->
    if not phrase? and chain?
      remote = JSON.stringify chain
    else
      sleepSpoken = Commands.mapping['core:slave-control'].spoken
      remote = phrase.toLowerCase().replace(/\s{2,}/g, '')
      if remote.indexOf(sleepSpoken) isnt -1
        [remote, local] = remote.split sleepSpoken
        unless _.isEmpty remote
          Events.once 'slaveModeExecutedRemote', => @clearTarget()
        else
          @clearTarget()
        unless _.isEmpty local
          process.nextTick =>
            @clearTarget() if @isActive()
            emit 'chainShouldExecute', _.trim local
    @sendToSlave remote unless _.isEmpty remote

  sendToSlave: (commandPhrase, target = @target) ->
    @connectedSlaves[target].write commandPhrase
    log 'slaveModeExecutedRemote', commandPhrase,
      "Executing '#{commandPhrase}' on #{@target}"

  onError: (slaveSocket, _error) ->
    delete @connectedSlaves[slaveSocket.name]
    @clearTarget slaveSocket.name
    # unless _error.code in ['ECONNREFUSED', 'ETIMEDOUT']
    #   error 'slaveError', {slave: slaveSocket.name, error: _error},
    #   "#{slaveSocket.name} socket: #{_error.code}"

  onClose: (slaveSocket) ->
    delete @connectedSlaves[slaveSocket.name]
    @clearTarget slaveSocket.name
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
    target = Actions.fuzzyMatchKey Settings.core.slaves, name
    if @connectedSlaves[target]?
      @target = target
      notify 'slaveModeToggle', @target, "Slave mode on: #{@target}"
    else
      notify 'slaveModeToggleFailed', target, "Slave mode failed: #{target}"

  clearTarget: (target) ->
    return if target? and @target isnt target
    notify 'slaveModeToggle', null, 'Slave mode: off'
    @target = null

module.exports = new SlaveController
