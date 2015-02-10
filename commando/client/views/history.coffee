Template.History.helpers
	previousCommands: ->
		PreviousCommands.find({}, {sort: {createdAt: -1}})

Template.previousCommandRow.helpers
	time: ->
		RelativeTime.from @createdAt
	name: ->
		JSON.stringify @interpretation