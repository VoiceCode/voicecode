Template.Modules.helpers
  modules: () ->
    Commands.Utility.allModules()
  showModifiers: ->
    Session.equals("commandModule.current", "modifiers")
    # switch current
    #   when "modifiers"
    #     "moduleModifiers"
    #   else
    #     if current?.length
    #       "moduleGeneric"
    #     else
    #       null

Template.commandModule.helpers
  currentClass: ->
    if Session.equals "commandModule.current", @.toString()
      "current"

Template.commandModule.events
  "click": (event, template) ->
    if Session.get("commandModule.current") is @.toString()
      Session.set "commandModule.current", null
      # Session.set "commands.inScope", _.keys(Commands.mapping)
    else
      Session.set "commandModule.current", @.toString()
      # Session.set "commands.inScope", Commands.Utility.scopedCommands(Session.get("commandTag.current"))
