@Platforms =
	base: {}
	osx: {}
	windows: {}
	linux: {}
	android: {}
	ios: {}

# base actions shared by each platform
class Platforms.base.actions
  constructor: () ->
    @storage = {}
  stop: () ->
    @extensionsStopped = true
  setUndoByDeleting: (amount) ->
    Commands.currentUndoByDeletingCount = amount
  notUndoable: ->
    Commands.currentUndoByDeletingCount = 0
  undoByDeleting: ->
    amount = Commands.previousUndoByDeletingCount or 0
    _.times(amount) =>
      @key "Delete"

  # run another command
  do: (name, input, context={}) ->
    command = new Commands.Base(name, input, context)
    command.generate().call(@)

  runCommand: (name, input) ->
    console.log "Deprecation: 'runCommand()' is deprecated. use '@do()' instead."
    @do(name, input)

  delay: (ms) ->
    Meteor.sleep(ms)

  _normalizeModifiers: (modifiers) ->
    if modifiers?.length
      mods = if typeof modifiers is "string"
        modifiers.split(" ")
      else
        modifiers
      # titleize mods
      _.map mods, (m) ->
        m.charAt(0).toUpperCase() + m.slice(1)

  setCurrentApplication: (application) ->
    @_currentApplication = application

  context: ->
    for item in Settings.contextChain
      result = item.call(@)
      return result if result?

  enableDwellClicking: ->
    @_dwellClickingEnabled = true

  disableDwellClicking: ->
    @_dwellClickingEnabled = false

  dwellClickOnce: ->
    @_dwellClickOnce = true

  onDwell: (dwelling) ->
    if @_dwellClickingEnabled or @_dwellClickOnce
      @click()
      @_dwellClickOnce = false

  setGlobalMode: (mode) ->
    Commands.mode = mode

  getGlobalMode: ->
    Commands.mode

  retrieveClipboardWithName: (name) ->
    @_storedClipboard ?= {}
    @_storedClipboard[name]

  storeCurrentClipboardWithName: (name) ->
    @_storedClipboard ?= {}
    @_storedClipboard[name] = @getClipboard()

  startTextCapture: (callback) ->
    @_capturedText = ""
    @_capturingText = true
    @_captureTextCallback = callback

  normalizeTextArray: (textArray) ->
    results = []
    _.each textArray, (item) ->
      switch item
        when "'s"
          if results.length > 0
            results[results.length - 1] += "'s"
          # doesn't seem like it should be possible for the first item in a text array to be "'s", so don't add it
          # else
          #   results.push "'s"
        else
          results.push item
    if results.length
      results
    else
      null

  fuzzyMatch: (list, term) ->
    if list[term]?
      list[term]
    else
      results = {}
      _.each list, (item, key) ->
        totalDistance = _s.levenshtein(key, term)
        results[key] = totalDistance
      best = _.min _.keys(results), (k) ->
        results[k]
      list[best]

  fuzzyMatchKey: (list, term) ->
    if list[term]?
      term
    else
      results = {}
      _.each list, (item, key) ->
        totalDistance = _s.levenshtein(key, term)
        results[key] = totalDistance
      best = _.min _.keys(results), (k) ->
        results[k]
      best

  enableStrictMode: (mode) ->
    @strictMode = mode

  disableStrictMode: ->
    @strictMode = null

  commandPermitted: (command) ->
    if @strictMode?
      command in Settings.strictModes[@strictMode]
    else
      true

  # for specific applications/contexts
  sublime: ->
    new Contexts.Sublime()
