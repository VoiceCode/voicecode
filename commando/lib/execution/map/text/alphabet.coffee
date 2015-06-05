class @Alphabet
  # singleton
  instance = null
  constructor: ->
    if instance
      return instance
    else
      instance = @
      @roots = _.invert Settings.letters
      @loadCommands()
      @checkVocabulary()
  buildPhonemeString: (individuals) ->
    _.map individuals, (letter) ->
      @roots[letter]
    .join('')
  loadCommands: ->
    _.each Settings.letters, (value, key) ->
      Commands.create value,
        description: "Enters the single letter: #{key}"
        grammarType: "none"
        tags: ['alphabet']

      # uppers
      upper = key.toUpperCase()
      prefix = Settings.uppercaseLetterPrefix
      Commands.create "#{prefix} #{value}",
        description: "Enters the capital letter: #{upper}"
        grammarType: "none"

      # with suffix
      suffix = Settings.singleLetterSuffix
      Commands.create "#{value} #{suffix}",
        description: "Enters the letter: #{value} (with better recognition because of suffix: '#{suffix}')"
        grammarType: "none"

      # nested
      _.each Settings.letters, (valueIn, keyIn) ->
        Commands.create [value, valueIn].join(' '),
          description: "Enters the letter combo: #{key}#{keyIn}"
          grammarType: "none"
  fingerprint: ->
    data =
      letters: Settings.letters
      prefix: Settings.uppercaseLetterPrefix
      suffix: Settings.singleLetterSuffix
    CryptoJS.MD5(JSON.stringify(data)).toString()
  checkVocabulary: ->
    if Meteor.isServer
      manager = new SettingsManager("versions")
      fingerprint = manager.settings.alphabet
      unless fingerprint is @fingerprint()
        @createVocabFile()
        manager.settings.alphabet = @fingerprint()
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
      #{@createVocabComboContent()}
      #{@createVocabSingleContent()}
      #{@createVocabUpperContent()}
      </array>
    </dict>
    </plist>
    """
    file = [process.env.PWD, "/user/alphabet.xml"].join('')
    fs = Meteor.npmRequire('fs')
    fs.writeFileSync file, content, 'utf8'
  createVocabComboContent: ->
    _.map Settings.letters, (value, key) =>
      _.map Settings.letters, (valueIn, keyIn) =>
        @buildLetter [value, valueIn].join(' ')
      .join("\n")
    .join("\n")
  createVocabSingleContent: ->
    _.map Settings.letters, (value, key) =>
      @buildLetter [value, Settings.singleLetterSuffix].join(' ')
    .join("\n")
  createVocabUpperContent: ->
    _.map Settings.letters, (value, key) =>
      @buildLetter [Settings.uppercaseLetterPrefix, value].join(' ')
    .join("\n")
  buildLetter: (item) ->
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
