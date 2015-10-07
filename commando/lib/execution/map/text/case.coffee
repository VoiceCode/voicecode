Commands.createDisabled
  'vc-literal':
    grammarType: 'none'
    description: 'words with spaces between. This command is for internal grammar use (not spoken)'
    tags: ['text', 'recommended']
    needsDragonCommand: false
    isSpoken: false
    autoSpacing: 'normal normal'
    multiPhraseAutoSpacing: (input) ->
      if input?.length
        if typeof input[0] is 'object' and input[0].source is 'phonemes'
          return 'never normal'
      'normal normal'
    action: (input) ->
      if input
        @string Transforms.literal(@normalizeTextArray(input))
  'champ':
    grammarType: 'textCapture'
    description: 'capitalize next individual word'
    tags: ['text', 'recommended']
    spaceBefore: true
    autoSpacing: 'normal normal'
    multiPhraseAutoSpacing: 'normal normal'
    action: (input) ->
      if input
        @string Transforms.titleFirstSentance(input)
      else
        @transformSelectedText('titleFirstSentance')
  'cram':
    grammarType: 'textCapture'
    description: 'camelCaseText'
    tags: ['text', 'recommended']
    misspellings: ['crammed', 'crams', 'tram', 'kram']
    spaceBefore: true
    autoSpacing: 'normal normal'
    action: (input) ->
      if input
        @string Transforms.camel(input)
      else
        @transformSelectedText('camel')
  'dockram':
    grammarType: 'textCapture'
    description: 'space camelCaseText'
    tags: ['text', 'combo']
    multiPhraseAutoSpacing: 'never normal'
    action: (input) ->
      if input
        @string '.' + Transforms.camel(input)
  'snake':
    grammarType: 'textCapture'
    description: 'snake_case_text'
    tags: ['text', 'recommended']
    spaceBefore: true
    autoSpacing: 'normal normal'
    multiPhraseAutoSpacing: 'normal normal'
    action: (input) ->
      if input
        @string Transforms.snake(input)
      else
        @transformSelectedText('snake')
  'coalsnik':
    grammarType: 'textCapture'
    description: ':snake_case_with_a_colon_at_the_front'
    tags: ['text', 'combo']
    action: (input) ->
      if input
        @string ':' + Transforms.snake(input)
  'lowcram':
    grammarType: 'textCapture'
    description: '@camelCaseWithAtSign'
    tags: ['text', 'combo']
    spaceBefore: true
    action: (input) ->
      if input
        @string '@' + Transforms.camel(input)
      else
        @string '@'
  'dollcram':
    grammarType: 'textCapture'
    description: '$camelCaseWithDollarSign'
    tags: ['text']
    spaceBefore: true
    action: (input) ->
      if input
        @string '$' + Transforms.camel(input)
      else
        @string '$'
  'spine':
    grammarType: 'textCapture'
    description: 'spinal-case-text'
    misspellings: ['spying']
    tags: ['text', 'recommended']
    spaceBefore: true
    action: (input) ->
      if input
        @string Transforms.spine(input)
      else
        @transformSelectedText('spine')
  'criffed':
    description: 'StudCaseText'
    tags: ['text', 'recommended']
    misspellings: ['chaffed', 'crisped']
    grammarType: 'textCapture'
    spaceBefore: true
    autoSpacing: (input) ->
      if input then 'normal normal'
    multiPhraseAutoSpacing: (input) ->
      if input then 'normal normal'
    action: (input) ->
      if input
        @string Transforms.stud(input)
      else
        @transformSelectedText('stud')
  'dockriffed':
    description: 'space StudCaseText'
    tags: ['text', 'combo']
    grammarType: 'textCapture'
    action: (input) ->
      if input
        @string '.' + Transforms.stud(input)
  'dollkriffed':
    description: 'space StudCaseText'
    tags: ['text', 'combo']
    grammarType: 'textCapture'
    action: (input) ->
      if input
        @string '$' + Transforms.stud(input)
  'smash':
    grammarType: 'textCapture'
    description: 'lowercasewithnospaces'
    tags: ['text', 'recommended']
    spaceBefore: true
    action: (input) ->
      if input
        @string Transforms.lowerSlam(input)
      else
        @transformSelectedText('lowerSlam')
  'yellsmash':
    grammarType: 'textCapture'
    description: 'UPPERCASEWITHNOSPACES'
    tags: ['text']
    spaceBefore: true
    action: (input) ->
      if input
        @string Transforms.upperSlam(input)
      else
        @transformSelectedText('upperSlam')
  'yeller':
    grammarType: 'textCapture'
    description: 'UPPER CASE WITH SPACES'
    tags: ['text', 'recommended']
    spaceBefore: true
    autoSpacing: 'normal normal'
    multiPhraseAutoSpacing: 'normal normal'
    action: (input) ->
      if input
        @string Transforms.upperCase(input)
      else
        @transformSelectedText('upperCase')
  'yellsnik':
    grammarType: 'textCapture'
    description: 'UPPER_CASE_SNAKE'
    tags: ['text']
    spaceBefore: true
    action: (input) ->
      if input
        @string Transforms.upperSnake(input)
      else
        @transformSelectedText('upperSnake')
  'yellspin':
    grammarType: 'textCapture'
    description: 'UPPER-CASE-SPINE'
    tags: ['text']
    action: (input) ->
      if input
        @string Transforms.upperSpine(input)
      else
        @transformSelectedText('upperSpine')
  'pathway':
    grammarType: 'textCapture'
    description: 'separated/by/slashes'
    tags: ['text']
    action: (input) ->
      if input
        @string Transforms.slashes(input)
      else
        @transformSelectedText('slashes')
  'dotsway':
    grammarType: 'textCapture'
    description: 'separated.by.dots'
    tags: ['text']
    action: (input) ->
      if input
        @string Transforms.dots(input)
      else
        @transformSelectedText('dots')
  'tridal':
    grammarType: 'textCapture'
    description: 'Title Words With Spaces'
    tags: ['text', 'recommended']
    spaceBefore: true
    autoSpacing: 'normal normal'
    multiPhraseAutoSpacing: 'normal normal'
    action: (input) ->
      if input
        @string Transforms.titleSentance(input)
      else
        @transformSelectedText('titleSentance')
  'senchen':
    grammarType: 'textCapture'
    description: 'Sentence case with spaces'
    tags: ['text', 'recommended']
    spaceBefore: true
    autoSpacing: 'never normal'
    multiPhraseAutoSpacing: 'never normal'
    action: (input) ->
      if input
        @string Transforms.titleFirstSentance(input)
      else
        @transformSelectedText('titleFirstSentance')
  'trench':
    grammarType: 'textCapture'
    description: 'space then Sentence case with spaces'
    tags: ['text', 'recommended']
    multiPhraseAutoSpacing: 'never normal'
    action: (input) ->
      if input
        @string ' ' + Transforms.titleFirstSentance(input)
  'datsun':
    grammarType: 'textCapture'
    description: 'Sentence case with spaces'
    tags: ['text', 'recommended']
    autoSpacing: (input) ->
      if input
        'never normal'
      else
        'never never'
    multiPhraseAutoSpacing: (input) ->
      if input
        'never normal'
      else
        'never never'
    action: (input) ->
      if input
        @string '. ' + Transforms.titleFirstSentance(input)
      else
        @string '. '
