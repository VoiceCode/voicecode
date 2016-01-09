pack = Packages.register
  name: 'core'
  description: 'Core VoiceCode commands needed for base functionality'

pack.actions
  string: (string) ->
    @do 'core:string', string

pack.commands
  'string':
    needsCommand: false
    needsParsing: false

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
    spoken: 'sherlock'
    description: 'Will insert the identifier of the next command spoken'
    grammarType: 'commandCapture'
    action: ({identifier, spoken}) ->
      @string(identifier) if identifier?
  'pass-through':
    spoken: 'keeper'
    description: 'whatever follows this command will be interpreted literally'
    grammarType: 'unconstrainedText'
    tags: ['text', 'recommended']
    action: (input) ->
      if input?.length
        @string input.join ' '
  'delimiter':
    spoken: 'shin'
    description: "Does nothing on its own, used as a command delimiter."
    misspellings: ["chin"]
    tags: ["text", "recommended"]
    action: ->
      null
