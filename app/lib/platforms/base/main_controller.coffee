net = require 'net'

module.exports = class MainController
	constructor: ->

	executeChain: (phrase, chain) ->
	  if chain?
	    emit 'commandsShouldExecute', chain
	  else
	    emit 'chainShouldExecute', phrase

	slaveDataHandler: (phrase) ->
	  phrase = phrase.toString()
	  log 'slaveCommandReceived', phrase, "Master said: #{phrase}"
	  if phrase[0] is '{'
	    try
	      chain = JSON.parse phrase
	    catch
	      return error 'slaveCommandError', phrase, 'Unable to parse JSON'
	  @executeChain phrase, chain

	listenAsSlave: ->
	  socketServer = net.createServer (socket) =>
	    notify 'masterConnected', null, "Master connected!"
	    socket.on 'error', (er) ->
	      error 'slaveSocketError', err
	    socket.on 'data', @slaveDataHandler.bind(@)
	    socket.on 'end', (socket) ->
	      notify 'masterDisconnected', null, "Master disconnected..."

	  socketServer.listen Settings.core.slaveModePort, ->
	    notify 'slaveListening', {port: Settings.core.slaveModePort},
	    "Awaiting connection from master on port #{Settings.core.slaveModePort}"

	deviceHandler: (data) ->
	  phrase = data.toString('utf8').replace("\n", "")
	  debug 'devicePhrase', phrase
	  @executeChain(phrase)
