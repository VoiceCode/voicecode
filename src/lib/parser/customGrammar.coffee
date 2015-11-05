customGrammarParser = require './customGrammarParser'
SpeakableList = require './speakableList'

class CustomGrammar
  constructor: (@rule, @definitions = {}) ->
    @parsed = customGrammarParser.parse @rule
    @tokens = @parsed.tokens
    @handleDuplicateLists()
    @includeName = @parsed.includeName
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
      if token.list
        @listNames.push token.uniqueName
        @lists[token.name] ?= new SpeakableList(@optionsForList(token))

  optionsForList: (token) ->
    if token.list.length > 1
      token.list
    else
      definition = @definitions[token.name]
      if definition?
        if typeof definition is 'function'
          definition()
        else
          definition
      else
        token.list

  normalizeInput: (input={}) ->
    results = {}
    for name in @listNames
      spoken = input[name]
      if spoken?
        spokenList =
        results[name] = @lists[@reverseNameLookup[name]].value(spoken)
    results

  listsWithOptions: (kind='spoken') ->
    results = {}
    for key, value of @lists
      results[key] = value.options(kind)
    results

module.exports = CustomGrammar
