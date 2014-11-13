Template.Utility.helpers
  dragonBaseCommand: ->
    name = Session.get("ChooseCommand.current") or "command"
    command = new Commands.Base(name, "")
    commandText = command.generateBaseCommand()
    if command.info.contextSensitive
      """
      on srhandler(vars)
        set dictatedText to (varText of vars)
        set encodedText to (do shell script "/usr/bin/python -c 'import sys, urllib; print urllib.quote(sys.argv[1],\\"\\")' " & quoted form of dictatedText)
        set space to "#{name}"
        set toExecute to "curl http://commando:5000/parse/" & space & "/" & encodedText
        do shell script toExecute
      end srhandler
      """
    else
      """
      on srhandler(vars)
        set dictatedText to (varText of vars)
        if dictatedText = "" then
        #{commandText}
        set toExecute to "curl http://commando:5000/parse/miss/#{name}"
        do shell script toExecute
        else
        set encodedText to (do shell script "/usr/bin/python -c 'import sys, urllib; print urllib.quote(sys.argv[1],\\"\\")' " & quoted form of dictatedText)
        set space to "#{name}"
        set toExecute to "curl http://commando:#{Meteor.settings.public.port}/parse/" & space & "/" & encodedText
        do shell script toExecute
        end if
      end srhandler
      """
  dragonBaseCommandName: ->
    command = Session.get("ChooseCommand.current") or "command"
    "#{command} /!Text!/"
  commandNames: ->
    _.sortBy _.keys(Commands.mapping), (item) ->
      item
  currentCommand: ->
    Session.get("ChooseCommand.current")

Template.Utility.events
  "click .selectable": (event, template) ->
    target = event.currentTarget
    if document.body.createTextRange
      range = document.body.createTextRange()
      range.moveToElementText target
      range.select()
    else if window.getSelection
      selection = window.getSelection()
      range = document.createRange()
      range.selectNodeContents target
      selection.removeAllRanges()
      selection.addRange range

Template.ChooseCommand.helpers
  currentClass: ->
    if Session.equals "ChooseCommand.current", @.toString()
      "current"

Template.ChooseCommand.events
  "click": (event, template) ->
    Session.set "ChooseCommand.current", @.toString()
