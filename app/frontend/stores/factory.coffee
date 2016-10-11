{applyMiddleware, createStore, bindActionCreators} = require 'redux'
thunkMiddleware = require('redux-thunk').default
loggerMiddleware = require('redux-logger')()
{hashHistory} = require('react-router')
{routerMiddleware, LOCATION_CHANGE} = require('react-router-redux')
{combineReducers} = require 'redux-immutable'
immutable = require 'immutable'
initialRouterState = immutable.fromJS
  locationBeforeTransitions: undefined

_createStore = (ducks) ->
  reducers = _.reduce ducks, (reducers, duck, id) ->
    _.extend reducers, (duck.reducers or {})
  , {}
  _.extend reducers, router: (router = initialRouterState, action) ->
    if action.type is LOCATION_CHANGE
      router.merge
        locationBeforeTransitions: action.payload
    else
      router
  rootReducer = combineReducers reducers

  mutationToggler = (inputState, {type}) ->
    if type is '__MUTABLE'
      return inputState.asMutable()
    if type is '__IMMUTABLE'
      return inputState.asImmutable().set 'is_immutable', true
    rootReducer.apply @, arguments

  router = routerMiddleware(hashHistory)
  middleware = [
    thunkMiddleware,
    router
  ]
  if developmentMode
    middleware.push loggerMiddleware
  enhancer = applyMiddleware.apply null, middleware

  initialState = immutable.Map({})
  if developmentMode
    initialState = initialState.asMutable()
  store = createStore(mutationToggler, initialState, enhancer)

  actionCreators = _.reduce ducks, (actionCreators, duck, id) ->
    _.extend actionCreators, duck.actionCreators
  , {}

  { bindActionCreators } = require 'redux'
  store.actions = bindActionCreators actionCreators, store.dispatch
  store

module.exports = _createStore
