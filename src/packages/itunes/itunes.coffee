Context.register
  name: 'itunes'
  applications: ['iTunes']

pack = Packages.register
  name: 'itunes'
  description: 'Basic iTunes music control'
  tags: ['itunes']
  context: 'itunes'

pack.commands
  context: 'global'
  continuous: false
,
  'itunes.play-pause':
    spoken: 'play pause'
    description: 'play or pause the current song'
    action: -> @applescript 'tell app "iTunes" to playpause'
  'itunes.next-track':
    spoken: 'next track'
    description: 'proceed to the next song / track'
    action: -> @applescript 'tell app "iTunes" to play next track'
  'itunes.previous-track':
    spoken: 'previous track'
    description: 'go to the previous song / track'
    action: -> @applescript 'tell app "iTunes" to play previous track'
