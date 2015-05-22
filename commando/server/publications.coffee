# Meteor.publish "history", (limit) ->
#   PreviousCommands.find({}, {sort: {createdAt: -1}, limit: 100})

Meteor.publish "commandStatuses", (limit) ->
  CommandStatuses.find()

Meteor.publish "enables", (limit) ->
  Enables.find()

Meteor.publish "parserCash", (limit) ->
  Cashes.find(key: "parseGenerator")
