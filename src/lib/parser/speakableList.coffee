class SpeakableList
  # takes an array or an object
  # _ represents a misspelling
  # + represents a default

  constructor: (@items) ->
    @kind = if _.isArray @items
      'array'
    else
      'object'

    @misspellings = {}

    if @kind is 'object'
      @initializeObject()
    else
      @initializeArray()

  initializeObject: ->
    normalized = {}
    _.each @items, (value, key) =>
      if key[0] is '+'
        actual = key.replace('+', '')
        @defaultValue = actual
        normalized[actual] = value
      else if key[0] is "_"
        actual = key.replace('_', '')
        @misspellings[actual] = value
      else
        normalized[key] = value
    @items = normalized

  initializeArray: ->
    normalized = []
    _.each @items, (key) =>
      if key[0] is '+'
        actual = key.replace('+', '')
        @defaultValue = actual
        normalized.push actual
      else
        normalized.push key
    @items = normalized

  speakableValues: ->
    if @kind is 'object'
      _.keys(@items)
    else
      @items

  recognizableValues: ->
    if @kind is 'object'
      _.keys(@items).concat(_.keys(@misspellings))
    else
      @items

  options: (kind='spoken') ->
    if kind is 'spoken'
      @speakableValues()
    else
      @recognizableValues()

  defaultValue: ->
    if @kind is 'object'
      @items[@defaultValue]
    else
      @defaultValue

  value: (spoken) ->
    if spoken?
      if @kind is 'object'
        @items[spoken] or @misspellings[spoken] or Actions.fuzzyMatch(@items, spoken)
      else
        Actions.fuzzyMatch @items, spoken
    else
      @defaultValue

module.exports = SpeakableList
