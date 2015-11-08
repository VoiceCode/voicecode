# TODO how should package info look for creating commands (as opposed to extending them)

# packageInfo =
#   name: 'itunes'
#   description: 'Basic iTunes music control'
#   tags: ['itunes']

Commands.createDisabledWithDefaults
  tags: ['itunes']
  continuous: false
  needsCommand: false
,
  'itunes.play-pause':
    'play pause'
    description: 'play or pause the current song in iTunes'
    action: -> @applescript 'tell app "iTunes" to playpause'
  'itunes.next-track':
    'next track'
    description: 'play or pause the current song in iTunes'
    action: -> @applescript 'tell app "iTunes" to play next track'
  'itunes.previous-track':
    'previous track'
    description: 'play or pause the current song in iTunes'
    action: -> @applescript 'tell app "iTunes" to play previous track'
