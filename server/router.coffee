RESTstop.configure
  api_path: "parse"
  console.log @params

RESTstop.add "miss/:namespace", ->
  console.log @params
  # the space at the end is important! (For parsing, makes it simpler)
  phrase = "#{@params.namespace} "
  chain = new Commands.Chain(phrase)
  results = chain.execute(false)
  {}

RESTstop.add ":namespace/:body?", ->
  console.log @params
  # the space at the end is important! (For parsing, makes it simpler)
  phrase = "#{@params.namespace} #{@params.body || ""} "
  chain = new Commands.Chain(phrase)
  results = chain.execute(true)

  if Meteor.settings.showRecognition
    notice ="""osascript <<EOD
    display notification "#{phrase}"
    EOD
    """
    Shell.exec notice, async: true
    
  {}


