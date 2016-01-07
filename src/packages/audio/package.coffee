pack = Packages.register
  name: 'audio'
  description: 'Various audio controls'

pack.commands
  continuous: false
,
  'play-pause':
    spoken: 'play pause'
    description: 'play or pause the current song'
  'next-track':
    spoken: 'next track'
    description: 'proceed to the next song / track'
  'previous-track':
    spoken: 'previous track'
    description: 'go to the previous song / track'
  'set-volume':
    spoken: 'volume'
    grammarType: 'integerCapture'
    description: 'adjust the system volume [0-100]'
    tags: ['system', 'recommended']
    inputRequired: true
  'increase-volume':
    spoken: 'volume plus'
    grammarType: 'integerCapture'
    description: 'increase the system volume by [0-100] (default 10)'
    tags: ['system', 'recommended']
  'decrease-volume':
    spoken: 'volume minus'
    grammarType: 'integerCapture'
    description: 'decrease the system volume by [0-100] (default 10)'
    tags: ['system', 'recommended']
