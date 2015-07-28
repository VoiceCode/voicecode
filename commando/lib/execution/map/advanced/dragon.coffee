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
      """, false

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
  "press mouse": {}
  "release mouse": {}
