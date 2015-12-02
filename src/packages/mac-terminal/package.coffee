pack = Packages.register
  name: 'mac-terminal'
  platforms: ['darwin']
  applications: ['com.apple.Terminal']
  description: 'Terminal integration'

Settings.extend "terminalApplications", pack.applications()
Settings.extend "editorApplications", pack.applications()
