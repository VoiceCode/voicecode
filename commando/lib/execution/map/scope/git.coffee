git =
  'jet':
    description: 'git'
    action: ->
      @string 'git'
  'jet status':
    description: 'git status'
    action: ->
      @string 'git status'
      switch @currentApplication()
        when 'iTerm', 'Terminal'
          @enter()

  'jet commit':
    description: "git commit -a -m ''"
    autoSpacing: 'normal none'
    action: ->
      @string "git commit -a -m ''"
      @left()

  'jet add': {}
  'jet bisect': {}
  'jet branch': {}
  'jet check out':
    output: 'git checkout'
  'jet clone': {}
  'jet cherry pick':
    output: 'git cherry-pick'
  'jet diff': {}
  'jet fetch': {}
  'jet in it':
    output: 'git init'
  'jet log': {}
  'jet merge': {}
  'jet move':
    output: 'git mv'
  'jet pull': {}
  'jet push': {}
  'jet rebase': {}
  'jet reset': {}
  'jet remove':
    output: 'git rm'
  'jet show': {}
  'jet tag': {}

_.each git, (value, key) ->
  output = value.output or key.replace('jet', 'git')

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
