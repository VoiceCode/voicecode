class ParserController
  instance = null
  constructor: ->
    return instance if instance?
    instance = @
    @cryptojs = require 'crypto-js'
    @fingerprintHash = null
    @fingerprint = null
    @initialize()

  initialize: ->
    Events.on 'generateParserFailed', _.bind @regress, @

  generateParser: ->
    @generateFingerprint()
    @generateFingerprintHash()
    {
      fingerprintHash: oldFingerprintHash
      content: oldParser
    } = @loadFromDisk()
    if oldFingerprintHash is @fingerprintHash
      @setParser oldParser
    else
      try
        @getNewParser()
      catch e
        @regress e

  regress: (reason) ->
    {settings:
      content: oldParser
    } = @loadFromDisk()
    log null, null, 'Regressing to old parser because: ', reason
    @setParser oldParser

  setParser: (parserAsAString) ->
    try
      global.Parser = eval parserAsAString
      log 'generateParserSuccess', Parser, 'Parser acquired.'
    catch e
      error 'generateParserFailed', e, 'Failed evaluating new parser.'

  writeToDisk: (data) ->
    @settingsManager ?= new SettingsManager("parser")
    @settingsManager.update data

  loadFromDisk: ->
    @settingsManager ?= new SettingsManager("parser")
    @settingsManager.settings

  generateFingerprint: ->
    @fingerprint =
      license: Settings.license
      email: Settings.email
      grammar: Grammar.build()

  generateFingerprintHash: (fingerprint = @fingerprint)->
    @fingerprintHash = @cryptojs.MD5(JSON.stringify(fingerprint)).toString()

  getNewParser: ->
    @fingerprint ?= @generateFingerprint()
    https = require 'https'
    querystring = require 'querystring'
    payload = querystring.stringify @fingerprint
    options =
      hostname: 'grammar.voicecode.io'
      port: 443
      path: '/grammar/generate'
      method: 'POST'
      headers:
        'Content-Type': 'application/x-www-form-urlencoded'
        'Content-Length': Buffer.byteLength(payload)
    req = https.request options, (res) =>
      # console.log 'STATUS: ' + res.statusCode
      # console.log 'HEADERS: ' + JSON.stringify(res.headers)
      res.setEncoding 'utf8'
      data = ''
      res.on 'data', (chunk) ->
        data += chunk
      res.on 'end', =>
        data = data.replace(/[ ]+/g, " ")
        try
          newParser = eval data
        catch e
          error 'generateParserFailed', data, 'Failed evaluating new parser.'
          return
        if newParser.success is false
          error 'generateParserFailed', newParser, 'Parser got no success.'
          return
        @setParser newParser
        @writeToDisk
          content: data
          fingerprint: @fingerprint
          fingerprintHash: @fingerprintHash
          updatedAt: new Date()

    req.on 'error', (e) ->
      error 'generateParserFailed', e, 'Failed requesting parser: ' + e.message

    req.write payload
    req.end()

module.exports = new ParserController
