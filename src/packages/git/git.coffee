git =
  'git':
    spoken: 'jet'
    description: 'git'
    autoSpacing: 'normal normal'
    multiPhraseAutoSpacing: 'normal normal'
    action: ->
      @string 'git'
  'git.status':
    spoken: 'jet status'
    description: 'git status'
    autoSpacing: 'normal normal'
    multiPhraseAutoSpacing: 'normal normal'
    action: ->
      @string 'git status'

  'git.commit':
    spoken: 'jet commit'
    description: "git commit -a -m ''"
    autoSpacing: 'normal none'
    action: ->
      @string "git commit -a -m ''"
      @left()

  'git.add':
    spoken: 'jet add'
  'git.bisect':
    spoken: 'jet bisect'
  'git.branch':
    spoken: 'jet branch'
  'git.checkout':
    spoken: 'jet check out'
    output: 'git checkout'
  'git.clone':
    spoken: 'jet clone'
  'git.cherry pick':
    spoken: 'jet cherry pick'
    output: 'git cherry-pick'
  'git.diff':
    spoken: 'jet diff'
  'git.fetch':
    spoken: 'jet fetch'
  'git.in it':
    spoken: 'jet in it'
    output: 'git init'
  'git.log':
    spoken: 'jet log'
  'git.merge':
    spoken: 'jet merge'
  'git.move':
    spoken: 'jet move'
    output: 'git mv'
  'git.pull':
    spoken: 'jet pull'
  'git.pull rebase':
    spoken: 'jet pull rebase'
    output: 'git pull --rebase'
  'git.push':
    spoken: 'jet push'
  'git.rebase':
    spoken: 'jet rebase'
  'git.reset':
    spoken: 'jet reset'
  'git.remove':
    spoken: 'jet remove'
    output: 'git rm'
  'git.show':
    spoken: 'jet show'
  'git.tag':
    spoken: 'jet tag'

_.each git, (value, key) ->
  output = value.output or key.replace('.', ' ')

  defaults =
    tags: ['domain-specific', 'git']
    vocabulary: true
    autoSpacing: 'normal always'
    output: output
    description: output
    action: ->
      @string output

  # the defaults are overridden if any option is specified
  Commands.createDisabled key, _.extend(defaults, value)
