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
  "click #updateAllGlobal": ->
    Meteor.call "updateAllCommandStatuses", "Global", (error, result) ->
      if error
        alert(error.message)
  "click #createAllGlobal": ->
    Meteor.call "createAllCommandStatuses", "Global", (error, result) ->
      if error
        alert(error.message)
      
Template.Updates.helpers
  addedGlobal: ->
    CommandStatuses.find({status: "missing", scope: "Global"})
  addedTerm: ->
    CommandStatuses.find({status: "missing", scope: "iTerm"})
  removedGlobal: ->
    CommandStatuses.find({status: "removed", scope: "Global"})
  removedTerm: ->
    CommandStatuses.find({status: "removed", scope: "iTerm"})
  dirtyGlobal: ->
    CommandStatuses.find({status: "dirty", scope: "Global"})
  dirtyTerm: ->
    CommandStatuses.find({status: "dirty", scope: "iTerm"})

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


