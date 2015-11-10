Commands.createDisabled
  'object.next':
    spoken: 'goneck'
    description: 'Go to next thing (application-specific), tab, message, etc.'
    tags: ['recommended', 'navigation']
    repeatable: true
    action: ->
      @key ']', 'command shift'
  'object.previous':
    spoken: 'gopreev'
    description: 'Go to previous thing (application-specific), tab, message, etc.'
    tags: ['recommended', 'navigation']
    repeatable: true
    action: ->
      @key '[', 'command shift'
  'object.backward':
    spoken: 'baxley'
    description: 'Go "back" - whatever that might mean in context'
    tags: ['recommended', 'navigation']
    repeatable: true
    action: ->
      null
  'object.forward':
    spoken: 'fourthly'
    description: 'Go "forward" - whatever that might mean in context'
    tags: ['recommended', 'navigation']
    repeatable: true
    action: ->
      null

  'object.refresh':
    spoken: 'freshly'
    description: 'Reload or refresh depending on context'
    tags: ['recommended', 'navigation']
    action: ->
      null
  'combo.downArrowsAndEnter':
    spoken: 'cheese'
    description: 'Presses the down arrow [x] times then presses return (for choosing items from lists that don\'t have direct shortcuts)'
    tags: ['navigation']
    grammarType: 'integerCapture'
    inputRequired: false
    action: (input) ->
      @down input or 1
      @enter()
