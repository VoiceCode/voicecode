# @Updates =
#   "v0.4.3":
#     added:
#       "creek": {}
#       "keeper": {}
#       "shell": {}
#       "wink": {}
#       "foo": {}
#       "trace": {}
#       "quarr": {}
#       "fypes": {}
#       "eleven": {}
#       "twelve": {}
#       "thirteen": {}
#       "fourteen": {}
#       "fifteen": {}
#       "sixteen": {}
#       "seventeen": {}
#       "eighteen": {}
#       "nineteen": {}
#       "word-error": {}
#       "comlick": {}
#       "durrup": {scope: "iTerm"}
#       "engage": {scope: "iTerm"}
#     changed:
#       "repple": {}
#     removed:
#       "voice code": {}
#       "engage": {static: true, scope: "iTerm"}
#       "parent dir": {static: true, scope: "iTerm"}

Template.Updates.events
  "click #run": ->
    Meteor.call "getAllCommandStatuses", (error, result) ->
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
    _.map CommandoSettings.dragonContexts, (item) ->
      context: item
      _id: item
  added: ->
    CommandStatuses.find({status: "missing", scope: @context})
  removed: ->
    CommandStatuses.find({status: "removed", scope: @context})
  dirtyGlobal: ->
    CommandStatuses.find({status: "dirty", scope: @context})

# Template.commandUpdateAdded.created = ->
#   Meteor.call "currentCommandStatus", @data.name, @data.scope

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


