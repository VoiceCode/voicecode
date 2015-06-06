class @Vocabulary
  # singleton
  instance = null
  constructor: ->
    if instance
      return instance
    else
      instance = @
      @standard = []
      @alternate = {}
      @loadCommands()
      @loadCommandVocabulary()
      @loadVocabulary()
      @checkVocabulary()
  loadCommands: ->
    _.each @commandNames, (name) ->
      Commands.create name,
        description: "Enters the word: #{name}"
        grammarType: "none"
        tags: ['word']
  commandNames: -> []
  loadCommandVocabulary: ->
    for key, value of Commands.mapping
      if value.vocabulary is true
        @standard.push key
      else if value.vocabulary?
        @alternate[value.vocabulary] = key
  loadVocabulary: ->
    for item in Settings.vocabulary
      @standard.push item
    _.extend @alternate, Settings.vocabularyAlternate
  fingerprint: ->
    data =
      standard: @standard
      alternate: @alternate
    CryptoJS.MD5(JSON.stringify(data)).toString()
  checkVocabulary: ->
    if Meteor.isServer
      manager = new SettingsManager("versions")
      fingerprint = manager.settings.vocabulary
      unless fingerprint is @fingerprint()
        @createVocabFile()
        manager.settings.vocabulary = @fingerprint()
        manager.save()
  createVocabFile: ->
    content = """
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Version</key>
      <string>3.0/1</string>
      <key>Words</key>
      <array>
      #{@createStandardContent()}
      #{@createAlternateContent()}
      </array>
    </dict>
    </plist>
    """
    file = [process.env.PWD, "/user/vocabulary.xml"].join('')
    fs = Meteor.npmRequire('fs')
    fs.writeFileSync file, content, 'utf8'
  createStandardContent: ->
    _.map @standard, (value) =>
      @buildWord value, value
    .join("\n")
  createAlternateContent: ->
    items = []
    for spoken, written of @alternate
      items.push @buildWord(written, spoken)
    items.join("\n")
  buildWord: (item, spoken) ->
    """
    <dict>
      <key>EngineFlags</key>
      <integer>17</integer>
      <key>Flags</key>
      <string></string>
      <key>Sense</key>
      <string></string>
      <key>Source</key>
      <string>User</string>
      <key>Spoken</key>
      <string>#{spoken or item}</string>
      <key>Written</key>
      <string>#{item}</string>
    </dict>
    """
