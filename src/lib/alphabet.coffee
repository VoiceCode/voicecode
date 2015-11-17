class Alphabet
  # singleton
  instance = null
  constructor: ->
    if instance
      return instance
    else
      instance = @
      @roots = _.invert Settings.letters
      # @loadCommands()
      @createCommand()
      # @checkVocabulary() unless Settings.slaveMode
  buildPhonemeString: (individuals) ->
    _.map individuals, (letter) ->
      @roots[letter]
    .join('')
  createCommand: ->
      # spoken: '(alphabet) (alphabet)* (alphabet)* (alphabet)* (alphabet)* (alphabet)*'
    Commands.create 'spelling',
      description: 'phonetic alphabet'
      grammarType: 'custom'
      rule: '(alphabet) (alphabet)*'
      needsParsing: false
      variables:
        alphabet: @possibleAlphabetValues()
  possibleAlphabetValues: ->
    results = _.values(Settings.letters)
    results.push Settings.uppercaseLetterPrefix
    results.push Settings.singleLetterSuffix
    results
  fingerprint: ->
    data =
      letters: Settings.letters
      prefix: Settings.uppercaseLetterPrefix
      suffix: Settings.singleLetterSuffix
    CryptoJS.MD5(JSON.stringify(data)).toString()
  checkVocabulary: ->
    manager = new SettingsManager("generated/versions")
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
    fs = require('fs')
    path = require('path')
    file = path.resolve(userAssetsController.assetsPath, 'generated/alphabet.xml')
    fs.writeFileSync file, content, 'utf8'
  createVocabComboContent: ->
    _.map Settings.letters, (value, key) =>
      _.map Settings.letters, (valueIn, keyIn) =>
        @buildLetter [value, valueIn].join(' ')
      .join('\n')
    .join('\n')
  createVocabSingleContent: ->
    _.map Settings.letters, (value, key) =>
      @buildLetter [value, Settings.singleLetterSuffix].join(' ')
    .join('\n')
  createVocabUpperContent: ->
    _.map Settings.letters, (value, key) =>
      @buildLetter [Settings.uppercaseLetterPrefix, value].join(' ')
    .join('\n')
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

module.exports = new Alphabet
