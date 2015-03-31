# RESTstop.configure
#   api_path: "parse"
#   console.log @params

# RESTstop.add "miss/:namespace", ->
#   console.log @params
#   # the space at the end is important! (For parsing, makes it simpler)
#   phrase = "#{@params.namespace} "
#   chain = new Commands.Chain(phrase)
#   results = chain.execute(false)
#   {}


  # RESTstop.add "testing2", ->
  #   console.log @
  #   # notice ="""osascript <<EOD
  #   # tell application "System Events"
  #   # keystroke "b"
  #   # end tell
  #   # EOD
  #   # """
  #   notice2 ="osascript ~/projects/voiceCode/utility/applescripts/arch5.scpt"

  #   Shell.exec notice2, async: true
  #   # Shell.exec notice, async: true

  #   {}
  #   ""

# RESTstop.add "testing", ->
#   console.log @params
#   notice ="osascript /Users/triumph/projects/voiceCode/utility/applescripts/arch5.scpt"
#   # notice ="""osascript <<EOD
#   # tell application "System Events"
#   # keystroke "b"
#   # end tell
#   # EOD
#   # """
#   Shell.exec notice, async: true
#   {}


# for alfred

# RESTstop.add "recall", ->
#   console.log @params
#   id = @params.query
#   console.log id
#   if id
#     item = PreviousCommands.findOne(id)
#     console.log item
#     if item
#       chain = new Commands.Chain(item.spoken + " ")
#       results = chain.execute(true)
#   {}

# RESTstop.add "history", ->
#   console.log @params
#   items = PreviousCommands.find({}, {sort: {createdAt: -1}, limit: 50}).fetch()
#   # console.log items
#   itemString = _.map items, (item, index) -> 
#     """
#     <item arg="#{item._id}" valid="YES">
#       <title>#{item.spoken}</title>
#       <icon>~/voicecode/assets/images/voicecode-alfred.png</icon>
#       <text type="copy">#{item.spoken}</text>
#     </item>
#     """
#   result = """
#   <?xml version="1.0"?>
#   <items>
#   #{itemString.join("\n")}
#   </items>
#   """
#   result

# RESTstop.add "websites", ->
#   formatted = []
#   _.each CommandoSettings.websites, (value, key) ->
#     formatted.push
#       value: value
#       trigger: key

#   results = if @params.query?.length
#     f = new Fuse formatted,
#       keys: ['value', 'trigger']
#     f.search(@params.query)
#   else
#     formatted

#   itemString = _.map results, (item) -> 
#     """
#     <item arg="#{item.trigger}" valid="YES">
#       <title>#{item.value}</title>
#       <subtitle>#{item.trigger}</subtitle>
#       <icon>~/voicecode/assets/images/voicecode-alfred.png</icon>
#       <text type="copy">#{item.value}</text>
#     </item>
#     """
#   final = """
#   <?xml version="1.0"?>
#   <items>
#   #{itemString.join("\n")}
#   </items>
#   """
#   final

# RESTstop.add "abbreviations", ->
#   formatted = []
#   _.each CommandoSettings.abbreviations, (value, key) ->
#     formatted.push
#       value: value
#       trigger: key

#   results = if @params.query?.length
#     f = new Fuse formatted,
#       keys: ['value', 'trigger']
#     f.search(@params.query)
#   else
#     formatted

#   itemString = _.map results, (item) -> 
#     """
#     <item arg="#{item.trigger}" valid="YES">
#       <title>#{item.value}</title>
#       <subtitle>#{item.trigger}</subtitle>
#       <icon>~/voicecode/assets/images/voicecode-alfred.png</icon>
#       <text type="copy">#{item.value}</text>
#     </item>
#     """
#   final = """
#   <?xml version="1.0"?>
#   <items>
#   #{itemString.join("\n")}
#   </items>
#   """
#   final

# RESTstop.add "directories", ->
#   formatted = []
#   _.each CommandoSettings.directories, (value, key) ->
#     formatted.push
#       value: value
#       trigger: key

#   results = if @params.query?.length
#     f = new Fuse formatted,
#       keys: ['value', 'trigger']
#     f.search(@params.query)
#   else
#     formatted

#   itemString = _.map results, (item) -> 
#     """
#     <item arg="#{item.trigger}" valid="YES">
#       <title>#{item.value}</title>
#       <subtitle>#{item.trigger}</subtitle>
#       <icon>~/voicecode/assets/images/voicecode-alfred.png</icon>
#       <text type="copy">#{item.value}</text>
#     </item>
#     """
#   final = """
#   <?xml version="1.0"?>
#   <items>
#   #{itemString.join("\n")}
#   </items>
#   """
#   final

# RESTstop.add "emails", ->
#   formatted = []
#   _.each CommandoSettings.emails, (value, key) ->
#     formatted.push
#       value: value
#       trigger: key

#   results = if @params.query?.length
#     f = new Fuse formatted,
#       keys: ['value', 'trigger']
#     f.search(@params.query)
#   else
#     formatted

#   itemString = _.map results, (item) -> 
#     """
#     <item arg="#{item.trigger}" valid="YES">
#       <title>#{item.value}</title>
#       <subtitle>#{item.trigger}</subtitle>
#       <icon>~/voicecode/assets/images/voicecode-alfred.png</icon>
#       <text type="copy">#{item.value}</text>
#     </item>
#     """
#   final = """
#   <?xml version="1.0"?>
#   <items>
#   #{itemString.join("\n")}
#   </items>
#   """
#   final

# RESTstop.add "usernames", ->
#   formatted = []
#   _.each CommandoSettings.usernames, (value, key) ->
#     formatted.push
#       value: value
#       trigger: key

#   results = if @params.query?.length
#     f = new Fuse formatted,
#       keys: ['value', 'trigger']
#     f.search(@params.query)
#   else
#     formatted

#   itemString = _.map results, (item) -> 
#     """
#     <item arg="#{item.trigger}" valid="YES">
#       <title>#{item.value}</title>
#       <subtitle>#{item.trigger}</subtitle>
#       <icon>~/voicecode/assets/images/voicecode-alfred.png</icon>
#       <text type="copy">#{item.value}</text>
#     </item>
#     """
#   final = """
#   <?xml version="1.0"?>
#   <items>
#   #{itemString.join("\n")}
#   </items>
#   """
#   final


# for regular commands

# RESTstop.add ":namespace/:body?", ->
#   console.log @params
#   # the space at the end is important! (For parsing, makes it simpler)
#   phrase = "#{@params.namespace} #{@params.body || ""} "
#   chain = new Commands.Chain(phrase)
#   results = chain.execute(true)

#   if Meteor.settings.showRecognition
#     notice ="""osascript <<EOD
#     display notification "#{phrase}"
#     EOD
#     """
#     Shell.exec notice, async: true
    
#   {}

# Router.route 'item', ->
#   request = @request
#   response = @response
#   console.log @params
#   response.end('hello from the server\n')
# , {where: 'server'}

