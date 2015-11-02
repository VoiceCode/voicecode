Commands.createDisabled
  'emo':
    description: 'old-school emoticons'
    tags: ['text']
    grammarType: 'textCapture'
    autoSpacing: 'normal normal'
    multiPhraseAutoSpacing: 'normal normal'
    inputRequired: true
    action: (name) ->
      if name?.length
        emoticon = @fuzzyMatch Settings.emoticons, name
        if emoticon?.length
          @string emoticon
