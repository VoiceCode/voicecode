Template.Mobile.events
  'click #interpret': (event, template) ->
    phrase = template.find('#phrase').value
    alert("boom")
    Meteor.call "execute", "#{phrase} "
  'input #phrase': (event, template) ->
    phrase = event.target.value
    console.log phrase
    Session.set "currentMobilePhrase", phrase
    # chain = new Commands.Chain("#{phrase} ")
    # try
    #   result = chain.execute()
    #   Session.set "interpretation", JSON.stringify(result.interpretation)
    #   Session.set "generated", result.generated
    # catch e
    #   console.log e
    #   Session.set "generated", null
    #   Session.set "interpretation", JSON.stringify(e)
      
    
Template.Mobile.helpers
  currentPhrase: ->
    Session.get "currentMobilePhrase"
  console.log 