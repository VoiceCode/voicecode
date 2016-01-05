pack = Packages.register
  name: 'object'
  description: 'Abstract commands implemented by
   other packages depending on context'

pack.commands
  'next':
    spoken: 'goneck'
    description: 'Go to next thing
     (application-specific), tab, message, etc.'
    tags: ['recommended', 'navigation']
    repeatable: true
    action: ->
      @key ']', 'command shift'
  'previous':
    spoken: 'gopreev'
    description: 'Go to previous thing
     (application-specific), tab, message, etc.'
    tags: ['recommended', 'navigation']
    repeatable: true
    action: ->
      @key '[', 'command shift'
  'backward':
    spoken: 'baxley'
    description: 'Go "back" - whatever that might mean in context'
    tags: ['recommended', 'navigation']
    repeatable: true
  'forward':
    spoken: 'fourthly'
    description: 'Go "forward" - whatever that might mean in context'
    tags: ['recommended', 'navigation']
    repeatable: true
  'refresh':
    spoken: 'freshly'
    description: 'Reload or refresh depending on context'
    tags: ['recommended', 'navigation']
