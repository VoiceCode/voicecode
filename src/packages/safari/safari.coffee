me =
  name: 'safari'
  description: 'Safari integration'
  scope: 'safari'
  applications:
    'com.apple.Safari': 'Safari'

Scope.register me
pack = Packages.register me
Settings.browserApplications.push me.applications

pack.before
  'object.forward': ->
    @key ']', 'command'
    @stop()
  'object.backward': ->
    @key '[', 'command'
    @stop()
  'object.refresh': ->
    @key 'R', 'command'
    @stop()

pack.commands
  'show-tabs':
    spoken: 'show tabs'
    description: 'show all the tabs open in safari'
    action: (input) ->
      @key '\\', 'command shift'

Events.on 'getCurrentBrowserUrl', (container) ->
  if Scope.active me
    container.url = Applescript """
tell application "Safari" to return URL of front document as string
                                """, {async: false}
    container.continue = false
    container
