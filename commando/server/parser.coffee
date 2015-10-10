loadGrammar = ->
  console.log "reloading grammar"
  try
    fingerprint =
      data:
        license: Meteor.settings.license
        email: Meteor.settings.email
        grammar: @Grammar.build()

    fingerprintHash = CryptoJS.MD5(JSON.stringify(fingerprint)).toString()

    parserSettings = new SettingsManager("parser")

    if parserSettings.settings.fingerprintHash is fingerprintHash
      @ParseGenerator.string = parserSettings.settings.content
    else
      parseGenerator = HTTP.post "https://grammar.voicecode.io/grammar/generate", fingerprint
      @ParseGenerator.string = parseGenerator.content.replace(/[ ]+/g, " ")
      parserSettings.update
        content: @ParseGenerator.string
        fingerprint: fingerprint
        fingerprintHash: fingerprintHash
        updatedAt: new Date()


    @Parser = eval(ParseGenerator.string)

    if @Parser.success == false
      console.log Parser
      console.log "please check your license key"
      @Parser = undefined
      throw "invalid license key"

    Notify "voicecode is running!"
  catch e
    console.log e
    Notify "please check your license key, and make sure you are online"

isReloading = false
needsReloading = false
Commands.reloadGrammar = ->
  if isReloading
    needsReloading = true
  else
    console.log "reloading grammar"
    isReloading = true
    loadGrammar()
    isReloading = false
    if needsReloading
      needsReloading = false
      Commands.reloadGrammar()
