class @Vocabulary
  # singleton
  instance = null
  constructor: ->
    if instance
      return instance
    else
      instance = @
      @loadCommands()
      @checkVocabulary()
  loadCommands: ->
    _.each @commandNames, (name) ->
      Commands.create name,
        description: "Enters the word: #{name}"
        grammarType: "none"
        tags: ['word']
  commandNames: -> []
  fingerprint: ->
    data =
      vocabulary: Settings.vocabulary
      # vocabularyNonstandard: Settings.vocabularyNonstandard
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
      #{@createVocabularyContent()}
      </array>
    </dict>
    </plist>
    """
    file = [process.env.PWD, "/user/vocabulary.xml"].join('')
    fs = Meteor.npmRequire('fs')
    fs.writeFileSync file, content, 'utf8'
  createVocabularyContent: ->
    items =
    _.map Settings.vocabulary, (value) =>
      @buildWord value
    .join("\n")
  buildWord: (item) ->
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
      <string>#{item}</string>
      <key>Written</key>
      <string>#{item}</string>
    </dict>
    """
