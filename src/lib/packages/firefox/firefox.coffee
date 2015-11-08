# 'package' is a reserved javascript word :(

# thinking packages should look something like this

# instance = Packages.create
#   name: 'firefox'
#   description: 'Firefox integration'
#   triggerScopes: ['Firefox']
#
# instance.before
#   'object.forwards': (input, context) ->
#     @key ']', 'command'
#     # thinking @stop() should be the default, and you have to @continue() to not cancel the chain
#     @stop()
#   'object.backwards': (input, context) ->
#     @key '[', 'command'
#     @stop()
#   'object.refresh': (input, context) ->
#     @key 'R', 'command'
#     @stop()
#
# instance.create
#   # the instance should automatically add its package name at the beginning of all commands it creates
#   'show-inspector':
#     spoken: "inspector"
#     action: ->
#       # do something

packageInfo =
  name: 'firefox'
  description: 'Firefox integration'
  triggerScopes: ['Firefox']

Commands.before 'object.forwards', packageInfo, (input, context) ->
  @key ']', 'command'
  @stop()

Commands.before 'object.backwards', packageInfo, (input, context) ->
  @key '[', 'command'
  @stop()

Commands.before 'object.refresh', packageInfo, (input, context) ->
  @key 'R', 'command'
  @stop()
