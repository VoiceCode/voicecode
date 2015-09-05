Commands.createDisabled
  'spark':
    grammarType: 'oneArgument'
    description: 'paste the clipboard (or named item from {stoosh} command)'
    aliases: ['sparked']
    tags: ['clipboard', 'recommended']
    spaceBefore: true
    action: (input) ->
      if input?
        previous = @getStoredItem('clipboard', input)
        if previous?.length
          @setClipboard(previous)
          @delay 50
          @paste()
      else
        @paste()
  'allspark':
    description: 'select all then paste the clipboard'
    tags: ['clipboard', 'selection', 'recommended']
    action: ->
      @selectAll()
      @paste()
  'sparky':
    description: 'paste the alternate clipboard'
    tags: ['clipboard']
    action: ->
      @key 'V', 'command shift'
  'skoopark':
    grammarType: 'oneArgument'
    description: 'insert space then paste the clipboard (or named item from {stoosh} command)'
    tags: ['clipboard', 'recommended']
    action: (input) ->
      @space()
      @do 'spark', input
  'stooshwick':
    description: 'copy whatever is selected then switch applications'
    tags: ['clipboard', 'application', 'system', 'combo', 'recommended']
    action: ->
      @copy()
      @switchApplication()
      @delay 250
  'stoosh':
    grammarType: 'oneArgument'
    description: 'copy whatever is selected (if an argument is given whatever is copied is stored with that name and can be pasted via {spark [name]})'
    tags: ['clipboard', 'recommended']
    action: (input) ->
      @copy()
      if input?
        @waitForClipboard()
        @storeItem 'clipboard', input, @getClipboard()
  'allstoosh':
    description: 'select all then copy whatever is selected'
    tags: ['clipboard', 'selection', 'recommended']
    action: ->
      @selectAll()
      @copy()
  'snatch':
    description: 'cut whatever is selected'
    tags: ['clipboard', 'recommended']
    aliases: ['snatched']
    action: ->
      @cut()
