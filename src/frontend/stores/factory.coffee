{applyMiddleware, createStore,
bindActionCreators, combineReducers} = require 'redux'
thunkMiddleware = require('redux-thunk').default
loggerMiddleware = require('redux-logger')()
{hashHistory} = require('react-router')
{routerMiddleware, routerReducer} = require('react-router-redux')
# {combineReducers} = require 'redux-immutable'
immutable = require 'immutable'
initialRouterState = immutable.fromJS
  locationBeforeTransitions: undefined

_createStore = (ducks) ->
  reducers = _.reduce ducks, (reducers, duck, id) ->
    _.extend reducers, (duck.reducers or {})
  , {}
  _.extend reducers, routing: routerReducer

  rootReducer = combineReducers reducers

  # mutationToggler = (inputState, {type}) ->
  #   if type is '__MUTABLE'
  #     return inputState.asMutable()
  #   if type is '__IMMUTABLE'
  #     return inputState.asImmutable().set 'isImmutable', true
  #   rootReducer.apply @, arguments

  routing = routerMiddleware(hashHistory)
  middleware = [
    thunkMiddleware,
    routing
  ]
  if developmentMode
    middleware.push loggerMiddleware
  enhancer = applyMiddleware.apply null, middleware

  initialState = {}
  # if developmentMode
  #   initialState = initialState.asMutable()
  store = createStore(rootReducer, initialState, enhancer)

  actionCreators = _.reduce ducks, (actionCreators, duck, id) ->
    _.extend actionCreators, duck.actionCreators
  , {}
  _.extend actionCreators, changePage: (page = '/') ->
    (dispatch, getState) ->
      dispatch push "/#{page}".replace '/', ''

  { bindActionCreators } = require 'redux'
  store.actions = bindActionCreators actionCreators, store.dispatch
  store

module.exports = _createStore
