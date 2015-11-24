pack = Packages.register
  name: 'xcode'
  applications: ['com.apple.dt.Xcode']
  description: 'Xcode IDE integration'
  createScope: true

Settings.extend 'terminalApplications', pack.applications()
Settings.extend 'editorApplications', pack.applications()

pack.before
  'editor:move-to-line-number': (input) ->
    @key 'l', 'command'
    if input?
      @delay 200
      @string input
      @delay 100
      @enter()
  'line.move.up': ->
    @key '[', 'command option'
