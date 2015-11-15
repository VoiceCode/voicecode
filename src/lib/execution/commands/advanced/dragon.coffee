Chain.preprocess 'consume-everything-after-microphone-sleep', (chain) ->
  index = _.findIndex chain, 'command', 'dragon.microphone.sleep'
  if index isnt -1
    return _.slice chain, 0, ++index
  return chain

Commands.createDisabled
  "dragon.microphone.sleep":
    spoken: 'snore'
    grammarType: 'textCapture'
    description: "put dragon into sleep mode"
    tags: ["dragon"]
    inputRequired: false
    action: (input) ->
      dictateName = Settings.dragonApplicationName
      @applescript """
      tell application "#{dictateName}"
        set microphone to sleep
      end tell
      """
  "dragon.restart":
    spoken: 'restart dragon'
    description: "restarts Dragon Dictate"
    tags: ["dragon", "recommended"]
    continuous: false
    action: (input) ->
      dictateName = Settings.dragonApplicationName
      # TODO: rewrite, take dragon controller into consideration
      @applescript """
      tell application "#{dictateName}" to quit
      delay 2
      tell application "#{dictateName}" to activate
      """, false

  "dragon.vocabulary.trainFromSelection":
    description: "Train Dragon vocabulary from selection"
    tags: ["dragon", "recommended"]
    continuous: false
    action: (input) ->
      @applescript """
      try
        tell application "Dragon"
          --train vocabulary from selection
          «event DctaVTrn» given «class trno»:«constant CSRpTsSe»
        end tell
      end try
      """, false

  "dragon.vocabulary.showWindow":
    spoken: 'show dragon vocab'
    description: "Open Dragon vocabulary window"
    tags: ["dragon", "recommended"]
    continuous: false
    action: (input) ->
      @applescript """
      try
        tell application "Dragon"
          «event DctaEVob»
        end tell
      end try
      """, false

  "dragon.commands.showWindow":
    spoken: 'show dragon commands'
    description: "switch to Dragon Dictate, and open commands window"
    tags: ["dragon", "recommended"]
    continuous: false
    action: (input) ->
      @applescript """
      try
        tell application "Dragon"
          «event DctaManC»
        end tell
      end try
      """

  "dragon.microphone.off":
    spoken: 'over and out'
    description: "turn the microphone off. This command is nice because it is 'chainable' in a phrase"
    tags: ["dragon", "recommended"]
    action: ->
      @microphoneOff()

Commands.createWithDefaults
  kind: "none"
  tags: ["ignored"]
  needsCommand: false
  continuous: false
,
  # consume command text from dragon growl notifications
  "wakeup": {}
  "processing document": {}
  "processing selection": {}
  "microphone off": {}
  "go to sleep": {}
  "show commands": {}
  "show commands window": {}
  "hide commands window": {}
  "hide status window": {}
  "command mode": {}
  "press mouse": {}
  "release mouse": {}
