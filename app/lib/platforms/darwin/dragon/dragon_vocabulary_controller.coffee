fs = require('fs')
path = require('path')

VocabularyController = require '../../base/vocabulary_controller'

class DragonVocabularyController extends VocabularyController

  generate: ->
    emit "vocabularyController:willGenerate"
    for name, generator of @lists
      @createVocabFile name, generator()
    @createVocabularyTrainingFile()

  createVocabularyTrainingFile: ->
    file = path.resolve(AssetsController.assetsPath, "generated/vocabulary_training.txt")
    fs.writeFileSync file, @generateVocabularyTraining(), 'utf8'

  createVocabFile: (filename, phrases) ->
    words = _.map phrases, (phrase) =>
      if _.isArray phrase
        @buildWord phrase[0], phrase[1]
      else
        @buildWord phrase
    .join '\n'

    content = """
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Version</key>
      <string>3.0/1</string>
      <key>Words</key>
      <array>
      #{words}
      </array>
    </dict>
    </plist>
    """

    file = path.resolve(AssetsController.assetsPath, "generated/#{filename}.xml")
    fs.writeFileSync file, content, 'utf8'

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
instance = new DragonVocabularyController()
module.exports = instance
