pack = Packages.register
  name: 'core'
  description: 'Core VoiceCode commands needed for base functionality'

pack.commands
  'literal':
    description: 'words with spaces between.
     This command is for internal grammar use (not spoken)'
    tags: ['text', 'recommended']
    needsCommand: false
    needsParsing: false
    vocabulary: false
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
    vocabulary: false
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
  "show.history":
    spoken: 'recon'
    description: "Show command history"
    tags: ["voicecode"]
    action: ->
      # TODO: implement UI
  'executeWorkflow':
    spoken: "flak"
    grammarType: "textCapture"
    description: "Execute workflow"
    tags: ["voicecode"]
    inputRequired: true
    action: (input) ->
      if input?.length # FIX: this
        workflow = @fuzzyMatch Settings.workflows, input.join(' ')
        chain = new Chain(workflow + " ")
        results = chain.generateNestedInterpretation()
        _.each results, (command) =>
          command.call(@)
          @delay 50
  'mode.set':
    spoken: "set mode"
    grammarType: "textCapture"
    description: "change voicecode command execution mode"
    tags: ["system", "voicecode"]
    continuous: false
    inputRequired: true
    action: (input) ->
      if input?.length
        mode = @fuzzyMatch Settings.modes, input.join(' ')
        @setGlobalMode(mode)
