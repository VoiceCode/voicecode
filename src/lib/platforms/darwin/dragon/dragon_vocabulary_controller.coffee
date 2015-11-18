module.exports = new class DragonVocabularyController
  constructor: ->
    instance = @
    @standard = []
    @alternate = {}
    @repeatable = []
    @spaceBefore = []
    @loadCommandVocabulary()
    @loadSettingsVocabulary()
    @generateVocabularies()

  loadCommandVocabulary: ->
    for key, value of _.pluck Commands.mapping, {enabled: true}
      @standard.push value.spoken
      # if value.vocabulary? # I don't get this
      #   @alternate[value.vocabulary] = value.spoken
      if value.repeatable
        @repeatable.push value.spoken
      else if value.spaceBefore
        @spaceBefore.push value.spoken
  loadSettingsVocabulary: ->
    # from vocab list

    # standard vocabulary
    for item in Settings.vocabulary
      @standard.push item

    # vocab with alternate pronunciations
    _.extend @alternate, Settings.vocabularyAlternate

    # from lists of arguments in settings
    for prefix, listName of Settings.vocabularyListGenerators
      list = Settings[listName]
      for itemName, itemResult of list
        # filter out misspellings
        unless itemName[0] is "_"
          @standard.push [prefix, itemName].join(' ')

  generateVocabularies: ->
    contentGenerators =
      standard: @createStandardContent
      alternate: @createAlternateContent
      repeatable: @createRepeatableContent
      spaced: @createSpaceContent
      sequence: @createSequenceContent
    _.each contentGenerators, (generator, filename) => @createVocabFile filename, generator.call @

  createVocabFile: (filename, content) ->
    content = """
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Version</key>
      <string>3.0/1</string>
      <key>Words</key>
      <array>
      #{content}
      </array>
    </dict>
    </plist>
    """
    path = require('path')
    file = path.resolve(UserAssetsController.assetsPath, "generated/#{filename}.xml")
    fs = require('fs')
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
  createRepeatableContent: ->
    items = []
    for name in @repeatable
      for counter, value of Settings.repetitionWords
        items.push @buildWord [name, counter].join(' ')
    items.join("\n")
  createSpaceContent: ->
    items = []
    spokenForSpace = Commands.get('symbol.space').spoken
    for name in @spaceBefore
      items.push @buildWord [spokenForSpace, name].join(' ')
    items.join("\n")
  createSequenceContent: ->
    items = []
    for name, followers of Settings.commonSequences
      name = Commands.get name
      continue if not name? or name.enabled is false
      for suffix in followers
        suffix = Commands.get suffix
        continue if not suffix? or suffix.enabled is false
        items.push @buildWord [name.spoken, suffix.spoken].join(' ')
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
