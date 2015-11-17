pack = Packages.register
  name: 'git'
  description: 'Basic commands for git'
  tags: ['git']

pack.settings
  commands:
    'git':
      spoken: 'jet'
      description: 'git'
      autoSpacing: 'normal normal'
      multiPhraseAutoSpacing: 'normal normal'
      action: ->
        @string 'git'
    'status':
      spoken: 'jet status'
      description: 'git status'
      autoSpacing: 'normal normal'
      multiPhraseAutoSpacing: 'normal normal'
      action: ->
        @string 'git status'

    'commit':
      spoken: 'jet commit'
      description: "git commit -a -m ''"
      autoSpacing: 'normal none'
      action: ->
        @string "git commit -a -m ''"
        @left()

    'add':
      spoken: 'jet add'
    'bisect':
      spoken: 'jet bisect'
    'branch':
      spoken: 'jet branch'
    'checkout':
      spoken: 'jet check out'
      output: 'git checkout'
    'clone':
      spoken: 'jet clone'
    'cherry pick':
      spoken: 'jet cherry pick'
      output: 'git cherry-pick'
    'diff':
      spoken: 'jet diff'
    'fetch':
      spoken: 'jet fetch'
    'in it':
      spoken: 'jet in it'
      output: 'git init'
    'log':
      spoken: 'jet log'
    'merge':
      spoken: 'jet merge'
    'move':
      spoken: 'jet move'
      output: 'git mv'
    'pull':
      spoken: 'jet pull'
    'pull rebase':
      spoken: 'jet pull rebase'
      output: 'git pull --rebase'
    'push':
      spoken: 'jet push'
    'rebase':
      spoken: 'jet rebase'
    'reset':
      spoken: 'jet reset'
    'remove':
      spoken: 'jet remove'
      output: 'git rm'
    'show':
      spoken: 'jet show'
    'tag':
      spoken: 'jet tag'

# pack.ready ->
_.each pack.getSettings().commands, (value, key) ->
  output = value.output or value.spoken

  defaults =
    autoSpacing: 'normal always'
    output: output
    description: output
    action: ->
      @string output

  # the defaults are overridden if any option is specified

  options = {}
  options[key] = _.extend({}, defaults, value)
  pack.commands options
