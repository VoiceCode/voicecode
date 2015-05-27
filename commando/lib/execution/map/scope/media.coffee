itunesCommands =
  "play pause":
    description: "play or pause the current song in iTunes"
    script: 'tell app "iTunes" to playpause'
  "next track":
    description: "play or pause the current song in iTunes"
    script: 'tell app "iTunes" to play next track'
  "previous track":
    description: "play or pause the current song in iTunes"
    script: 'tell app "iTunes" to play previous track'

_.each itunesCommands, (options, name) ->
  Commands.createDisabled name,
    description: options.description
    tags: ["itunes"]
    continuous: false
    needsDragonCommand: false
    action: -> @applescript options.script
