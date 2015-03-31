Template.Commands.helpers
  numberCaptureCommands: ->
    Commands.Utility.numberCaptureCommands()
  textCaptureCommand: ->
    Commands.Utility.textCaptureCommands()
  individualCommands: ->
    Commands.Utility.individualCommands()
  oneArgumentCommands: ->
    Commands.Utility.oneArgumentCommands()
  letterCommands: ->
    Commands.Utility.letterCommands()
  numberCommands: ->
    Commands.Utility.numberCommands()
  tags: ->
    _.sortBy Commands.Utility.allTags(), (i) -> i.toLowerCase()
  scopedCommands: ->
    Session.get("commands.inScope")

Template.Commands.created = ->
  unless Session.get("commandTag.current")?
    Session.set "commandTag.current", "all"
    Session.set "commands.inScope", _.keys(Commands.mapping)


Template.CommandSummaryRow.helpers
  isAction: ->
    Commands.mapping[@].kind is "action"
  isText: ->
    Commands.mapping[@].kind is "text"
  isModifier: ->
    Commands.mapping[@].kind is "modifier"
  name: ->
    Commands.mapping[@].triggerPhrase or @.toString()
  kind: ->
    Commands.mapping[@].kind
  actions: ->
    Commands.mapping[@].actions
  transform: ->
    Commands.mapping[@].transform
  description: ->
    Commands.mapping[@].description
  grammarType: ->
    Commands.mapping[@].grammarType
  modifierText: ->
    Commands.mapping[@].modifiers.join('+')
  tags: ->
    Commands.mapping[@].tags or []

makeKeyText = (string) ->
  string.
    replace(/\s/g, "<span class='symbol'>&#9251;</span>").replace(/command/g, "<span class='symbol'>&#8984;</span>")

modifierCodes =
  command: "&#8984;"
  option: "&#8997;"
  control: "&#8963;"
  shift: "&#8679;"

makeModifierText = (modifiers) ->
  result = _.map modifiers, (m) ->
    "<span class='symbol'>#{modifierCodes[m]}</span>"
  result.join ""

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
    if Session.get("commandTag.current") is @.toString()
      Session.set "commandTag.current", "all"
      Session.set "commands.inScope", _.keys(Commands.mapping)
    else
      Session.set "commandTag.current", @.toString()
      Session.set "commands.inScope", Commands.Utility.scopedCommands(Session.get("commandTag.current"))


Template.commandTag.helpers
  currentClass: ->
    if Session.equals "commandTag.current", @.toString()
      "current"
  