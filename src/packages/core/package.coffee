pack = Packages.register
  name: 'core'
  description: 'Core VoiceCode commands needed for base functionality'

pack.commands
  'literal':
    description: 'words with spaces between. This command is for internal grammar use (not spoken)'
    tags: ['text', 'recommended']
    needsCommand: false
    needsParsing: false
    autoSpacing: 'normal normal'
    multiPhraseAutoSpacing: (input) ->
      left = 'normal'
      right = 'normal'
      if input?.length
        if typeof input[0] is 'object' and input[0].source is 'phonemes'
          left = 'never'
        else if typeof input[0] is 'string'
          joined = input.join ' '
          if input[0] is '.'
            left = 'never'
          if input[input.length - 1] is '-'
            right = 'never'
      [right, left].join ' '
    action: (input) ->
      if input
        @string Transforms.literal(@normalizeTextArray(input))
  'delay':
    enabled: true
    needsParsing: false
    needsCommand: false
    action: (ms) ->
      @delay ms or 100
  'insert-command-id':
    description: 'Will insert the identifier of the next command spoken'
    grammarType: 'commandCapture'
    action: ({identifier, spoken}) ->
      @string(identifier) if identifier?
