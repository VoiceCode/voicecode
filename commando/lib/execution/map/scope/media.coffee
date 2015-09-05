Commands.createDisabledWithDefaults
  tags: ['itunes']
  continuous: false
  needsDragonCommand: false
,
  'play pause':
    description: 'play or pause the current song in iTunes'
    action: -> @applescript 'tell app "iTunes" to playpause'
  'next track':
    description: 'play or pause the current song in iTunes'
    action: -> @applescript 'tell app "iTunes" to play next track'
  'previous track':
    description: 'play or pause the current song in iTunes'
    action: -> @applescript 'tell app "iTunes" to play previous track'
