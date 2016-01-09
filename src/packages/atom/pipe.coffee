return new class AtomPipe
  instance = null
  constructor: ->
    return instance if instance?
    @clients = []
    @activeClient = null
    Events.on 'atomRemoteCodeInjectorReady', @listen.bind @
  listen: ->
    @server = new require('ws').Server(port: 4717)
    @server.on 'connection', (socket) =>
      @clients.push socket
      @activeClient = socket
      socket.on 'message', (message) => @onMessage socket, message
      socket.on 'close', => @onClose socket
      emit 'atomConnected', {pipe: @, socket}

  onMessage: (socket, message) ->
    message = JSON.parse message
    switch message.type
      when 'heartbeat'
        return
      when 'window-event'
        {name, value} = message.body
        if name is 'focus' and value is true
          @activeClient = socket

    emit 'atomMessage', message

  onClose: (socket) ->
    emit 'atomDisconnected'#, {pipe: @, socket}
    _.remove @clients, socket

  send: (message) ->
    @activeClient?.send JSON.stringify message
