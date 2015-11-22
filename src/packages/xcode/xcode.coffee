me =
  name: 'xcode'
  applications:
    'com.apple.dt.Xcode': 'Xcode'
  description: 'Xcode IDE integration'
  scope: 'xcode'

Settings.terminalApplications.push me.applications
Settings.editorApplications.push me.applications

Scope.register me
pack = Packages.register me
pack.before
  'editor:move-to-line-number': (input) ->
    @key 'l', 'command'
    if input?
      @delay 200
      @string input
      @delay 100
      @enter()
    @stop()
  'line.move.up': ->
    @key '[', 'command option'
    @stop()
