# { combineReducers, applyMiddleware, createStore } = require 'redux'
# ducks =
#   commands: require '../ducks/command.coffee'
#   commands: require '../ducks/package.coffee'
#
# thunk = require('redux-thunk').default
# logger = require('redux-logger')()
#
#
# reducers = _.reduce ducks, (reducers, duck, id) ->
#   reducers[id] = duck.reducer
#   reducers
# , {}
#
# actionCreators = _.reduce ducks, (actionCreators, duck, id) ->
#   _.extend actionCreators, duck.actionCreators
# , {}
#
# store = (initialState) ->
# 6    applyMiddleware(
#       thunk, logger
#     ))
#   store
# module.exports = store
