# base actions shared by each platform
# Actions is the context that every command is called with
# - so anything that should be available on 'this' within a command should be defined in the actions class

class Actions
  constructor: () ->
    @storage = {}
    @executionStack = []
  stop: () ->
    @executionStack[0] = false
  continue: () ->
    @executionStack[0] = true
  packageSettings: (packageId) ->
    Settings[packageId]
  setUndoByDeleting: (amount) ->
    # TODO: implement
  undoByDeleting: ->
    # TODO: implement

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

  fuzzyMatch: (list, term) ->
    # array
    if Object::toString.call(list) is '[object Array]'
      if _.includes list, term
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

module.exports = Actions
