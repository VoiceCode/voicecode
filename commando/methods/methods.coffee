Meteor.methods
	performActionForCommandStatus: (id) ->
		s = CommandStatuses.findOne id
		if s
			if @isSimulation
				CommandStatuses.remove s._id
			else
				s.performReconciliation()
			
		