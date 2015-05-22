Template.Interpreter.helpers
  interpretation: ->
    Session.get "interpretation"
  generated: ->
    Session.get "generated"

Template.Interpreter.events
  'click #interpret': (event, template) ->
    phrase = template.find('#phrase').value
    chain = new Commands.Chain("#{phrase} ")
    try
      result = chain.execute()
      interpretation = _.map result.interpretation, (item) ->
        "#{item.command}(#{item.arguments?.join(', ') or ''})"
      Session.set "interpretation", interpretation.join("\n")


      actions = new OSX.displayActions()
      display = _.map result.interpretation, (e) ->
        actions.reset()
        command = new Commands.Base(e.command, e.arguments)
        individual = command.generate()
        individual.call(actions)
        actions.result

      Session.set "generated", display.join("<br/>")
    catch e
      console.log e
      Session.set "generated", null
      Session.set "interpretation", JSON.stringify(e)
