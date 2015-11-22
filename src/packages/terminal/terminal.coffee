me =
  name: 'terminal'
  applications:
    'com.apple.Terminal': 'Terminal'
  description: 'Terminal integration'
  scope: 'terminal'

Settings.terminalApplications.push me.applications
Settings.editorApplications.push me.applications

Scope.register me
pack = Packages.register me
