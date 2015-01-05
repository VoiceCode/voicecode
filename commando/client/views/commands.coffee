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
    Commands.Utility.allTags()
  scopedCommands: ->
    Session.get("commands.inScope")


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

Template.CommandAction.helpers
  text: ->
    switch @kind
      when "key"
        [@modifiers?.join('+'), @key].join(' ')
      when "keystroke"
        [@modifiers?.join('+'), @keystroke.replace(/\s/g, "space")].join(' ')
      when "script"
        @script.toString()
      when "block"
        @transform.toString()
      else
        null


Template.commandTag.events
  "click": (event, template) ->
    Session.set "commandTag.current", @.toString()
    Session.set "commands.inScope", Commands.Utility.scopedCommands(Session.get("commandTag.current"))


Template.commandTag.helpers
  currentClass: ->
    if Session.equals "commandTag.current", @.toString()
      "current"
  