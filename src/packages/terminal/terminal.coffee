pack = Packages.register
  name: 'terminal'
  applications: ['com.apple.Terminal']
  description: 'Terminal integration'
  scope: 'terminal'

Settings.extend "terminalApplications", pack.applications()
Settings.extend "editorApplications", pack.applications()
