pack = Packages.register
  name: 'os'
  description: 'Operating System'


pack.actions
  string: (string) ->
    @do 'os:string', string
  key: (key, modifiers = null) ->
    @do 'os:key', {key, modifiers}

pack.commands
  'string':
    needsCommand: false
    needsParsing: false
  'key':
    needsCommand: false
    needsParsing: false
