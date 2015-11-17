Scope.register
  name: 'dragon'
  applications: Settings.dragonApplicationName

pack = Packages.register
  name: 'dragon'
  description: 'Commands for controlling Dragon'

Chain.preprocess 'dragon:consume-after-microphone-sleep', (chain) ->
  index = _.findIndex chain, 'command', 'dragon:microphone-sleep'
  if index isnt -1
    return _.slice chain, 0, ++index
  return chain

pack.settings
  ignoredPhrases: [
    "wakeup"
    "processing document"
    "processing selection"
    "microphone off"
    "go to sleep"
    "show commands"
    "show commands window"
    "hide commands window"
    "hide status window"
    "command mode"
    "press mouse"
    "release mouse"
  ]

# this way the user could change the package settings before the commands are created
# is there a better way?
pack.ready ->
  _.each @settings().ignoredPhrases, (phrase) =>
    id = ['ignored', phrase.split(' ').join('-')].join('.')
    @command id,
      spoken: phrase
      tags: ["ignored"]
      needsCommand: false
      continuous: false

pack.commands
  "microphone-sleep":
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
  "restart":
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

  "train-vocabulary-from-selection":
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

  "show-vocabulary":
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

  "show-commands":
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

  "microphone-off":
    spoken: 'over and out'
    description: "turn the microphone off. This command is nice because it is 'chainable' in a phrase"
    tags: ["dragon", "recommended"]
    action: ->
      @microphoneOff()
