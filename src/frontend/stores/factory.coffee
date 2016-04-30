{applyMiddleware, createStore, bindActionCreators} = require 'redux'
thunkMiddleware = require('redux-thunk').default
loggerMiddleware = require('redux-logger')()
{combineReducers} = require 'redux-immutable'
immutable = require 'immutable'

_createStore = (ducks) ->
  reducers = _.reduce ducks, (reducers, duck, id) ->
    _.extend reducers, (duck.reducers or {})
  , {}

  rootReducer = combineReducers reducers
  mutationToggler = (inputState, {type}) ->
    if type is '__MUTABLE'
      return inputState.asMutable()
    if type is '__IMMUTABLE'
      return inputState.asImmutable().set 'isImmutable', true
    rootReducer.apply @, arguments

  createStoreWithMiddleware = applyMiddleware(
    thunkMiddleware
    , loggerMiddleware
    )(createStore)

  initialState = immutable.Map({}).asMutable()
  store = createStoreWithMiddleware(mutationToggler, initialState)

  actionCreators = _.reduce ducks, (actionCreators, duck, id) ->
    _.extend actionCreators, duck.actionCreators
  , {}
  { bindActionCreators } = require 'redux'
  store.actions = bindActionCreators actionCreators, store.dispatch
  store

module.exports = _createStore
