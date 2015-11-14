pack = Packages.register
  name: 'objective-c'
  description: 'Basic commands for some objective-c formatting'
  tags: ['objective-c']

pack.commands
  'format.NS':
    spoken: 'tennis'
    grammarType: 'textCapture'
    description: 'formats spoken arguments in NSUpperCamelCase (automatically inserts the "NS" part)'
    inputRequired: false
    tags: ['format']
    action: (input) ->
      if input
        @string 'NS' + Transforms.stud(input)
      else
        @string 'NS'
  'format.UI':
    spoken: 'youey'
    grammarType: 'textCapture'
    description: 'formats spoken arguments in UIUpperCamelCase - automatically inserts the "UI" part. (pronounced like U-turn)'
    inputRequired: false
    tags: ['format']
    action: (input) ->
      if input
        @string 'UI' + Transforms.stud(input)
      else
        @string 'UI'
  'format.CG':
    spoken: 'craggle'
    grammarType: 'textCapture'
    description: 'formats spoken arguments in CGUpperCamelCase (automatically inserts the "CG" part)'
    inputRequired: false
    tags: ['format']
    action: (input) ->
      if input
        @string 'CG' + Transforms.stud(input)
      else
        @string 'CG'
  'format.atQuotes':
    spoken: 'lowcoif'
    tags: ['symbol']
    description: "inserts objective-c quotes (@\"\") leaving cursor inside them. If text is selected, will wrap the selected text"
    action: ->
      @string '@""'
      @left()
