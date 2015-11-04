class DarwinDragonController
  instance = null
  constructor: ->
    return instance if instance?
    @forever = require "forever-monitor"
    @dragonInstance = null
    @dragonApplicationName = if Settings.dragonVersion is 4
        'Dragon Dictate'
      else
        'Dragon'
    @dragonApplicationPath =
    Applescript """
                set D to id of application "#{@dragonApplicationName}"
                tell application "Finder"
                  POSIX path of (application file id D as alias)
                end tell
                """
    @dragonApplicationPath = @dragonApplicationPath?.trim()
    unless Settings.dontMessWithMyDragon
      Events.on 'dragonSynchronizingEnded', => @restart()
    instance = @
  start: ->
    if @dragonInstance?
      @restart()
    else
      Execute "killall #{@dragonApplicationName}"
      @dragonInstance = @forever.start '',
        command: "#{@dragonApplicationPath}Contents/MacOS/#{@dragonApplicationName}"
        silent: true
        sourceDir: ''
        cwd: "#{@dragonApplicationPath}Contents/MacOS/"

    @dragonInstance.on 'restart', =>
      emit 'dragonRestart', @dragonInstance.times,
      'Restarting Dragon for ' + @dragonInstance.times + ' time'
    @dragonInstance.on 'exit:code', (code) ->
      error 'dragonExit', code
    @dragonInstance.on 'stderr', (buffer) =>
      if buffer.toString().indexOf('>> TRACE') >= 0
        @dragonInstance.kill()


  stop: ->
    return false unless @dragonInstance?
    @dragonInstance.stop()

  restart: ->
    if @dragonInstance?
      @dragonInstance.restart()
    else
      @start()
module.exports = new DarwinDragonController
