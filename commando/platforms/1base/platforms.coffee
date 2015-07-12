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
  do: (name, input) ->
    command = new Commands.Base(name, input)
    command.generate().call(@)

  runCommand: (name, input) ->
    console.log "Deprecation: 'runCommand()' is deprecated. use '@do()' instead."
    @do(name, input)

  delay: (ms) ->
    Meteor.sleep(ms)

  setCurrentApplication: (application) ->
    @_currentApplication = application

  context: ->
    for item in Settings.contextChain
      result = item.call(@)
      return result if result?

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
