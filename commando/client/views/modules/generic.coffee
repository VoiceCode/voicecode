Template.moduleGeneric.helpers
	title: ->
		Session.get("commandModule.current")
	items: ->
		Commands.Utility.scopedModules(Session.get("commandModule.current"))