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

RESTstop.add "recall", ->
  console.log @params
  id = @params.query
  console.log id
  if id
    item = PreviousCommands.findOne(id)
    console.log item
    if item
      chain = new Commands.Chain(item.spoken + " ")
      results = chain.execute(true)
  {}

RESTstop.add "history", ->
  console.log @params
  items = PreviousCommands.find({}, {sort: {createdAt: -1}, limit: 50}).fetch()
  # console.log items
  itemString = _.map items, (item, index) -> 
    """
    <item uid="home" arg="#{item._id}" valid="YES">
      <title>#{item.spoken}</title>
      <icon>~/voicecode/assets/images/voicecode-alfred.png</icon>
      <text type="copy">#{item.spoken}</text>
    </item>
    """
  result = """
  <?xml version="1.0"?>
  <items>
  #{itemString.join("\n")}
  </items>
  """
  # console.log result
  result

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


