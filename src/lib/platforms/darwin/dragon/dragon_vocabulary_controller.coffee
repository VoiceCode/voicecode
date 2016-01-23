module.exports = new class DragonVocabularyController
  # singleton
  instance = null
  constructor: ->
    return instance if instance?
    instance = @
    @standard = []
    @alternate = {}
    @repeatable = []
    @spaceBefore = []
    @dynamic = []

  loadCommandVocabulary: ->
    for key, value of Commands.mapping
      if value.enabled is true
        unless value.vocabulary is false
          if value.rule?
            @dynamic.push key
          else
            @standard.push value.spoken
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

  start: ->
    @generateVocabularies()
    # TODO monitor other events and keep the generated files up to date
    # Event.on '???', @generateVocabularies.bind(@)
    return @

  generateVocabularies: ->
    @loadCommandVocabulary()
    @loadSettingsVocabulary()

    contentGenerators =
      standard: @createStandardContent
      alternate: @createAlternateContent
      repeatable: @createRepeatableContent
      spaced: @createSpaceContent
      sequence: @createSequenceContent
      dynamic: @createDynamicContent
    _.each contentGenerators,
    (generator, filename) =>
      @createVocabFile filename, generator.call @

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
    file = path.resolve(AssetsController.assetsPath, "generated/#{filename}.xml")
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
    repetitions = _.keys Packages.get('repetition')?.settings()?.values
    for name in @repeatable
      for spoken in repetitions
        items.push @buildWord [name, spoken].join(' ')
    items.join("\n")
  createSpaceContent: ->
    items = []
    spokenForSpace = Commands.get('symbols:space').spoken
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
  createDynamicContent: ->
    natural = require 'natural'
    all = _.map @dynamic, (id) ->
      command = new Command(id)
      grammar = command.grammar
      tokens = _.clone grammar.tokens
      if grammar.includeName
        tokens.unshift {text: command.spoken}
      tokens = _.map tokens, (t) ->
        if t.text?
          list = [t.text]
        else
          if grammar.lists[t.list[0]]?
            if grammar.lists[t.list[0]].kind is 'array'
              list = grammar.lists[t.list[0]].items
            else
              list = _.keys grammar.lists[t.list[0]].items
          else
            list = t.list
        list

    all = _.map all, (tokens) ->
      _.reduce tokens[1..], (result, list, index) ->
        _.flattenDeep _.map result, (r) ->
          _.map list, (l) -> "#{r} #{l}"
      , tokens[0]

    all = _.map all, (tokens) ->
      _.unique _.flatten _.map tokens, (t) ->
        _.map natural.NGrams.bigrams(t.toLowerCase()), (bigrams) -> bigrams.join ' '

    _.reduce all, (result, phrases) =>
      result += _.reduce phrases, ((res, phrase) => res += @buildWord phrase.trim().replace /\s+/, ' '), ''
    , ''
