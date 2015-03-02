Meteor.startup ->
  @Grammar = new Grammar()
  Commands.loadConditionalModules()
  @ParseGenerator = {}

  try
    fingerprint =
      data:
        license: Meteor.settings.license
        email: Meteor.settings.email
        grammar: @Grammar.build()

    fingerprintHash = CryptoJS.MD5(JSON.stringify(fingerprint)).toString()

    cash = Cashes.findOne(key: "parseGenerator")
    if cash and cash.fingerprint is fingerprintHash
      @ParseGenerator.string = cash.content
    else
      parseGenerator = HTTP.post "https://grammar.voicecode.io/grammar/generate", fingerprint
      @ParseGenerator.string = parseGenerator.content
      if cash
        Cashes.update cash._id,
          $set:
            content: parseGenerator.content
            fingerprint: fingerprintHash
            updatedAt: new Date()
      else
        Cashes.insert
          key: "parseGenerator"
          content: parseGenerator.content
          fingerprint: fingerprintHash
          updatedAt: new Date()

    @Parser = eval(ParseGenerator.string)

    if @Parser.success == false
      console.log Parser
      console.log "please check your license key"
      throw "invalid license key"

    notice ="""osascript <<EOD
    display notification "voicecode is running!" with title "VoiceCode"
    EOD
    """
    Shell.exec notice, async: true
  catch e
    console.log e
    notice ="""osascript <<EOD
    display notification "please check your license key, and make sure you are online" with title "VoiceCode"
    EOD
    """
    Shell.exec notice, async: true
