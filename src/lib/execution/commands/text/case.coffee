Commands.createDisabledWithDefaults {inputRequired: false},
  'text.literal':
    spoken: 'vc-literal'
    grammarType: 'none'
    description: 'words with spaces between. This command is for internal grammar use (not spoken)'
    tags: ['text', 'recommended']
    needsCommand: false
    isSpoken: false
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
  'text.capitalize.next':
    spoken: 'champ'
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
  'text.camel':
    spoken: 'cram'
    grammarType: 'textCapture'
    description: 'camelCaseText'
    tags: ['text', 'recommended']
    misspellings: ['crammed', 'crams', 'tram', 'kram']
    spaceBefore: true
    autoSpacing: (input) ->
      if input then 'normal normal'
    multiPhraseAutoSpacing: (input) ->
      if input then 'normal normal'
    action: (input) ->
      if input
        @string Transforms.camel(input)
      else
        @transformSelectedText('camel')
  'combo.spaceThenTextCamel':
    spoken: 'dockram'
    grammarType: 'textCapture'
    description: 'space camelCaseText'
    tags: ['text', 'combo']
    multiPhraseAutoSpacing: 'never normal'
    inputRequired: true
    action: (input) ->
      if input
        @string '.' + Transforms.camel(input)
  'text.snake':
    spoken: 'snake'
    grammarType: 'textCapture'
    description: 'snake_case_text'
    tags: ['text', 'recommended']
    spaceBefore: true
    autoSpacing: (input) ->
      if input then 'normal normal'
    multiPhraseAutoSpacing: (input) ->
      if input then 'normal normal'
    action: (input) ->
      if input
        @string Transforms.snake(input)
      else
        @transformSelectedText('snake')
  'combo.colonThenTextSnake':
    spoken: 'coalsnik'
    grammarType: 'textCapture'
    description: ':snake_case_with_a_colon_at_the_front'
    tags: ['text', 'combo']
    action: (input) ->
      if input
        @string ':' + Transforms.snake(input)
  'combo.atThenTextCamel':
    spoken: 'lowcram'
    grammarType: 'textCapture'
    description: '@camelCaseWithAtSign'
    tags: ['text', 'combo']
    spaceBefore: true
    action: (input) ->
      if input
        @string '@' + Transforms.camel(input)
      else
        @string '@'
  'combo.dollarThenTextCamel':
    spoken: 'dollcram'
    grammarType: 'textCapture'
    description: '$camelCaseWithDollarSign'
    tags: ['text']
    spaceBefore: true
    action: (input) ->
      if input
        @string '$' + Transforms.camel(input)
      else
        @string '$'
  'text.spine':
    spoken: 'spine'
    grammarType: 'textCapture'
    description: 'spinal-case-text'
    misspellings: ['spying']
    tags: ['text', 'recommended']
    spaceBefore: true
    autoSpacing: (input) ->
      if input then 'normal normal'
    multiPhraseAutoSpacing: (input) ->
      if input then 'normal normal'
    action: (input) ->
      if input
        @string Transforms.spine(input)
      else
        @transformSelectedText('spine')
  'text.stud':
    spoken: 'criffed'
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
  'combo.spaceThenTextStud':
    spoken: 'dockriffed'
    description: 'space StudCaseText'
    tags: ['text', 'combo']
    grammarType: 'textCapture'
    action: (input) ->
      if input
        @string '.' + Transforms.stud(input)
  'combo.dollarThenTextStud':
    spoken: 'dollkriffed'
    description: 'space StudCaseText'
    tags: ['text', 'combo']
    grammarType: 'textCapture'
    inputRequired: true
    action: (input) ->
      if input
        @string '$' + Transforms.stud(input)
  'text.lowerCaseNoSpace':
    spoken: 'smash'
    grammarType: 'textCapture'
    description: 'lowercasewithnospaces'
    tags: ['text', 'recommended']
    spaceBefore: true
    action: (input) ->
      if input
        @string Transforms.lowerSlam(input)
      else
        @transformSelectedText('lowerSlam')
  'text.upperCaseNoSpace':
    spoken: 'yellsmash'
    grammarType: 'textCapture'
    description: 'UPPERCASEWITHNOSPACES'
    tags: ['text']
    spaceBefore: true
    action: (input) ->
      if input
        @string Transforms.upperSlam(input)
      else
        @transformSelectedText('upperSlam')
  'text.upper':
    spoken: 'yeller'
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
  'text.upperSnake':
    spoken: 'yellsnik'
    grammarType: 'textCapture'
    description: 'UPPER_CASE_SNAKE'
    tags: ['text']
    spaceBefore: true
    action: (input) ->
      if input
        @string Transforms.upperSnake(input)
      else
        @transformSelectedText('upperSnake')
  'text.upperSpine':
    spoken: 'yellspin'
    grammarType: 'textCapture'
    description: 'UPPER-CASE-SPINE'
    tags: ['text']
    action: (input) ->
      if input
        @string Transforms.upperSpine(input)
      else
        @transformSelectedText('upperSpine')
  'text.pathway':
    spoken: 'pathway'
    grammarType: 'textCapture'
    description: 'separated/by/slashes'
    tags: ['text']
    action: (input) ->
      if input
        @string Transforms.slashes(input)
      else
        @transformSelectedText('slashes')
  'text.dotsway':
    spoken: 'dotsway'
    grammarType: 'textCapture'
    description: 'separated.by.dots'
    tags: ['text']
    action: (input) ->
      if input
        @string Transforms.dots(input)
      else
        @transformSelectedText('dots')
  'text.capitalize.all':
    spoken: 'tridal'
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
  # '':
  #   spoken: 'senchen'
  #   grammarType: 'textCapture'
  #   description: 'Sentence case with spaces'
  #   tags: ['text', 'recommended']
  #   spaceBefore: true
  #   autoSpacing: 'never normal'
  #   multiPhraseAutoSpacing: 'never normal'
  #   action: (input) ->
  #     if input
  #       @string Transforms.titleFirstSentance(input)
  #     else
  #       @transformSelectedText('titleFirstSentance')
  'combo.spaceThenCapitalizeFirst':
    spoken: 'trench'
    grammarType: 'textCapture'
    description: 'space then Sentence case with spaces'
    tags: ['text', 'recommended']
    multiPhraseAutoSpacing: 'never normal'
    inputRequired: true
    action: (input) ->
      if input
        @string ' ' + Transforms.titleFirstSentance(input)
  'combo.spaceThenCapitalizeFirst_':
    spoken: 'datsun'
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
