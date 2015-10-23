class @Modifiers
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
  suffixes: ->
    _.extend {}, Settings.letters, Settings.modifierSuffixes
  loadCommands: ->
    suffixes = @suffixes()
    _.each Settings.modifierPrefixes, (mods, name) ->
      _.each suffixes, (value, key) ->
        Commands.createDisabled "#{name} #{value}",
          description: "#{mods} #{key}"
          grammarType: "none"
          tags: ["modifiers"]
          action: ->
            @key key, mods
  fingerprint: ->
    data =
      letters: Settings.letters
      modifierSuffixes: Settings.modifierSuffixes
      modifierPrefixes: Settings.modifierPrefixes
    CryptoJS.MD5(JSON.stringify(data)).toString()
  checkVocabulary: ->
    if Meteor.isServer
      @createVocabFile()
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
    path = Meteor.npmRequire('path')
    file = path.resolve(projectRoot, "user", "modifiers.xml")
    fs = Meteor.npmRequire('fs')
    fs.writeFileSync file, content, 'utf8'
  createVocabContent: ->
    results = []
    _.each Settings.modifierPrefixes, (mods, name) =>
      _.each @suffixes(), (value, key) =>
        command = [name, value].join(' ')
        if Commands.mapping[command]?.enabled
          results.push @buildLetter(command)
    results.join('\n')
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

# recommended =
#   chomm: [
#     "won"
#     "too"
#     "three"
#     "four"
#     "five"
#     "six"
#     "seven"
#     "ate"
#     "nine"
#     "zer"
#     "arch"
#     "brov"
#     "dell"
#     "etch"
#     "lug"
#     "mowsh"
#     "nerb"
#     "pooch"
#     "quash"
#     "rosh"
#     "slush"
#     "turn"
#     "leet"
#   ]
#   shoff: [
#     "dell"
#     "souk"
#   ]
#   troll: [
#     "char"
#     "zooch"
#   ]
  # sky: [
  #   "arch"
  #   "brov"
  #   "char"
  #   "dell"
  #   "etch"
  #   "fomp"
  #   "goof"
  #   "hark"
  #   "ice"
  #   "jinks"
  #   "koop"
  #   "lug"
  #   "mowsh"
  #   "nerb"
  #   "ork"
  #   "pooch"
  #   "quash"
  #   "rosh"
  #   "souk"
  #   "teek"
  #   "unks"
  #   "verge"
  #   "womp"
  #   "trex"
  #   "yang"
  #   "zooch"
  # ]
