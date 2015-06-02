class @Abbreviation
  # singleton
  instance = null
  constructor: ->
    if instance
      return instance
    else
      instance = @
      @checkVocabulary()
  fingerprint: ->
    CryptoJS.MD5(JSON.stringify(Settings.abbreviations)).toString()
  checkVocabulary: ->
    if Meteor.isServer
      manager = new SettingsManager("versions")
      fingerprint = manager.settings.abbreviations
      unless fingerprint is @fingerprint()
        @createVocabFile()
        manager.settings.abbreviations = @fingerprint()
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
      #{@createVocabContent()}
      </array>
    </dict>
    </plist>
    """
    file = [process.env.PWD, "/user/abbreviations.xml"].join('')
    fs = Meteor.npmRequire('fs')
    fs.writeFileSync file, content, 'utf8'
  createVocabContent: ->
    _.map Settings.abbreviations, (value, key) =>
      @buildWord ["shrink", key].join(' ')
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
