Settings.terminalApplications.push 'Terminal'
Settings.editorApplications.push 'Terminal'
Scope.register
  name: 'terminal'
  applications: ['Terminal']

pack = Packages.register
  name: 'terminal'
  description: 'Terminal integration'
  scope: 'terminal'
