Commands.createDisabled
  "snore":
    grammarType: 'textCapture'
    description: "put dragon into sleep mode"
    tags: ["dragon"]
    action: (input) ->
      dictateName = Settings.dragonApplicationName
      @applescript """
      tell application "#{dictateName}"
        set microphone to sleep
      end tell
      """
  "restart dragon":
    description: "restarts Dragon Dictate"
    tags: ["dragon", "recommended"]
    continuous: false
    action: (input) ->
      dictateName = Settings.dragonApplicationName
      @applescript """
      tell application "#{dictateName}" to quit
      delay 2
      tell application "#{dictateName}" to activate
      """, false

  "dragtrain":
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

  "show dragon vocab":
    description: "switch to Dragon Dictate, and open vocabulary window"
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

  "show dragon commands":
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
      
  "over and out":
    description: "turn the microphone off. This command is nice because it is 'chainable' in a phrase"
    tags: ["dragon", "recommended"]
    action: ->
      @microphoneOff()

Commands.createWithDefaults
  kind: "none"
  tags: ["ignored"]
  needsDragonCommand: false
  continuous: false
  isSpoken: false
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
