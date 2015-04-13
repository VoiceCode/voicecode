Template.Utility.helpers
  dragonBaseCommand: ->
    name = Session.get("ChooseCommand.current") or "command"
    command = new Commands.Base(name, "")
    command.generateDragonBody()
  dragonBaseCommandName: ->
    name = Session.get("ChooseCommand.current") or "command"
    command = new Commands.Base(name, "")
    command.generateDragonCommandName()
  commandNames: ->
    if enablesSubscription.ready()
      names = Commands.Utility.enabledCommandNames()
      _.sortBy names, (item) ->
        item
    else
      []
  currentCommand: ->
    Session.get("ChooseCommand.current")

Template.Utility.events
  "click .selectable": (event, template) ->
    target = event.currentTarget
    if document.body.createTextRange
      range = document.body.createTextRange()
      range.moveToElementText target
      range.select()
    else if window.getSelection
      selection = window.getSelection()
      range = document.createRange()
      range.selectNodeContents target
      selection.removeAllRanges()
      selection.addRange range
  "click .runScript": (event, template) ->
    name = Session.get("ChooseCommand.current")
    if name?.length
      Meteor.call("makeDragonCommand", name)
  "click #updateDragonCommand": (event, template) ->
    name = Session.get("ChooseCommand.current")
    if name?.length
      Meteor.call("updateDragonCommand", name)
  "click #findDragonCommand": (event, template) ->
    name = Session.get("ChooseCommand.current")
    if name?.length
      Meteor.call("findDragonCommand", name)
  "click #find": (e, t) ->
    value = $("#commandSearch").val()?.toLowerCase()
    console.log value
    Session.set "ChooseCommand.current", value


Template.ChooseCommand.helpers
  currentClass: ->
    if Session.equals "ChooseCommand.current", @.toString()
      "current"

Template.ChooseCommand.events
  "click": (event, template) ->
    Session.set "ChooseCommand.current", @.toString()
