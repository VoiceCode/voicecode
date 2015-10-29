throttled = _.debounce (phrase) ->
  return if Session.equals("commandIsExecuting", true)
  console.log phrase
  Session.set "currentMobilePhrase", phrase

  if Session.get("immediateExecution")
    Session.set("commandIsExecuting", true)
    console.log "executing: #{phrase}"
    Meteor.call "execute", "#{phrase} "
    Session.set "currentMobilePhrase", ""
    $("#phrase").val("")
    Session.set("commandIsExecuting", false)
, 80

Template.Mobile.events
  'click #interpret': (event, template) ->
    phrase = template.find('#phrase').value
    # alert("boom")
    Meteor.call "execute", "#{phrase} "
  'input #phrase': (event, template) ->
    phrase = event.target.value
    if phrase?.length
      throttled(phrase.replace(/^\s+|\s+$/g,''))

  'change #immediate': (e, t) ->
    checked = $(e.target).prop("checked")
    Session.set("immediateExecution", checked)
    # chain = new Chain("#{phrase} ")
  'change #immediate': (event, template) ->
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
  immediateExecution: ->
    Session.get "immediateExecution"