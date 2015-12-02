pack = Packages.register
  name: 'format'
  description: 'Text formatting commands for case and spacing'

pack.commands
  'capitalize-next-word':
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
  'camel':
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
  'dot-camel':
    spoken: 'dockram'
    grammarType: 'textCapture'
    description: 'space camelCaseText'
    tags: ['text', 'combo']
    multiPhraseAutoSpacing: 'never normal'
    inputRequired: true
    action: (input) ->
      if input
        @string '.' + Transforms.camel(input)
  'snake':
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
  'colon-snake':
    spoken: 'coalsnik'
    grammarType: 'textCapture'
    description: ':snake_case_with_a_colon_at_the_front'
    tags: ['text', 'combo']
    action: (input) ->
      if input
        @string ':' + Transforms.snake(input)
  'at-sign-camel':
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
  'dollar-camel':
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
  'dashes':
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
  'upper-camel':
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
  'dot-upper-camel':
    spoken: 'dockriffed'
    description: 'space StudCaseText'
    tags: ['text', 'combo']
    grammarType: 'textCapture'
    action: (input) ->
      if input
        @string '.' + Transforms.stud(input)
  'dollar-upper-camel':
    spoken: 'dollkriffed'
    description: 'space StudCaseText'
    tags: ['text', 'combo']
    grammarType: 'textCapture'
    inputRequired: true
    action: (input) ->
      if input
        @string '$' + Transforms.stud(input)
  'lower-no-spaces':
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
  'upper-no-spaces':
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
  'upper':
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
  'upper-snake':
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
  'upper-dashes':
    spoken: 'yellspin'
    grammarType: 'textCapture'
    description: 'UPPER-CASE-SPINE'
    tags: ['text']
    action: (input) ->
      if input
        @string Transforms.upperSpine(input)
      else
        @transformSelectedText('upperSpine')
  'slashes':
    spoken: 'pathway'
    grammarType: 'textCapture'
    description: 'separated/by/slashes'
    tags: ['text']
    action: (input) ->
      if input
        @string Transforms.slashes(input)
      else
        @transformSelectedText('slashes')
  'dots':
    spoken: 'dotsway'
    grammarType: 'textCapture'
    description: 'separated.by.dots'
    tags: ['text']
    action: (input) ->
      if input
        @string Transforms.dots(input)
      else
        @transformSelectedText('dots')
  'title':
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
  'space-sentance':
    spoken: 'trench'
    grammarType: 'textCapture'
    description: 'space then Sentence case with spaces'
    tags: ['text', 'recommended']
    multiPhraseAutoSpacing: 'never normal'
    inputRequired: true
    action: (input) ->
      if input
        @string ' ' + Transforms.titleFirstSentance(input)
  'dot-sentance':
    spoken: 'datsun'
    grammarType: 'textCapture'
    description: 'Period, then space, then Sentence case'
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
  'first-character-from-each-word':
    spoken: 'snitch'
    grammarType: 'textCapture'
    tags: ['text']
    description: 'captures the first letter from each word and joins them'
    inputRequired: true
    action: (input) ->
      if input
        @string Transforms.firstLetters(input)
  'first-three-characters':
    spoken: 'thrack'
    grammarType: 'oneArgument'
    tags: ['text']
    description: 'captures the first 3 letters of the next word spoken'
    inputRequired: true
    action: (input) ->
      if input
        @string Transforms.pluckThree(input)
