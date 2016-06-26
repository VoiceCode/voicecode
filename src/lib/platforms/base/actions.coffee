# base actions shared by each platform
# Actions is the context that every command is called with
# - so anything that should be available on 'this' within a command should be defined in the actions class

class Actions
  constructor: () ->
    @storage = {}
    @executionStack = []
  stop: () ->
    # @extensionsStopped = true
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



  # for specific applications/contexts
  sublime: ->
    new Contexts.Sublime()







module.exports = Actions
