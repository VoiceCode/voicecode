{ createAction } = require 'redux-actions'
immutable = require 'immutable'

constants =
  CREATE_GRAMMAR: 'CREATE_GRAMMAR'
  UPDATE_GRAMMAR: 'UPDATE_GRAMMAR'

_.extend @, constants
_.extend exports, constants

actionCreators =
  createGrammar: createAction(@CREATE_GRAMMAR)
  updateGrammar: createAction(@UPDATE_GRAMMAR)


exports.actionCreators = actionCreators

exports.reducers =
  grammars: (grammars = immutable.Map({}), {type, payload}) =>
    switch type
      when @CREATE_GRAMMAR, @UPDATE_GRAMMAR
        lists = _.reduce payload.lists,((lists, value, listName) ->
          speakable = if _.isArray(value.items)
            value.items
          else
            _.keys(value.items)
          misspellings = if _.isArray(value.misspellings)
            value.misspellings
          else
            _.keys(value.misspellings)
          lists[listName] = speakable.concat misspellings
          lists
        ), {}
        grammars.set payload.id, immutable.Map lists
      else
        grammars
