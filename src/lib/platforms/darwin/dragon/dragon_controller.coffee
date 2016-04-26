class DarwinDragonController
  instance = null
  constructor: ->
    return instance if instance?
    instance = @
    @forever = require "forever-monitor"
    @dragonInstance = null
    @bootstrapped = false
    if Settings.dragonProcessControl
      @start()

  start: ->
    unless @bootstrapped
      @bootstrap()
    if @dragonInstance?
      @restart()
    else
      @dragonInstance = @forever.start '',
        command: "#{@dragonApplicationPath}Contents/MacOS/#{@dragonApplicationName}"
        silent: true
        sourceDir: ''
        cwd: "#{@dragonApplicationPath}Contents/MacOS/"

    @dragonInstance.on 'start', =>
      log 'dragonStarted', @dragonInstance,
    @dragonInstance.on 'restart', =>
      log 'dragonRestarted', @dragonInstance.times,
      'Restarting Dragon for ' + @dragonInstance.times + ' time'
    @dragonInstance.on 'exit:code', (code) ->
      error 'dragonExited', code
    @dragonInstance.on 'stderr', (buffer) =>
      if buffer.toString().indexOf('>> TRACE') >= 0
        @dragonInstance.kill()

  stop: ->
    return unless @dragonInstance?
    @dragonInstance.stop()

  restart: (force = false) ->
    return if Settings.dragonProcessControl
    if @dragonInstance? # faulty way of checking
      @dragonInstance.restart()
    else
      if force
        Execute "kill #{@dragonApplicationName}"
        setTimeout =>
          @start()
        , 3000
      else
        start()

  bootstrap: ->
    @dragonApplicationName = 'Dragon'
    @dragonApplicationPath = Applescript """
      tell application "Finder"
        POSIX path of (application file id "com.dragon.dictate" as alias)
      end tell
    """
    @dragonApplicationPath = @dragonApplicationPath?.trim()
    Events.on 'dragonSynchronizingStarted', => @stop()
    Events.on 'dragonSynchronizingEnded', => @start()
    process.on 'exit', => @stop()
    @bootstrapped = true

module.exports = new DarwinDragonController
