var app       = require('app');
var dialog = require('dialog');
var BrowserWindow   = require('browser-window');
var Menu = require('menu');
var electrify = require('electrify');


var window    = null;

app.on('ready', function() {

  window = new BrowserWindow({
    width: 1200,
    height: 900,
    'node-integration': false
  });
  
  electrify.boot(function() {
    window.loadUrl(electrify.meteor_url);
  });

});


app.on('will-quit', function(event) {
  electrify.shutdown(app, event);
});

app.on('window-all-closed', function() {
  app.quit();
});

// Create default menu.
app.once('ready', function() {
  if (Menu.getApplicationMenu())
    return;

  var template;
  if (process.platform == 'darwin') {
    template = [
      {
        label: 'VoiceCode',
        submenu: [
          {
            label: 'About VoiceCode',
            selector: 'orderFrontStandardAboutPanel:'
          },
          {
            type: 'separator'
          },
          {
            label: 'Services',
            submenu: []
          },
          {
            type: 'separator'
          },
          {
            label: 'Hide VoiceCode',
            accelerator: 'Command+H',
            selector: 'hide:'
          },
          {
            label: 'Hide Others',
            accelerator: 'Command+Shift+H',
            selector: 'hideOtherApplications:'
          },
          {
            label: 'Show All',
            selector: 'unhideAllApplications:'
          },
          {
            type: 'separator'
          },
          {
            label: 'Quit',
            accelerator: 'Command+Q',
            click: function() { app.quit(); }
          },
        ]
      },
      {
        label: 'Edit',
        submenu: [
          {
            label: 'Undo',
            accelerator: 'Command+Z',
            selector: 'undo:'
          },
          {
            label: 'Redo',
            accelerator: 'Shift+Command+Z',
            selector: 'redo:'
          },
          {
            type: 'separator'
          },
          {
            label: 'Cut',
            accelerator: 'Command+X',
            selector: 'cut:'
          },
          {
            label: 'Copy',
            accelerator: 'Command+C',
            selector: 'copy:'
          },
          {
            label: 'Paste',
            accelerator: 'Command+V',
            selector: 'paste:'
          },
          {
            label: 'Select All',
            accelerator: 'Command+A',
            selector: 'selectAll:'
          },
        ]
      },
      {
        label: 'View',
        submenu: [
          {
            label: 'Reload',
            accelerator: 'Command+R',
            click: function() {
              var focusedWindow = BrowserWindow.getFocusedWindow();
              if (focusedWindow)
                focusedWindow.reload();
            }
          },
          {
            label: 'Toggle Full Screen',
            accelerator: 'Ctrl+Command+F',
            click: function() {
              var focusedWindow = BrowserWindow.getFocusedWindow();
              if (focusedWindow)
                focusedWindow.setFullScreen(!focusedWindow.isFullScreen());
            }
          },
          {
            label: 'Toggle Developer Tools',
            accelerator: 'Alt+Command+I',
            click: function() {
              var focusedWindow = BrowserWindow.getFocusedWindow();
              if (focusedWindow)
                focusedWindow.toggleDevTools();
            }
          },
          {
            label: 'Stuff',
            click: function() {
              console.log("clicked it yo");
            }
          },
        ]
      },
      {
        label: 'Window',
        submenu: [
          {
            label: 'Minimize',
            accelerator: 'Command+M',
            selector: 'performMiniaturize:'
          },
          {
            label: 'Close',
            accelerator: 'Command+W',
            selector: 'performClose:'
          },
          {
            type: 'separator'
          },
          {
            label: 'Bring All to Front',
            selector: 'arrangeInFront:'
          },
        ]
      },
      {
        label: 'Help',
        submenu: [
          {
            label: 'Learn More',
            click: function() { require('shell').openExternal('http://electron.atom.io') }
          },
          {
            label: 'Documentation',
            click: function() { require('shell').openExternal('https://github.com/atom/electron/tree/master/docs#readme') }
          },
          {
            label: 'Community Discussions',
            click: function() { require('shell').openExternal('https://discuss.atom.io/c/electron') }
          },
          {
            label: 'Search Issues',
            click: function() { require('shell').openExternal('https://github.com/atom/electron/issues') }
          }
        ]
      }
    ];
  } else {
    template = [
      {
        label: '&File',
        submenu: [
          {
            label: '&Open',
            accelerator: 'Ctrl+O',
          },
          {
            label: '&Close',
            accelerator: 'Ctrl+W',
            click: function() {
              var focusedWindow = BrowserWindow.getFocusedWindow();
              if (focusedWindow)
                focusedWindow.close();
            }
          },
        ]
      },
      {
        label: '&View',
        submenu: [
          {
            label: '&Reload',
            accelerator: 'Ctrl+R',
            click: function() {
              var focusedWindow = BrowserWindow.getFocusedWindow();
              if (focusedWindow)
                focusedWindow.reload();
            }
          },
          {
            label: 'Toggle &Full Screen',
            accelerator: 'F11',
            click: function() {
              var focusedWindow = BrowserWindow.getFocusedWindow();
              if (focusedWindow)
                focusedWindow.setFullScreen(!focusedWindow.isFullScreen());
            }
          },
          {
            label: 'Toggle &Developer Tools',
            accelerator: 'Alt+Ctrl+I',
            click: function() {
              var focusedWindow = BrowserWindow.getFocusedWindow();
              if (focusedWindow)
                focusedWindow.toggleDevTools();
            }
          },
        ]
      },
      {
        label: 'Help',
        submenu: [
          {
            label: 'Learn More',
            click: function() { require('shell').openExternal('http://electron.atom.io') }
          },
          {
            label: 'Documentation',
            click: function() { require('shell').openExternal('https://github.com/atom/electron/tree/master/docs#readme') }
          },
          {
            label: 'Community Discussions',
            click: function() { require('shell').openExternal('https://discuss.atom.io/c/electron') }
          },
          {
            label: 'Search Issues',
            click: function() { require('shell').openExternal('https://github.com/atom/electron/issues') }
          }
        ]
      }
    ];
  }

  var menu = Menu.buildFromTemplate(template);
  Menu.setApplicationMenu(menu);
});