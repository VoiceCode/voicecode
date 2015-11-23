pack = Packages.register
  name: 'xcode'
  applications: ['com.apple.dt.Xcode']
  description: 'Xcode IDE integration'
  scope: 'xcode'

Settings.terminalApplications.push pack.applications
Settings.editorApplications.push pack.applications

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
