pack = Packages.register
  name: 'window-manager'
  description: 'Move, resize, switch, and manipulate windows'

pack.commands
  'presets':
    spoken: 'windy'
    grammarType: 'custom'
    rule: '<spoken> (digit)* (windowPosition)*'
    description: 'set the size/position of the frontmost window to one of the preset sizes/positions'
    misspellings: ['wendy']
    tags: ['system', 'window', 'recommended']
    variables:
      digit: -> Settings.digits
      windowPosition: -> Settings.windowPositions
