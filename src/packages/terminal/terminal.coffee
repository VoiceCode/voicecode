pack = Packages.register
  name: 'terminal'
  applications: ['com.apple.Terminal']
  description: 'Terminal integration'
  createScope: true

Settings.extend "terminalApplications", pack.applications()
Settings.extend "editorApplications", pack.applications()
