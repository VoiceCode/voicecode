module.exports = class VocabularyController
  constructor: ->
    # lists of strings that should be added as vocab to boost accuracy
    @lists = {}

  start: ->
    @generate()

    Events.on 'userAssetsLoaded', () =>
      @generate()

    return @

  generate: ->
    error 'abstractMethodCalled', 'VocabularyController:generate'

  generateVocabularyTraining: ->
    result = []
    for category, generator of @lists
      for phrase in generator()
        if _.isArray phrase
          # this means it is vocabulary alternate - so use the 'written' form. Not sure how to handle this
          result.push phrase[0]
        else
          result.push phrase
    result.join ' '

  addList: (name, listGenerator) ->
    @lists[name] = listGenerator
