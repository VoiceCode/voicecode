Settings.browserApplications.push 'Google Chrome'
me =
  name: 'chrome'
  applications: ['Google Chrome']
  description: 'Google Chrome integration'
  scope: 'chrome'

Scope.register me
pack = Packages.register me

pack.before
  'object.refresh': ->
    @key 'R', 'command'
    @stop()
  'object.forward': ->
    @key ']', 'command'
    @stop()
  'object.backward': ->
    @key '[', 'command'
    @stop()

Events.on 'getCurrentBrowserUrl', (container) ->
  if Scope.active me
    container.url = if not Settings.smartBrowsersUsed
      Applescript """
tell application "Google Chrome" to get URL of active tab of first window
                  """, {async: false}
    else
      # TODO: smart browser magic
    container.continue = false
    container
