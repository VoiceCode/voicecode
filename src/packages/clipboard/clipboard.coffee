pack = Packages.register
  name: 'clipboard'
  description: 'Commands for a copy, paste, and other clipboard features'

pack.commands
  'paste':
    spoken: 'spark'
    grammarType: 'oneArgument'
    description: 'paste the clipboard (or named item from {clipboard:copy} command)'
    misspellings: ['sparked']
    tags: ['recommended']
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
  'select-all+paste':
    spoken: 'allspark'
    description: 'select all then paste the clipboard'
    tags: ['selection', 'recommended']
    action: ->
      @selectAll()
      @paste()
  'paste-from-history':
    spoken: 'sparky'
    description: 'paste the alternate clipboard'
    action: ->
      @key 'V', 'command shift'
  'space+paste':
    spoken: 'skoopark'
    grammarType: 'oneArgument'
    description: 'insert space then paste the clipboard (or named item from {stoosh} command)'
    tags: ['recommended']
    action: (input) ->
      @space()
      @paste input
  'copy+switch-application':
    spoken: 'stooshwick'
    description: 'copy whatever is selected then switch applications'
    tags: ['application', 'system', 'combo', 'recommended']
    action: ->
      @copy()
      @switchApplication()
      @delay 250
  'copy':
    spoken: 'stoosh'
    grammarType: 'oneArgument'
    description: 'copy whatever is selected (if an argument is given whatever is copied is stored with that name and can be pasted via {spark [name]})'
    tags: ['recommended']
    action: (input) ->
      @copy()
      if input?
        @waitForClipboard()
        @storeItem 'clipboard', input, @getClipboard()
  'select-all+copy':
    spoken: 'allstoosh'
    description: 'Select all then copy whatever is selected'
    tags: ['selection', 'recommended']
    action: ->
      @selectAll()
      @copy()
  'cut':
    spoken: 'snatch'
    description: 'Cut whatever is selected'
    tags: ['recommended']
    misspellings: ['snatched']
    action: ->
      @cut()
