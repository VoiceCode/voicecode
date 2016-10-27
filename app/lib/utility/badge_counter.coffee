class BadgeCounter
	instance = null
	constructor: ->
		return instance if instance?
		@badges = {}
	add: (name) ->
		@badges[name] = 1
		@propagate()
	remove: (name) ->
		delete @badges[name]
		@propagate()
	propagate: ->
		electron.app.setBadgeCount _.size(@badges)

module.exports = new BadgeCounter