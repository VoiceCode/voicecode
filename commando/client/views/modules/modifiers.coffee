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
  "change input": (e, t) ->
    if e.target.checked
      Meteor.call "enableCommand", @name
    else
      Meteor.call "disableCommand", @name
