Meteor.publish "history", (limit) ->
  PreviousCommands.find({}, {sort: {createdAt: -1}, limit: 100})
