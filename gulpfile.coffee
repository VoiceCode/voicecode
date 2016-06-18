# /node_modules/.bin/electron-rebuild -v v0.37.3 -n 48
# cd node_modules/fibers
# HOME=~/.electron-gyp node-gyp rebuild --target=0.37.3 --arch=x64 --dist-url=https://atom.io/download/atom-shell
# mkdir ./bin/darwin-x64-v8-4.9/
# mv build/Release/fibers.node bin/darwin-x64-v8-4.9/

gulp = require('gulp')
electron = require('electron-connect').server.create()
path = require('path')
exec = require 'gulp-exec'


gulp.task 'serve', [], ->
  electron.start ['develop',
  '--disable-http-cache',
  '--enable-transparent-visuals']
  gulp.watch './src/**/*.coffee', ['electron-restart']
  gulp.watch 'src/frontend/**/*.less', [ 'electron-reload' ]
  # gulp.watch 'src/frontend/**/*.cjsx', [ 'electron-reload' ]
  gulp.watch 'src/frontend/**/*.html', [ 'electron-restart' ]


gulp.task 'electron-rebuild', ->
  exec './node_modules/.bin/electron-rebuild -v 0.34.2 -n 48'
  return

gulp.task 'electron-reload', ->
  electron.reload()
  return

gulp.task 'electron-restart', ->
  electron.restart ['develop',
  '--disable-http-cache',
  '--enable-transparent-visuals']

electron.on 'appClosed', ->
  electron.stop ->
    process.exit 0
    return
  return

gulp.task 'default', [ 'serve' ]
