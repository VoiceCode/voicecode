Template.Modules.helpers
  modules: () ->
    Commands.Utility.allModules()
  showModifiers: ->
    Session.equals("commandModule.current", "modifiers")

Template.commandModule.helpers
  currentClass: ->
    if Session.equals "commandModule.current", @.toString()
      "current"

Template.commandModule.events
  "click": (event, template) ->
    if Session.get("commandModule.current") is @.toString()
      Session.set "commandModule.current", null
    else
      Session.set "commandModule.current", @.toString()
