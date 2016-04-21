{ applyMiddleware, createStore, bindActionCreators } = require 'redux'
thunkMiddleware = require('redux-thunk').default
loggerMiddleware = require('redux-logger')()
requireDirectory = require 'require-directory'
{combineReducers} = require 'redux-immutable'
immutable = require 'immutable'

ducks = requireDirectory module, './ducks/'
reducers = _.reduce ducks, (reducers, duck, id) ->
  _.extend reducers, (duck.reducers or {})
, {}

initialState = immutable.Map {}
rootReducer = combineReducers reducers

createStoreWithMiddleware = applyMiddleware(
  thunkMiddleware, loggerMiddleware
  )(createStore)

store = createStoreWithMiddleware(rootReducer, initialState)

actionCreators = _.reduce ducks, (actionCreators, duck, id) ->
  _.extend actionCreators, duck.actionCreators
, {}
{ bindActionCreators } = require 'redux'
store.actions = bindActionCreators actionCreators, store.dispatch

module.exports = store
