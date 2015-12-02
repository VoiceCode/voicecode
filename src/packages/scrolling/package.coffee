pack = Packages.register
  name: 'scrolling'
  description: 'Various commands for scrolling / swiping'

pack.commands
  'page-up':
    spoken: 'page up'
    description: 'press PageUp key [N] times'
    grammarType: 'integerCapture'
    tags: ['up', 'recommended']
    continuous: false
    action: (input) ->
      @repeat input or 1, =>
        @key 'pageup'
        @delay 200
  'page-down':
    spoken: 'page down'
    description: 'press PageDown key [N] times'
    grammarType: 'integerCapture'
    tags: ['down', 'recommended']
    continuous: false
    action: (input) ->
      @repeat input or 1, =>
        @key 'pagedown'
        @delay 200
  'down':
    spoken: 'scrodge'
    description: 'scroll down'
    grammarType: 'integerCapture'
    tags: ['down', 'recommended']
    action: (input) ->
      @scrollDown(input or 10)
  'up':
    spoken: 'scroop'
    description: 'scroll up'
    grammarType: 'integerCapture'
    tags: ['up', 'recommended']
    action: (input) ->
      @scrollUp(input or 10)
  'way-down':
    spoken: 'scrodgeway'
    description: 'scroll way down'
    tags: ['down', 'recommended']
    action: (input) ->
      @scrollDown(999)
  'way-up':
    spoken: 'scroopway'
    description: 'scroll way up'
    tags: ['up', 'recommended']
    action: (input) ->
      @scrollUp(999)
  'right':
    spoken: 'sweeper'
    description: 'scroll right'
    grammarType: 'integerCapture'
    tags: ['right']
    action: (input) ->
      @scrollRight(input or 1)
  'left':
    spoken: 'sweeple'
    description: 'scroll left'
    grammarType: 'integerCapture'
    tags: ['left']
    action: (input) ->
      @scrollLeft(input or 1)
