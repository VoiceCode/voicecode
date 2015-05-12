Template.Updates.events
  "click #run": ->
    Meteor.call "getAllCommandStatuses", (error, result) ->
      if error
        alert(error.message)
  "click #runScope": ->
    Meteor.call "getCommandStatuses", @context, (error, result) ->
      if error
        alert(error.message)
  "click #updateAll": ->
    Meteor.call "updateAllCommandStatuses", @context, (error, result) ->
      if error
        alert(error.message)
  "click #createAll": ->
    Meteor.call "createAllCommandStatuses", @context, (error, result) ->
      if error
        alert(error.message)
  "click #deleteAll": ->
    Meteor.call "deleteAllCommandStatuses", @context, (error, result) ->
      if error
        alert(error.message)
      
Template.Updates.helpers
  dragonContexts: ->
    _.map Settings.dragonContexts, (item) ->
      context: item
      _id: item
  added: ->
    CommandStatuses.find({status: "missing", scope: @context})
  removed: ->
    CommandStatuses.find({status: "removed", scope: @context})
  dirty: ->
    CommandStatuses.find({status: "dirty", scope: @context})

Template.commandNeedsUpdate.events
  "click #performAction": ->
    Meteor.call("performActionForCommandStatus", @_id)

Template.commandNeedsUpdate.helpers
  actionText: ->
    switch @status
      when "missing"
        "create"
      when "removed"
        "delete"
      when "dirty"
        "update"


