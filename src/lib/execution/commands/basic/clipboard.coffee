Commands.createDisabled
  'core.clipboard.paste':
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
  'core.combo[select.all,clipboard.paste]':
    spoken: 'allspark'
    description: 'select all then paste the clipboard'
    tags: ['clipboard', 'selection', 'recommended']
    action: ->
      @selectAll()
      @paste()
  'core.clipboard.paste.alternate':
    spoken: 'sparky'
    description: 'paste the alternate clipboard'
    tags: ['clipboard']
    action: ->
      @key 'V', 'command shift'
  'core.combo[symbol.space,clipboard.paste]':
    spoken: 'skoopark'
    grammarType: 'oneArgument'
    description: 'insert space then paste the clipboard (or named item from {stoosh} command)'
    tags: ['clipboard', 'recommended']
    inputRequired: false
    action: (input) ->
      @space()
      @paste input
  'core.combo[clipboard.copy,appControl.switchToPrevious]':
    spoken: 'stooshwick'
    description: 'copy whatever is selected then switch applications'
    tags: ['clipboard', 'application', 'system', 'combo', 'recommended']
    action: ->
      @copy()
      @switchApplication()
      @delay 250
  'core.clipboard.copy':
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
  'core.combo[select.all,clipboard.copy]':
    spoken: 'allstoosh'
    description: 'Select all then copy whatever is selected'
    tags: ['clipboard', 'selection', 'recommended']
    action: ->
      @selectAll()
      @copy()
  'core.clipboard.cut':
    spoken: 'snatch'
    description: 'Cut whatever is selected'
    tags: ['clipboard', 'recommended']
    misspellings: ['snatched']
    action: ->
      @cut()
