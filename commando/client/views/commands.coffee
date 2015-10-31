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
    # displayActions.reset()
    # command = Commands.mapping[@]
    # input = switch command.grammarType
    #   when "custom"
    #     {}
    #   else
    #     null
    # command.action?.call(displayActions, input, {})
    # displayActions.result
    command = Commands.mapping[@]
    if command.action
      generated = window.js2coffee.build("var action = " + command.action.toString() + ";")
      result = generated.code
      result = result.replace(/[\s]*[\w]+ = undefined\n/g, "\n")
      result = result.replace(/_arg/g, "options")
      result = result.split("@['do']").join('@do')
      result = result.replace("if input != null then input.length else undefined", "input")
      result = result.replace(/\n[\s]return[\s]/g, "")
      result = result.replace(/return[\s]*/g, "").trim()
      result
    else
      ""
Template.CommandSummaryRow.onRendered (template) ->
  hljs.highlightBlock @find("pre")

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
  'super': "&#8984;"
  option: "&#8997;"
  control: "&#8963;"
  shift: "&#8679;"
  'return': "&#8617;"
  "\n": "&#8617;"
  slash: "/"
  period: "."
  comma: ","
  semicolon: ";"
  'delete': "&#9003;"
  forwarddelete: "&#8998;"
  space: "&#9251;"
  " ": "&#9251;"
  escape: "&#9099;"
  tab: "&#8677;"
  "\t": "&#8677;"
  equal: "="
  minus: "-"
  up: "&uarr;"
  down: "&darr;"
  left: "&larr;"
  right: "&rarr;"
  rightbracket: "]"
  leftbracket: "["
  backslash: "\\"
