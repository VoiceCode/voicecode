Template.registerHelper "dirtyStatus", ->
  if Session.equals "commandsAreDirty", true
    "(!)"