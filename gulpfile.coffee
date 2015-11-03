# /node_modules/.bin/electron-rebuild -v 0.34.2 -n 48
# cd node_modules/fibers
# HOME=~/.electron-gyp node-gyp rebuild --target=0.34.2 --arch=x64 --dist-url=https://atom.io/download/atom-shell
# mkdir ./bin/darwin-x64-v8-4.5/
# mv build/Release/fibers.node bin/darwin-x64-v8-4.5/

gulp = require('gulp')
browserify = require('browserify')
babelify = require('babelify')
source = require('vinyl-source-stream')
coffee = require 'gulp-coffee'
reactify = require 'coffee-reactify'
electron = require('electron-connect').server.create()
atom = require 'gulp-atom'
less = require 'gulp-less'
path = require('path')
install = require 'gulp-install'
exec = require 'gulp-exec'
clean = require 'gulp-rimraf'

gulp.task 'install', ->
  gulp.src('./package.json')
    .pipe(gulp.dest('./build'))
    .pipe(install({production: true}))

gulp.task 'build', ['install'], ->
  atom
    srcPath : './dist'
    releasePath : './build'
    cachePath : './cache'
    version : 'v0.34.2'
    rebuild : true,
    platforms : ['darwin-x64']

gulp.task 'serve', [
  # 'clean-up'
  'build-html'
  'build-css'
  'build-coffee'
  'move-js'
  'build-front-end-js'
], ->
  electron.start ['--disable-http-cache']
  gulp.watch './src/**/*.coffee', ['rebuild-coffee']
  gulp.watch 'src/frontend/**/*.less', [ 'rebuild-css' ]
  gulp.watch 'src/frontend/**/*.cjsx', [ 'rebuild-front-end-js' ]
  gulp.watch 'src/frontend/**/*.html', [ 'rebuild-html' ]

gulp.task 'clean-up', ->
  gulp.src('dist/**/*', {read: false})
    .pipe(clean(force: true))


gulp.task 'electron-rebuild', ->
  exec './node_modules/.bin/electron-rebuild -v 0.34.2 -n 48'

gulp.task 'rebuild-html', [ 'build-html' ], ->
  electron.reload()
  return

gulp.task 'rebuild-css', [ 'build-css' ], ->
  electron.reload()
  return

gulp.task 'rebuild-front-end-js', [ 'build-front-end-js' ], ->
  electron.reload()
  return

gulp.task 'rebuild-coffee', ['build-coffee'], ->
  electron.restart ['--disable-http-cache']

gulp.task 'build-package', ->
  exec 'npm install'

gulp.task 'build-coffee', ->
  gulp.src './src/**/*.coffee'
    .pipe coffee()
    .pipe gulp.dest('./dist')


gulp.task 'move-js', ->
  gulp.src './src/!(frontend)/**/*.js'
  .pipe gulp.dest('dist/')

gulp.task 'build-front-end-js', ->
  browserify(
    entries : ['./src/frontend/main.cjsx']
    transform : [reactify]
    debug: true)
    .transform(babelify)
    .bundle()
    .pipe(source('main.js'))
    .pipe gulp.dest('dist/frontend/')

gulp.task 'build-html', ->
  gulp.src('src/frontend/**/*.html')
  .pipe gulp.dest('dist/frontend/')

gulp.task 'build-css', ->
  gulp.src('src/frontend/styles/*.less')
  .pipe(less())
  .pipe gulp.dest('dist/frontend/')

electron.on 'appClosed', ->
  electron.stop ->
    process.exit 0
    return
  return

gulp.task 'default', [ 'serve' ]
