class Network
	instance = null
	constructor: ->
		return instance if instance?
		@online = true
		Events.on 'networkStatus', @updateStatus.bind(@)
	updateStatus: (status) ->
		@online = status

module.exports = new Network
