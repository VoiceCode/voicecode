Commands.createDisabled
  'clipboard.paste':
    spoken: 'spark'
    grammarType: 'oneArgument'
    description: 'paste the clipboard (or named item from {stoosh} command)'
    misspellings: ['sparked']
    tags: ['clipboard', 'recommended']
    spaceBefore: true
    inputRequired: false
    action: (input) ->
      if input?
        previous = @getStoredItem('clipboard', input)
        if previous?.length
          @setClipboard(previous)
          @delay 50
          @paste()
      else
        @paste()
  'combo.selectAllThenPaste':
    spoken: 'allspark'
    description: 'select all then paste the clipboard'
    tags: ['clipboard', 'selection', 'recommended']
    action: ->
      @selectAll()
      @paste()
  'clipboard.paste.alternate':
    spoken: 'sparky'
    description: 'paste the alternate clipboard'
    tags: ['clipboard']
    action: ->
      @key 'V', 'command shift'
  'combo.spaceThenPaste':
    spoken: 'skoopark'
    grammarType: 'oneArgument'
    description: 'insert space then paste the clipboard (or named item from {stoosh} command)'
    tags: ['clipboard', 'recommended']
    inputRequired: false
    action: (input) ->
      @space()
      @paste input
  'combo.copySelectionAndSwitchApp':
    spoken: 'stooshwick'
    description: 'copy whatever is selected then switch applications'
    tags: ['clipboard', 'application', 'system', 'combo', 'recommended']
    action: ->
      @copy()
      @switchApplication()
      @delay 250
  'clipboard.copy':
    spoken: 'stoosh'
    grammarType: 'oneArgument'
    description: 'copy whatever is selected (if an argument is given whatever is copied is stored with that name and can be pasted via {spark [name]})'
    tags: ['clipboard', 'recommended']
    inputRequired: false
    action: (input) ->
      @copy()
      if input?
        @waitForClipboard()
        @storeItem 'clipboard', input, @getClipboard()
  'combo.crownSelectAllThenCopy':
    spoken: 'allstoosh'
    description: 'Select all then copy whatever is selected'
    tags: ['clipboard', 'selection', 'recommended']
    action: ->
      @selectAll()
      @copy()
  'clipboard.cut':
    spoken: 'snatch'
    description: 'Cut whatever is selected'
    tags: ['clipboard', 'recommended']
    misspellings: ['snatched']
    action: ->
      @cut()
