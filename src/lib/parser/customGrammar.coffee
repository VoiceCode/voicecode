customGrammarParser = require './customGrammarParser'
SpeakableList = require './speakableList'

class CustomGrammar
  constructor: (@spoken, @rule, @variables = {}) ->
    @tokens = customGrammarParser.parse(@rule).tokens
    @handleDuplicateLists()
    @initializeSections()

  handleDuplicateLists: ->
    found = []
    @reverseNameLookup = {}
    for token in @tokens
      count = _.filter(found, (item) ->
        item is token.name
      ).length

      if count > 0
        token.uniqueName = [token.name, count].join('')
      else
        token.uniqueName = token.name

      @reverseNameLookup[token.uniqueName] = token.name
      found.push token.name

  initializeSections: ->
    @listNames = []
    @lists = {}
    for token in @tokens
      switch token.kind
        # when 'special'
        # when 'text'
        when 'list'
          @listNames.push token.uniqueName
          @lists[token.name] ?= new SpeakableList(@optionsForList(token))
        when 'inlineList'
          @listNames.push token.uniqueName
          @lists[token.name] ?= new SpeakableList(token.options)

  optionsForList: (token) ->
    definition = @variables[token.name]
    if definition?
      if _.isFunction definition
        definition()
      else
        definition
    else
      [token.name]

  normalizeInput: (input={}) ->
    results = {}
    for name in @listNames
      spoken = input[name]

      # it might be an array like ['top', '-', 'right'] => 'top right'
      if _.isArray spoken
        spoken = spoken.map (word) ->
          if word is '-'
            ' '
          else
            word
        .join ' '

      if spoken?
        results[name] = @lists[@reverseNameLookup[name]].value(spoken)
    results

  listsWithOptions: (kind='spoken') ->
    results = {}
    for key, value of @lists
      results[key] = value.options(kind)
    results

  speakableCombinations: ->
    result = ['']
    for token in @tokens
      additions = []
      switch token.kind
        when 'special'
          switch token.name
            when 'spoken'
              additions = [@spoken]
            # when 'text'
              # TODO
        when 'list', 'inlineList'
          additions = @lists[token.name].speakableValues()
        when 'text'
          additions = [token.text]
      if token.optional
        additions.push ''
      result = _.flatten _.map result, (existing) ->
        _.map additions, (addition) ->
          [existing, addition].join(' ')

    _.map result, (item) ->
      item.toLowerCase().trim().replace /\s+/, ' '

module.exports = CustomGrammar
