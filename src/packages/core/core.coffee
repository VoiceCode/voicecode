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
