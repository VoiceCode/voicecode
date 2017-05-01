electron = require 'electron'

template = [
  {
    label: 'File'
    submenu: [
      {
        label: 'Print...'
        click: -> emit 'printCurrentWindow'
        accelerator: 'CmdOrCtrl+P'
      }
    ]
  },
  {
    label: 'Edit'
    submenu: [
      # { role: 'undo' }
      # { role: 'redo' }
      # { type: 'separator' }
      { role: 'cut' }
      { role: 'copy' }
      { role: 'paste' }
      { role: 'selectall' }
    ]
  },
  {
    label: 'View'
    submenu: [
      { role: 'toggledevtools' }
      { type: 'separator' }
      { role: 'resetzoom' }
      { role: 'zoomin' }
      { role: 'zoomout' }
      { type: 'separator' }
      { role: 'togglefullscreen' }
    ]
  },
  {
    role: 'window'
    submenu: [
      { role: 'minimize' }
      { role: 'close' }
    ]
  },
  {
    role: 'help'
    submenu: [
      {
        label: 'Learn More'
        click: -> electron.shell.openExternal('http://voicecode.io/docs')
      }
    ]
  }
]

if process.platform is 'darwin'
  template.unshift({
    label: electron.app.getName(),
    submenu: [
      { role: 'about' }
      { type: 'separator' }
      { role: 'services', submenu: [] }
      { type: 'separator' }
      { role: 'hide' }
      { role: 'hideothers' }
      { role: 'unhide' }
      { type: 'separator' }
      { role: 'quit' }
    ]
  })
  # Window menu.
  template[4].submenu = [
    {
      label: 'Close'
      accelerator: 'CmdOrCtrl+W'
      role: 'close'
    },
    {
      label: 'Minimize'
      accelerator: 'CmdOrCtrl+M'
      role: 'minimize'
    },
    {
      label: 'Zoom'
      role: 'zoom'
    },
    {
      type: 'separator'
    },
    {
      label: 'Bring All to Front'
      role: 'front'
    }
  ]

menu = electron.Menu.buildFromTemplate(template)
electron.Menu.setApplicationMenu(menu)
