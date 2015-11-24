pack = Packages.register
  name: 'firefox'
  applications: ['org.mozilla.firefox']
  description: 'Firefox integration'
  createScope: true

Settings.extend 'browserApplications', pack.applications()

pack.before
  'object.forward': (input, context) ->
    @key ']', 'command'
  'object.backward': (input, context) ->
    @key '[', 'command'
  'object.refresh': (input, context) ->
    @key 'R', 'command'
