Meteor.startup ->
  @Grammar = new Grammar()
  @ParseGenerator = {}

  try
    parseGenerator = HTTP.post "https://grammar.voicecode.io/grammar/generate",
      data:
        license: Meteor.settings.license
        email: Meteor.settings.email
        grammar: @Grammar.build()

    @ParseGenerator.string = parseGenerator.content
    @Parser = eval(ParseGenerator.string)

    if @Parser.success == false
      console.log Parser
      console.log "please check your license key"
      throw "invalid license key"

    notice ="""osascript <<EOD
    display notification "voicecode is running!"
    EOD
    """
    Shell.exec notice, async: true
  catch e
    notice ="""osascript <<EOD
    display notification "please check your VoiceCode license key, and make sure you are online"
    EOD
    """
    Shell.exec notice, async: true
