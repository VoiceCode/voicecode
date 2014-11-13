Template.Commands.helpers
  numberCaptureCommands: ->
    Commands.Utility.numberCaptureCommands()
  textCaptureCommand: ->
    Commands.Utility.textCaptureCommand()
  individualCommands: ->
    Commands.Utility.individualCommands()
  oneArgumentCommands: ->
    Commands.Utility.oneArgumentCommands()

Template.CommandSummaryRow.helpers
  isAction: ->
    Commands.mapping[@].kind is "action"
  isText: ->
    Commands.mapping[@].kind is "text"
  isModifier: ->
    Commands.mapping[@].kind is "modifier"
  kind: ->
    Commands.mapping[@].kind
  actions: ->
    Commands.mapping[@].actions
  transform: ->
    Commands.mapping[@].transform
  description: ->
    Commands.mapping[@].description
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
    