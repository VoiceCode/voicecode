Router.configure
  layoutTemplate: 'Layout',
  loadingTemplate: 'Loading'

Router.route '/', ->
  this.render 'Home'
Router.route '/grammar', ->
  this.render 'Grammar'
Router.route '/interpreter', ->
  this.render 'Interpreter'
Router.route '/commands', ->
  this.render 'Commands'
Router.route '/utility', ->
  this.render 'Utility'
Router.route '/vocab', ->
  this.render 'Vocab'
Router.route '/history', ->
  this.render 'History'
Router.route '/mobile', ->
  this.render 'Mobile'
Router.route '/updates', ->
  this.render 'Updates'
Router.route '/modules', ->
  this.render 'Modules'

Router.route '/miss', ->
  body = @request.body
  console.log body
  phrase = "#{body.space} "
  chain = new Commands.Chain(phrase)
  results = chain.execute(false)
  @response.writeHead(200, {'Content-Type': 'text/plain'})
  @response.end("success")
, {where: 'server'}

Router.route '/parse', ->
  body = @request.body
  console.log body
  phrase = "#{body.space} #{body.phrase || ""} "
  chain = new Commands.Chain(phrase)
  results = chain.execute(true)

  if Meteor.settings.showRecognition
    Notify phrase

  @response.writeHead(200, {'Content-Type': 'text/plain'})
  @response.end("success")
, {where: 'server'}

# alfred

Router.route 'api/recall', ->
  body = @request.body
  id = body.query
  console.log id
  if id
    item = PreviousCommands.findOne(id)
    console.log item
    if item
      chain = new Commands.Chain(item.spoken + " ")
      results = chain.execute(true)
  @response.writeHead(200, {'Content-Type': 'text/plain'})
  @response.end("success")
, {where: 'server'}

Router.route 'api/history', ->
  body = @request.body
  items = PreviousCommands.find({}, {sort: {createdAt: -1}, limit: 50}).fetch()
  # console.log items
  itemString = _.map items, (item, index) ->
    """
    <item arg="#{item._id}" valid="YES">
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
  @response.writeHead(200, {'Content-Type': 'text/plain'})
  @response.end(result)
, {where: 'server'}


Router.route 'api/websites', ->
  formatted = []
  _.each Settings.websites, (value, key) ->
    formatted.push
      value: value
      trigger: key

  results = if @request.body.query?.length
    f = new Fuse formatted,
      keys: ['value', 'trigger']
    f.search(@request.body.query)
  else
    formatted

  itemString = _.map results, (item) ->
    """
    <item arg="#{item.trigger}" valid="YES">
      <title>#{item.value}</title>
      <subtitle>#{item.trigger}</subtitle>
      <icon>~/voicecode/assets/images/voicecode-alfred.png</icon>
      <text type="copy">#{item.value}</text>
    </item>
    """
  final = """
  <?xml version="1.0"?>
  <items>
  #{itemString.join("\n")}
  </items>
  """
  @response.writeHead(200, {'Content-Type': 'text/plain'})
  @response.end(final)
, {where: 'server'}

Router.route 'api/abbreviations', ->
  formatted = []
  _.each Settings.abbreviations, (value, key) ->
    formatted.push
      value: value
      trigger: key

  results = if @request.body.query?.length
    f = new Fuse formatted,
      keys: ['value', 'trigger']
    f.search(@request.body.query)
  else
    formatted

  itemString = _.map results, (item) ->
    """
    <item arg="#{item.trigger}" valid="YES">
      <title>#{item.value}</title>
      <subtitle>#{item.trigger}</subtitle>
      <icon>~/voicecode/assets/images/voicecode-alfred.png</icon>
      <text type="copy">#{item.value}</text>
    </item>
    """
  final = """
  <?xml version="1.0"?>
  <items>
  #{itemString.join("\n")}
  </items>
  """
  @response.writeHead(200, {'Content-Type': 'text/plain'})
  @response.end(final)
, {where: 'server'}

Router.route 'api/directories', ->
  formatted = []
  _.each Settings.directories, (value, key) ->
    formatted.push
      value: value
      trigger: key

  results = if @request.body.query?.length
    f = new Fuse formatted,
      keys: ['value', 'trigger']
    f.search(@request.body.query)
  else
    formatted

  itemString = _.map results, (item) ->
    """
    <item arg="#{item.trigger}" valid="YES">
      <title>#{item.value}</title>
      <subtitle>#{item.trigger}</subtitle>
      <icon>~/voicecode/assets/images/voicecode-alfred.png</icon>
      <text type="copy">#{item.value}</text>
    </item>
    """
  final = """
  <?xml version="1.0"?>
  <items>
  #{itemString.join("\n")}
  </items>
  """
  @response.writeHead(200, {'Content-Type': 'text/plain'})
  @response.end(final)
, {where: 'server'}

Router.route 'api/emails', ->
  formatted = []
  _.each Settings.emails, (value, key) ->
    formatted.push
      value: value
      trigger: key

  results = if @request.body.query?.length
    f = new Fuse formatted,
      keys: ['value', 'trigger']
    f.search(@request.body.query)
  else
    formatted

  itemString = _.map results, (item) ->
    """
    <item arg="#{item.trigger}" valid="YES">
      <title>#{item.value}</title>
      <subtitle>#{item.trigger}</subtitle>
      <icon>~/voicecode/assets/images/voicecode-alfred.png</icon>
      <text type="copy">#{item.value}</text>
    </item>
    """
  final = """
  <?xml version="1.0"?>
  <items>
  #{itemString.join("\n")}
  </items>
  """
  @response.writeHead(200, {'Content-Type': 'text/plain'})
  @response.end(final)
, {where: 'server'}


Router.route 'api/usernames', ->
  formatted = []
  _.each Settings.usernames, (value, key) ->
    formatted.push
      value: value
      trigger: key

  results = if @request.body.query?.length
    f = new Fuse formatted,
      keys: ['value', 'trigger']
    f.search(@request.body.query)
  else
    formatted

  itemString = _.map results, (item) ->
    """
    <item arg="#{item.trigger}" valid="YES">
      <title>#{item.value}</title>
      <subtitle>#{item.trigger}</subtitle>
      <icon>~/voicecode/assets/images/voicecode-alfred.png</icon>
      <text type="copy">#{item.value}</text>
    </item>
    """
  final = """
  <?xml version="1.0"?>
  <items>
  #{itemString.join("\n")}
  </items>
  """
  @response.writeHead(200, {'Content-Type': 'text/plain'})
  @response.end(final)
, {where: 'server'}
