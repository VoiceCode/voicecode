Commands.createDisabled
  'tennis':
    grammarType: 'textCapture'
    description: 'formats spoken arguments in NSUpperCamelCase (automatically inserts the "NS" part)'
    tags: ['text', 'objective-c', 'domain-specific']
    inputRequired: true
    action: (input) ->
      if input
        @string 'NS' + Transforms.stud(input)
      else
        @string 'NS'
  'youey':
    grammarType: 'textCapture'
    description: 'formats spoken arguments in UIUpperCamelCase - automatically inserts the "UI" part. (pronounced like U-turn)'
    tags: ['text', 'objective-c', 'domain-specific']
    action: (input) ->
      if input
        @string 'UI' + Transforms.stud(input)
      else
        @string 'UI'
  'craggle':
    grammarType: 'textCapture'
    description: 'formats spoken arguments in CGUpperCamelCase (automatically inserts the "CG" part)'
    tags: ['text', 'objective-c', 'domain-specific']
    action: (input) ->
      if input
        @string 'CG' + Transforms.stud(input)
      else
        @string 'CG'
  'lowcoif':
    kind: 'action'
    grammarType: 'individual'
    tags: ['symbol', 'quotes', 'objective-c', 'domain-specific']
    description: "inserts objective-c quotes (@\"\") leaving cursor inside them. If text is selected, will wrap the selected text"
    action: ->
      @string '@""'
      @left()
