Commands.createDisabled
  "sleepy time":
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

  "show dragon vocab":
    description: "switch to Dragon Dictate, and open vocabulary window"
    tags: ["dragon", "recommended"]
    continuous: false
    action: (input) ->
      if Settings.dragonVersion is 5
        console.error "Command not implemented for dragon version 5"
        return
      @openApplication Settings.dragonApplicationName
      @delay 300
      @openMenuBarPath ["Tools", "Vocabulary Editor…"]

  "show dragon commands":
    description: "switch to Dragon Dictate, and open commands window"
    tags: ["dragon", "recommended"]
    continuous: false
    action: (input) ->
      if Settings.dragonVersion is 5
        console.error "Command not implemented for dragon version 5"
        return
      @openApplication Settings.dragonApplicationName
      @delay 300
      @openMenuBarPath ["Tools", "Commands…"]

Commands.createWithDefaults
  kind: "none"
  tags: ["dragon"]
  needsDragonCommand: false
  continuous: false
,
  "wakeup":
    description: "wake dragon up if it is sleeping"
  "processing document":
    description: "consume initialization text from dragon"
  "microphone off":
    description: "consume command text from dragon"
  "go to sleep":
    description: "consume command text from dragon"
  "show commands":
    description: "consume command text from dragon"
  "show commands window":
    description: "consume command text from dragon"
  "hide commands window":
    description: "consume command text from dragon"
  "hide status window":
    description: "consume command text from dragon"
  "command mode":
    description: "consume command text from dragon"

  "press mouse": {}
  "release mouse": {}
