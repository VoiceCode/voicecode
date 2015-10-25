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
      @key "delete"

  # run another command
  do: (name, input=null, context={}) ->
    command = new Command(name, input, context)
    command.generate().call(@)

  runCommand: (name, input) ->
    console.log "Deprecation: 'runCommand()' is deprecated. use '@do()' instead."
    @do(name, input)

  delay: (ms) ->
    Meteor.sleep(ms)

  repeat: (times, callback) ->
    _(times).times callback

  _normalizeModifiers: (modifiers) ->
    if modifiers?.length
      mods = if typeof modifiers is "string"
        modifiers.split(" ")
      else
        modifiers
      # titleize mods
      _.map mods, (m) =>
        actual = m.toLowerCase()
        if actual is "super"
          @resolveSuperModifier()
        else
          actual

  setCurrentApplication: (application) ->
    console.log currentApplication: application
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

  storeItem: (namespace, itemName, item) ->
    @storage[namespace] ?= {}
    @storage[namespace][itemName] = item

  getStoredItem: (namespace, itemName) ->
    @storage[namespace]?[itemName]
    
  normalizeTextArray: (textArray) ->
    results = []
    _.each textArray, (item) ->
      if typeof item is "object"
        results.push item.text
      else
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
    # array
    if Object::toString.call(list) is '[object Array]'
      if _.contains list, term
        term
      else
        results = {}
        for item in list
          results[item] = _s.levenshtein(item, term)
        best = _.min _.keys(results), (k) ->
          results[k]
        best
    # object
    else
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

  # short utility methods

  copy: ->
    @key 'c', 'super' ; @
  cut: ->
    @key 'x', 'super' ; @
  paste: ->
    @key 'v', 'super' ; @
  undo: ->
    @key 'z', 'super' ; @
  redo: ->
    @key 'z', 'super shift' ; @
  newTab: ->
    @key 't', 'super' ; @
  selectAll: ->
    @key 'a', 'super' ; @
  save: ->
    @key 's', 'super' ; @
  switchApplication: ->
    @key 'tab', 'command' ; @
  space: ->
    @string ' ' ; @
  enter: ->
    @key 'return' ; @
  up: (times) ->
    times ?= 1
    @repeat times, =>
      @key 'up'
    @
  down: (times) ->
    times ?= 1
    @repeat times, =>
      @key 'down'
    @
  left: (times) ->
    times ?= 1
    @repeat times, =>
      @key 'left'
    @
  right: (times) ->
    times ?= 1
    @repeat times, =>
      @key 'right'
    @

