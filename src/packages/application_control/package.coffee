pack = Packages.register
  name: 'application-control'
  description: 'Application Control'

pack.commands
  'previous.application':
    spoken: 'swick'
    description: 'Switch to most recent application'
    tags: ['application', 'tab', 'recommended']
    bypassHistory: true
  'open.launcher':
    spoken: 'launcher'
    description: 'Open application launcher'
    tags: ['application', 'system', 'launching', 'alfred']
  'open.preferences':
    spoken: 'prefies'
    description: 'Open application preferences'
    tags: ['application', 'system']
  'open.search':
    spoken: 'spotty'
    description: 'open spotlight'
    tags: ['application', 'system', 'launching']
  'open.application-switcher':
    spoken: 'foxwitch'
    description: 'open application switcher'
    tags: ['application', 'system', 'launching', 'tab', 'recommended']
  'open.browser':
    spoken: 'webseek'
    description: 'open a new browser tab (from anywhere)'
    tags: ['system', 'launching', 'recommended']
  'open.application':
    spoken: 'fox'
    description: 'open application'
    tags: ['application', 'system', 'launching', 'recommended']
    grammarType: 'custom'
    rule: '<spoken> (application)'
    variables:
      application: -> Settings.applications
  'next.window':
    spoken: 'gibby'
    description: 'Switch to next window in same application'
    tags: ['application', 'window', 'recommended']
    repeatable: true
  'previous.window':
    spoken: 'shibby'
    description: 'Switch to previous window in same application'
    tags: ['application', 'window', 'recommended']
    repeatable: true

require "./#{global.platform}"
