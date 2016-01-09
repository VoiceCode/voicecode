coffeeScript = require 'coffee-script'
chokidar = require 'chokidar'
asyncblock = require 'asyncblock'
fs = require 'fs'

return new class AtomRemoteCodeInjector
  instance = null
  constructor: ->
    return instance if instance?
    @remoteCode = ''
    Events.on 'atomConnected', @onConnected.bind @
    Events.once 'atomRemoteCodeFileEvent', (event) =>
      emit 'atomRemoteCodeInjectorReady'
      Events.on 'atomRemoteCodeFileEvent', (event) =>
        @reinject()
    @watch()

  reinject: ->
    @pipe.send
      type: 'injection'
      body:
        code: @remoteCode
    #
    # _.all @pipe.clients, (client) =>
    #   client.send
    #     type: 'injection'
    #     parameters:
    #       code: @remoteCode

  onConnected: ({@pipe}) ->
    @pipe.send
      type: 'injection'
      body:
        code: @remoteCode

  watch: ->
    @watcher = chokidar.watch "#{__dirname}/remote_methods.coffee",
      persistent: true
    @watcher.on('add', (path) =>
      @handleFile 'added', path
    ).on('change', (path) =>
      @handleFile 'changed', path
    ).on('error', (err) ->
      error 'atomRemoteCodeFileError', err, err
    ).on 'ready', ->


  compileCoffeeScript: (data) ->
    coffeeScript.compile data

  handleFile: (event, fileName) ->
    remoteCode = fs.readFileSync fileName, {encoding: 'utf8'}
    try
      remoteCode = @compileCoffeeScript remoteCode
      @remoteCode = remoteCode
    catch err
      warning 'atomRemoteCodeEvaluationError',
      {err, fileName}, "#{fileName}:\n#{err}"
    emit 'atomRemoteCodeFileEvent', event
