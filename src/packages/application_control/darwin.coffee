return unless pack = Packages.get 'darwin'

pack.implement
  'application-control:previous.application': ->
    @switchApplication()
    @delay(250)
  'application-control:open.launcher': ->
    @key ' ', 'command'
    @delay 100
  'application-control:open.preferences': ->
    @key ',', 'command'
  'application-control:open.search': ->
    @key ' ', 'command'
    @delay 100
  'application-control:open.application-switcher': ->
    @keyDown 'command', 'command'
    @keyDown 'tab', 'command'
    @keyUp 'tab', 'command'
    @delay 10000
    @keyUp 'tab', 'command'
    @keyUp 'command'
  'application-control:open.browser': ->
    @openBrowser()
    @newTab()
    @delay 200
  'application-control:open.application': ({application}) ->
    if application?
      @openApplication application
    else
      @do 'application-control:open.launcher'
  'application-control:next.window': ->
    @key '`', 'command'
  'application-control:previous.window': ->
    @key '`', 'command shift'
