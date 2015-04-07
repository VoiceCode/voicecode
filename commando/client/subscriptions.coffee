Meteor.subscribe "history"
Meteor.subscribe "commandStatuses"
enablesSubscription = Meteor.subscribe "enables"

Tracker.autorun (t) ->
	if enablesSubscription.ready()
		t.stop()
		Commands.loadConditionalModules()