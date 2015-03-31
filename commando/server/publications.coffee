Meteor.publish "history", (limit) ->
  PreviousCommands.find({}, {sort: {createdAt: -1}, limit: 100})

Meteor.publish "commandStatuses", (limit) ->
  CommandStatuses.find()
