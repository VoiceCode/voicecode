return unless pack = Packages.get 'darwin'

pack.implement
  'audio:play-pause': ->
    @applescript 'tell app "iTunes" to playpause'
  'audio:next-track': ->
    @applescript 'tell app "iTunes" to play next track'
  'audio:previous-track': ->
    @applescript 'tell app "iTunes" to play previous track'
  'audio:set-volume': (input) ->
    @setVolume(input)
  'audio:increase-volume': (input) ->
    currentVolume = @getCurrentVolume() or 0
    @setVolume currentVolume + (input or 10)
  'audio:decrease-volume': (input) ->
    currentVolume = @getCurrentVolume() or 0
    @setVolume currentVolume - (input or 10)
