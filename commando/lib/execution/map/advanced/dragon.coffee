Commands.createDisabled
  "sleepy time":
    description: "put dragon into sleep mode"
    tags: ["dragon"]
    action: (input) ->
      dictateName = Settings.localeSettings[Settings.locale].dragonApplicationName or "Dragon Dictate"
      @applescript """
      tell application "#{dictateName}"
        set microphone to sleep
      end tell
      """
  "restart dragon":
    description: "restarts Dragon Dictate"
    tags: ["dragon", "recommended"]
    action: (input) ->
      dictateName = Settings.localeSettings[Settings.locale].dragonApplicationName or "Dragon Dictate"
      @applescript """
      tell application "#{dictateName}" to quit
      delay 2
      tell application "#{dictateName}" to activate
      """
Commands.create
  "wakeup":
    kind: "none"
    description: "wake dragon up if it is sleeping"
    tags: ["dragon"]
    needsDragonCommand: false
    continuous: false
  "processing document":
    kind: "none"
    description: "consume initialization text from dragon"
    tags: ["dragon"]
    needsDragonCommand: false
    continuous: false
  "microphone off":
    kind: "none"
    description: "consume command text from dragon"
    tags: ["dragon"]
    needsDragonCommand: false
    continuous: false
  "go to sleep":
    kind: "none"
    description: "consume command text from dragon"
    tags: ["dragon"]
    needsDragonCommand: false
    continuous: false
      # dictateName = Settings.localeSettings[Settings.locale].dragonApplicationName or "Dragon Dictate"
      # @applescript """
      # tell application "#{dictateName}"
      #   set microphone to command operation
      # end tell
      # """
