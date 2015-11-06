Commands.createDisabled
  'core.object.next':
    spoken: 'goneck'
    description: 'go to next thing (application-specific), tab, message, etc.'
    tags: ['recommended', 'navigation']
    repeatable: true
    action: ->
      @key ']', 'command shift'
  'core.object.previous':
    spoken: 'gopreev'
    description: 'go to previous thing (application-specific), tab, message, etc.'
    tags: ['recommended', 'navigation']
    repeatable: true
    action: ->
      @key '[', 'command shift'
  'core.object.backwards':
    spoken: 'baxley'
    description: 'go "back" - whatever that might mean in context'
    tags: ['recommended', 'navigation']
    repeatable: true
    action: ->
      null
  'core.object.forwards':
    spoken: 'fourthly'
    description: 'go "forward" - whatever that might mean in context'
    tags: ['recommended', 'navigation']
    repeatable: true
    action: ->
      null

  'core.object.refresh':
    spoken: 'freshly'
    description: 'reload or refresh depending on context'
    tags: ['recommended', 'navigation']
    action: ->
      null
  'core.combo.downArrowsAndEnter':
    spoken: 'cheese'
    description: 'presses the down arrow [x] times then presses return (for choosing items from lists that don\'t have direct shortcuts)'
    tags: ['navigation']
    grammarType: 'numberCapture'
    inputRequired: false
    action: (input) ->
      @down input or 1
      @enter()
