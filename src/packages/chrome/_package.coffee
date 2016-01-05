pack = Packages.register
  name: 'chrome'
  applications: ['com.google.Chrome', 'com.google.Chrome.canary']
  description: 'Google Chrome integration'

Settings.extend 'browserApplications', pack.applications()

pack.implement
  'object.refresh': ->
    @key 'R', 'command'
  'object.forward': ->
    @key ']', 'command'
  'object.backward': ->
    @key '[', 'command'

Events.on 'getCurrentBrowserUrl', (container={}) ->
  if Scope.active 'chrome'
    container.url = if not Settings.smartBrowsersUsed
      Applescript """
        tell application "Google Chrome" to get URL of active tab of first window
      """, true
    else
      # TODO: smart browser magic
    container.continue = false
    container
