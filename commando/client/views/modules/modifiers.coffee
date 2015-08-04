Template.moduleModifiers.helpers
  prefixes: ->
    _.map Settings.modifierPrefixes, (value, key) ->
      name: key
      modifiers: _.map(value.split(' '), (m) -> modifierCodes[m])
  suffixes: ->
    _.map modifiers.suffixes(), (value, key) ->
      name: key
      spoken: value
  combination: ->
    spoken = @spoken
    _.map Settings.modifierPrefixes, (value, key) ->
      name = [key, spoken].join ' '
      results =
        name: name
        enabled: Commands.mapping[name].enabled

Template.enabledModifier.helpers
  enabled: ->
    if @enabled
      "checked"

Template.enabledModifier.events
  "click .modifierLabel": (e, t) ->
    e.stopPropagation()
    e.preventDefault()
    name = @name
    command = Commands.mapping[name]
    if command.enabled
      Meteor.call "disableCommands", [name]
      t.$("input[type='checkbox']").prop('checked', false)
    else
      Meteor.call "enableCommands", [name]
      t.$("input[type='checkbox']").prop('checked', true)
