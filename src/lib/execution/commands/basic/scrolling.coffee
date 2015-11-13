Commands.createDisabledWithDefaults {inputRequired: false},
  'scroll.up.page':
    spoken: 'page up'
    description: 'press PageUp key [N] times'
    grammarType: 'integerCapture'
    tags: ['scroll', 'up', 'recommended']
    continuous: false
    action: (input) ->
      @repeat input or 1, =>
        @key 'pageup'
        @delay 200
  'scroll.down.page':
    spoken: 'page down'
    description: 'press PageDown key [N] times'
    grammarType: 'integerCapture'
    tags: ['scroll', 'down', 'recommended']
    continuous: false
    action: (input) ->
      @repeat input or 1, =>
        @key 'pagedown'
        @delay 200
  'scroll.down':
    spoken: 'scrodge'
    description: 'scroll down'
    grammarType: 'integerCapture'
    tags: ['scroll', 'down', 'recommended']
    action: (input) ->
      @scrollDown(input or 10)
  'scroll.up':
    spoken: 'scroop'
    description: 'scroll up'
    grammarType: 'integerCapture'
    tags: ['scroll', 'up', 'recommended']
    action: (input) ->
      @scrollUp(input or 10)
  'scroll.way.down':
    spoken: 'scrodgeway'
    description: 'scroll way down'
    tags: ['scroll', 'down', 'recommended']
    action: (input) ->
      @scrollDown(999)
  'scroll.way.up':
    spoken: 'scroopway'
    description: 'scroll way up'
    tags: ['scroll', 'up', 'recommended']
    action: (input) ->
      @scrollUp(999)
  'scroll.right':
    spoken: 'sweeper'
    description: 'scroll right'
    grammarType: 'integerCapture'
    tags: ['scroll', 'right']
    action: (input) ->
      @scrollRight(input or 1)
  'scroll.left':
    spoken: 'sweeple'
    description: 'scroll left'
    grammarType: 'integerCapture'
    tags: ['scroll', 'left']
    action: (input) ->
      @scrollLeft(input or 1)
