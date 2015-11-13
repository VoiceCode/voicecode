Commands.createDisabled
  'text.format.objective-cNS':
    spoken: 'tennis'
    grammarType: 'textCapture'
    description: 'formats spoken arguments in NSUpperCamelCase (automatically inserts the "NS" part)'
    tags: ['text', 'objective-c', 'domain-specific']
    inputRequired: false
    action: (input) ->
      if input
        @string 'NS' + Transforms.stud(input)
      else
        @string 'NS'
  'text.format.objective-cUI':
    spoken: 'youey'
    grammarType: 'textCapture'
    description: 'formats spoken arguments in UIUpperCamelCase - automatically inserts the "UI" part. (pronounced like U-turn)'
    tags: ['text', 'objective-c', 'domain-specific']
    inputRequired: false
    action: (input) ->
      if input
        @string 'UI' + Transforms.stud(input)
      else
        @string 'UI'
  'text.format.objective-cCG':
    spoken: 'craggle'
    grammarType: 'textCapture'
    description: 'formats spoken arguments in CGUpperCamelCase (automatically inserts the "CG" part)'
    tags: ['text', 'objective-c', 'domain-specific']
    inputRequired: false
    action: (input) ->
      if input
        @string 'CG' + Transforms.stud(input)
      else
        @string 'CG'
  'text.format.objective-cAtQuotes':
    spoken: 'lowcoif'
    tags: ['symbol', 'quotes', 'objective-c', 'domain-specific']
    description: "inserts objective-c quotes (@\"\") leaving cursor inside them. If text is selected, will wrap the selected text"
    action: ->
      @string '@""'
      @left()
