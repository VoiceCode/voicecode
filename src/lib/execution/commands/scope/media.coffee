Commands.createDisabledWithDefaults
  tags: ['itunes']
  continuous: false
  needsCommand: false
,
  'media.play.toggle':
    spoken: 'play pause'
    description: 'play or pause the current song in iTunes'
    action: -> @applescript 'tell app "iTunes" to playpause'
  'media.play.next':
    spoken: 'next track'
    description: 'play or pause the current song in iTunes'
    action: -> @applescript 'tell app "iTunes" to play next track'
  'media.play.previous':
    spoken: 'previous track'
    description: 'play or pause the current song in iTunes'
    action: -> @applescript 'tell app "iTunes" to play previous track'
