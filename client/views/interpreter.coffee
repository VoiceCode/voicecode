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
      Session.set "interpretation", JSON.stringify(result.interpretation)
      Session.set "generated", result.generated
    catch e
      console.log e
      Session.set "generated", null
      Session.set "interpretation", JSON.stringify(e)
      
    
