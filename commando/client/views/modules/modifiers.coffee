Template.moduleModifiers.helpers
	prefixes: ->
		_.map commandModifiers, (value, key) ->
			name: key
			modifiers: _.map(value, (m) -> modifierCodes[m])
	letters: ->
		_.map commandLetters, (value, key) ->
			name: modifierCodes[key] or key
			spoken: value
	prefixCombos: ->
		spoken = @spoken
		_.map commandModifiers, (value, key) ->
			name = [key, spoken].join ''

			name: name
			modifiers: _.map(value, (m) -> modifierCodes[m])
			record: Enables.findOne(name: name)

Template.enabledModifier.helpers
	enabled: ->
		if @record?.enabled
			"checked"

Template.enabledModifier.events
	"change input": (e, t) ->
		if e.target.checked
			Meteor.call "enableCommand", @name
		else
			Meteor.call "disableCommand", @name