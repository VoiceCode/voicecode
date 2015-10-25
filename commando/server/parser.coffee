loadGrammar = ->
  emit 'grammarLoading'
  # try
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

  try
    @Parser = eval(ParseGenerator.string)
  catch error
    console.error 'Error while evaluating parser: '
    throw error


  if @Parser.success == false
    throwable = @Parser
    @Parser = undefined
    throw throwable

  emit 'grammarLoaded'
  # catch error
    # console.error error
    # emit 'grammarLoadFailed'

isReloading = false
needsReloading = false
Commands.reloadGrammar = ->
  if isReloading
    needsReloading = true
  else
    isReloading = true
    loadGrammar()
    isReloading = false
    if needsReloading
      needsReloading = false
      Commands.reloadGrammar()
