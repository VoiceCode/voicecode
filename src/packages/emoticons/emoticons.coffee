settings = require './settings'

pack = Packages.register
  name: 'emoticons'
  description: 'Various emoticon-related commands'
  tags: ['emoticons', 'snippets']
  settings: settings

pack.commands
  'unicode':
    spoken: "porter"
    grammarType: "textCapture"
    description: "Insert a unicode emoticon such as 😄 or 🐒"
    action: (input) ->
      if input
        result = @fuzzyMatch settings.unicode, input.join(' ')
        @setClipboard result
        @delay 20
        @paste()
  'old-school':
    spoken: 'emo'
    description: 'Insert old-school text emoticons like :P or :)'
    tags: ['text']
    grammarType: 'textCapture'
    autoSpacing: 'normal normal'
    multiPhraseAutoSpacing: 'normal normal'
    inputRequired: true
    action: (name) ->
      if name?.length
        emoticon = @fuzzyMatch settings.oldSchool, name
        @string emoticon
