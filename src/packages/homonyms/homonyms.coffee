class Homonyms
  constructor: (values) ->
    @values = @normalizeValues values
    @initialize()
  initialize: ->
    @sorted = {}
    for row in @values
      for word in row
        @sorted[word.toLowerCase()] = row
  next: (word) ->
    list = @sorted[word]
    if list?
      index = _.map(list, (e) -> e.toLowerCase()).indexOf(word) + 1
      if index >= list.length
        index = 0
      list[index]
  normalizeValues: (values) ->
    _.map values, (item) ->
      if _.isArray item
        item
      else if _.isString item
        item.split(/, |\n/)

module.exports = Homonyms
