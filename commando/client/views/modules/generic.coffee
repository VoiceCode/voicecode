Template.moduleGeneric.helpers
	title: ->
		Session.get("commandModule.current")
	items: ->
		if Session.get("commandModule.current")?
			_.map Commands.Utility.scopedModules(Session.get("commandModule.current")), (item) ->
				record: Enables.findOne(name: item)
				name: item

Template.moduleItem.helpers
	enabled: ->
		if @record?.enabled
			"checked"

Template.moduleItem.events
	"change input": (e, t) ->
		if e.target.checked
			Meteor.call "enableCommand", @name
		else
			Meteor.call "disableCommand", @name