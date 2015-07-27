@Contexts ?= {}

class Contexts.Base
	initialize: ->
	execute: ->
		if Meteor.isServer
			@action()
		else
			@documentation()
	action: ->
	documentation: ->