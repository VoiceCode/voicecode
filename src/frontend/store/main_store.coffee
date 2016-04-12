{ combineReducers, applyMiddleware, createStore, bindActionCreators } = require 'redux'
ducks =
  commands: require '../ducks/command.coffee'
  packages: require '../ducks/package.coffee'

thunk = require('redux-thunk').default
logger = require('redux-logger')()


reducers = _.reduce ducks, (reducers, duck, id) ->
  reducers[id] = duck.reducer
  reducers
, {}

actionCreators = _.reduce ducks, (actionCreators, duck, id) ->
  _.extend actionCreators, duck.actionCreators
, {}

store = (initialState) ->
  store = createStore(combineReducers(reducers), initialState,
    applyMiddleware(
      thunk, logger
    ))
  store.actions = bindActionCreators actionCreators, store.dispatch
  store
module.exports = store
