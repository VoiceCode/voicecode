pack = Packages.register
  name: 'strict-mode'
  description: 'Temporarily limit the set of commands that can be executed'

# TODO make these identifiers
pack.settings
  modes:
    default: [
      'swick'
      'chiff'
      'chipper'
      'duke'
      'spark'
      'stoosh'
      'dookoosh'
      'doopark'
      'webseek'
      'webs'
      'fox'
    ]
    all: [] # nothing is allowed except disabling strict mode

pack.ready ->
  # make sure every mode allows disabling strick mode
  _.each @settings().modes, (value, name) ->
    value.push 'strict-mode:disable'

pack.commands
  'enable':
    spoken: "strict on"
    grammarType: "textCapture"
    description: "puts VoiceCode into one of the predefined 'strict'
     modes, where only a subset of commands can be executed"
    tags: ["voicecode", "recommended"]
    inputRequired: true
    action: (input) ->
      mode = if input?
        @fuzzyMatchKey pack.settings().modes, input.join(' ')
      else
        "default"
      # TODO move the implementation of this into the package
      @enableStrictMode mode
  'disable':
    spoken: "strict off"
    description: "puts VoiceCode into one of the predefined 'strict'
     modes, where only a subset of commands can be executed"
    tags: ["voicecode", "recommended"]
    action: (input) ->
      @disableStrictMode()
