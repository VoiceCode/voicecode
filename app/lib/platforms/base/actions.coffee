# base actions shared by each platform
# Actions is the context that every command is called with
# - so anything that should be available on 'this' within a command should be defined in the actions class
# _s = require 'underscore.string'

fuzzy = require('clj-fuzzy')

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
    if _.isArray list
      if _.includes list, term
        term
      else
        results = {}
        for item in list
          levenshtein = fuzzy.metrics.levenshtein item, term
          # mra = 6 - (fuzzy.metrics.mra_comparison(item, term)?.similarity or 0)
          # caverphoneDistance = fuzzy.metrics.levenshtein(
          #   fuzzy.phonetics.caverphone(item),
          #   fuzzy.phonetics.caverphone(term)
          # )
          # soundex = fuzzy.metrics.levenshtein(
          #   fuzzy.phonetics.soundex(item),
          #   fuzzy.phonetics.soundex(term)
          # )
          # results[item] = mra + caverphoneDistance + soundex
          results[item] = levenshtein
        best = _.minBy _.keys(results), (k) ->
          results[k]
        best
    # object
    else
      if list[term]?
        list[term]
      else
        results = {}
        analysis = {}
        _.each list, (value, item) ->
          # mra = 6 - (fuzzy.metrics.mra_comparison(item, term)?.similarity or 0)
          # caverphoneDistance = fuzzy.metrics.levenshtein(
          #   fuzzy.phonetics.caverphone(item),
          #   fuzzy.phonetics.caverphone(term)
          # )
          # soundex = fuzzy.metrics.levenshtein(
          #   fuzzy.phonetics.soundex(item),
          #   fuzzy.phonetics.soundex(term)
          # )
          # results[item] = mra + caverphoneDistance + soundex
          levenshtein = fuzzy.metrics.levenshtein item, term
          results[item] = levenshtein
          analysis[item] =
            levenshtein: levenshtein
            # mra: mra
            # caverphone: caverphoneDistance
            # soundex: soundex
            # total: results[item]
          true
        best = _.minBy _.keys(results), (k) ->
          results[k]
        analysis =
          original: term
          results: analysis
        warning 'fuzzy', analysis
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
