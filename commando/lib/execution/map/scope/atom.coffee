Commands.createDisabledWithDefaults
    tags: ['atom']
    triggerScopes: ['Atom']
,
  'connector':
    description: 'connect voicecode to atom'
    action: (input) ->
      @openMenuBarPath(['Packages', 'VoiceCode', 'Connect'])
  'projector':
    description: 'switch projects in Atom'
    action: (input) ->
      @runAtomCommand 'trigger', 'project-manager:list-projects'
  'jumpy':
    description: 'open jump-to-symbol dialogue'
    action: (input) ->
      @runAtomCommand 'trigger', 'symbols-view:toggle-file-symbols'
  'marthis':
    description: 'Use the currently selected text as a search term'
    action: ->
      @key 'e', 'command'

Commands.createDisabled
  tradam:
    description: 'open Atom. (this is needed because the regular "fox Atom" always opens a new window)'
    tags: ['atom']
    action: -> @applescript "tell application 'Atom' to activate"
