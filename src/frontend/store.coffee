{ combineReducers, applyMiddleware, createStore, bindActionCreators } = require 'redux'
thunkMiddleware = require('redux-thunk').default
loggerMiddleware = require('redux-logger')()
requireDirectory = require 'require-directory'

{ schema } = require './models'
rootReducer = combineReducers
  orm: schema.reducer()
  whatever: (state = {}) -> state

bootstrap = (schema) ->
  state = schema.getDefaultState()
  session = schema.withMutations state
  {Package, Command} = session

  pack = Package.create
    name: 'bootstrap:package'
    description: 'just a test'

  command = Command.create
      id: 'bootstrap:command'
      spoken: 'dummy'
      enabled: false
      packageId: 'bootstrap:package'
  return {
    orm: state
  }
createStoreWithMiddleware = applyMiddleware(thunkMiddleware, loggerMiddleware)(createStore)
store = createStoreWithMiddleware(rootReducer, bootstrap(schema))

ducks = requireDirectory module, './ducks/'
actionCreators = _.reduce ducks, (actionCreators, duck, id) ->
  _.extend actionCreators, duck.actionCreators
, {}
{ bindActionCreators } = require 'redux'
store.actions = bindActionCreators actionCreators, store.dispatch

module.exports = store
