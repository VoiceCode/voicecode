class @Vocabulary
  # singleton
  instance = null
  constructor: ->
    if instance
      return instance
    else
      instance = @
      @standard = []
      @listWords = []
      @alternate = {}
      @repeatable = []
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
      else if value.repeatable
        @repeatable.push key
  loadVocabulary: ->
    # from vocab list
    for item in Settings.vocabulary
      @standard.push item
    _.extend @alternate, Settings.vocabularyAlternate

    # from commands with arguments
    for prefix, listName of Settings.vocabularyListGenerators
      list = Settings[listName]
      for itemName, itemResult of list
        @standard.push [prefix, itemName].join(' ')

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
      #{@createStandardContent()}
      #{@createAlternateContent()}
      #{@createRepeatableContent()}
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
  createRepeatableContent: ->
    items = []
    for name in @repeatable
      for counter, value of Settings.repetitionWords
        items.push @buildWord [name, counter].join(' ')
    items.join("\n")
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
