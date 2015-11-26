pack = Packages.register
  name: 'homonyms'
  description: 'Commands for working with homonyms and words that sound alike'

pack.settings
  words: require './words'

Homonyms = require './homonyms'

pack.ready ->
  @homonyms = new Homonyms(@settings().words)

pack.commands
  'cycle':
    spoken: 'cyclom'
    grammarType: 'oneArgument'
    description: 'if text is selected, will rotate through homonyms. If argument is spoken, will print next homonym of argument'
    autoSpacing: 'normal normal'
    multiPhraseAutoSpacing: 'normal normal'
    action: (input) ->
      if input
        other = pack.homonyms.next input
        if other?
          @string other
      else
        if @isTextSelected()
          contents = @getSelectedText()?.toLowerCase()
          if contents?.length
            transformed = pack.homonyms.next contents
            if transformed?
              @string transformed
              for i in [1..transformed.length]
                @key 'left', 'shift'
