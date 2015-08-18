Template.Commands.helpers
  loading: ->
    Session.get("loading")
  showModifiers: ->
    Session.equals("commandTag.current", "modifiers")
  numberCaptureCommands: ->
    Commands.Utility.numberCaptureCommands()
  textCaptureCommand: ->
    Commands.Utility.textCaptureCommands()
  individualCommands: ->
    Commands.Utility.individualCommands()
  oneArgumentCommands: ->
    Commands.Utility.oneArgumentCommands()
  tags: ->
    toggle = Session.get("enabledDisabledToggle")
    _.sortBy Commands.Utility.allEnabledTags(toggle), (i) -> i.toLowerCase()
  enabledDisabledAll: ->
    ["enabled", "disabled", "all"]

Template.commandsGeneric.helpers
  scopedCommands: ->
    tag = Session.get("commandTag.current") or "all"
    toggle = Session.get("enabledDisabledToggle")
    Commands.Utility.scopedCommandsWithToggle(tag, toggle)

Template.commandsGeneric.events
  'click #toggleAll': (e, t) ->
    tag = Session.get("commandTag.current") or "all"
    toggle = Session.get("enabledDisabledToggle")
    commands = Commands.Utility.scopedCommandsWithToggle(tag, toggle)
    checked = $("input[type='checkbox']:checked").length
    unchecked = $("input[type='checkbox']").length - checked
    toChange = []
    if checked > unchecked
      # disable all
      for item in commands
        if Commands.mapping[item].enabled
          toChange.push item
      Meteor.call "disableCommands", toChange
      $("input[type='checkbox']").prop('checked', false)
    else
      # enable all
      for item in commands
        unless Commands.mapping[item].enabled
          toChange.push item
      Meteor.call "enableCommands", toChange
      $("input[type='checkbox']").prop('checked', true)


Template.Commands.created = ->
  unless Session.get("commandTag.current")?
    Session.set "commandTag.current", "all"
    Session.set "commands.inScope", _.keys(Commands.mapping)

  Mousetrap.bind "e n a b l e d", ->
    Session.set "enabledDisabledToggle", "enabled"
  Mousetrap.bind "d i s a b l e d", ->
    Session.set "enabledDisabledToggle", "disabled"
  Mousetrap.bind ["a l l", "command+a"], (e) ->
    e.preventDefault()
    Session.set "enabledDisabledToggle", "all"
    false

Template.CommandSummaryRow.helpers
  isAction: ->
    (Commands.mapping[@].kind or "action") is "action"
  isText: ->
    Commands.mapping[@].kind is "text"
  isModifier: ->
    Commands.mapping[@].kind is "modifier"
  name: ->
    Commands.mapping[@].triggerPhrase or @toString()
  kind: ->
    Commands.mapping[@].kind or "action"
  enabled: ->
    Commands.mapping[@].enabled
  actions: ->
    Commands.mapping[@].actions
  transform: ->
    Commands.mapping[@].transform
  description: ->
    Commands.mapping[@].description
  grammarType: ->
    type = Commands.mapping[@].grammarType or "individual"
    if type is "custom"
      Commands.mapping[@].rule
    else
      type
  modifierText: ->
    Commands.mapping[@].modifiers.join('+')
  tags: ->
    Commands.mapping[@].tags or []
  actionDescriptor: ->
    displayActions.reset()
    Commands.mapping[@].action?.call(displayActions)
    displayActions.result

Template.CommandSummaryRow.events
  "click .modifierLabel": (e, t) ->
    e.stopPropagation()
    e.preventDefault()
    name = @toString()
    command = Commands.mapping[name]
    if command.enabled
      Meteor.call "disableCommands", [name]
      Meteor.setTimeout ->
        t.$("input[type='checkbox']").prop('checked', false)
      , 20
    else
      Meteor.call "enableCommands", [name]
      Meteor.setTimeout ->
        t.$("input[type='checkbox']").prop('checked', true)
      , 20
      
Template.CommandAction.helpers
  text: ->
    switch @kind
      when "key"
        [makeModifierText(@modifiers), @key].join(' ')
      when "keystroke"
        [makeModifierText(@modifiers), @keystroke].join(' ')
      when "script"
        if @modifiers
          [makeModifierText(@modifiers), @key].join(' ')
        else
          @script.toString()
      when "block"
        @transform.toString()
      else
        null


Template.commandTag.events
  "click": (event, template) ->
    if Session.get("commandTag.current") is @toString()
      Session.set "commandTag.current", "all"
    else
      Session.set "commandTag.current", @toString()


Template.commandTag.helpers
  currentClass: ->
    if Session.equals "commandTag.current", @toString()
      "current"

Template.enabledDisabledToggle.helpers
  currentClass: ->
    toggle = Session.get "enabledDisabledToggle"
    if toggle is @toString() or (toggle is undefined and @toString() is "all")
      "current"

Template.enabledDisabledToggle.events
  "click": (event, template) ->
    Session.set "enabledDisabledToggle", @toString()

@modifierCodes =
  command: "&#8984;"
  option: "&#8997;"
  control: "&#8963;"
  shift: "&#8679;"
  Return: "&#8617;"
  "\n": "&#8617;"
  Slash: "/"
  Period: "."
  Comma: ","
  Semicolon: ";"
  Delete: "&#9003;"
  ForwardDelete: "&#8998;"
  Space: "&#9251;"
  " ": "&#9251;"
  Escape: "&#9099;"
  Tab: "&#8677;"
  "\t": "&#8677;"
  Equal: "="
  Minus: "-"
  Up: "&uarr;"
  Down: "&darr;"
  Left: "&larr;"
  Right: "&rarr;"
  RightBracket: "]"
  LeftBracket: "["
  Backslash: "\\"
