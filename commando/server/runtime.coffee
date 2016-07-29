detectPlatform = ->
  switch process.platform
    when "darwin"
      "darwin"
    when "win32"
      "windows"
    when "linux"
      "linux"

detectProjectRoot = ->
  switch platform
    when "darwin"
      process.env.PWD
    when "windows"
      process.cwd().split("\\.meteor")[0]
    when "linux"
      process.env.PWD

@platform = detectPlatform()
@projectRoot = detectProjectRoot()

switch platform
  when "darwin"
    @$ = require('nodobjc')
    @Actions = new Platforms.osx.actions()
    @darwinController = new DarwinController()
  when "win32"
    @Actions = new Platforms.windows.actions()
  when "linux"
    @Actions = new Platforms.linux.actions()
