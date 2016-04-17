_ = require 'lodash'
React = require 'react'
ReactDOM = require 'react-dom'
remote = require 'remote'
_events = remote.getGlobal 'Events'
window.emit = remote.getGlobal 'emit'
window.Events = {on: _events.frontendOn}

{ Provider } = require 'react-redux'
{ combineReducers, applyMiddleware, createStore, bindActionCreators } = require 'redux'
thunkMiddleware = require('redux-thunk').default
loggerMiddleware = require('redux-logger')()
{ schema } = require './models'
Main = require './containers/Main'
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
window.store = createStoreWithMiddleware(rootReducer, bootstrap(schema))

ducks =
  commands: require './ducks/command.coffee'
  packages: require './ducks/package.coffee'
actionCreators = _.reduce ducks, (actionCreators, duck, id) ->
  _.extend actionCreators, duck.actionCreators
, {}
{ bindActionCreators } = require 'redux'
store.actions = bindActionCreators actionCreators, store.dispatch

subscribeToRemoteActions = ->
  Events.on 'packageCreated', store.actions.createPackage
  Events.on 'commandCreated', store.actions.createCommand
  Events.on 'enableCommand', store.actions.enableCommand
  Events.on 'disableCommand', store.actions.disableCommand
subscribeToRemoteActions()

ReactDOM.render(
  <Provider store={ store }>
    <Main/>
  </Provider>
, document.getElementById('root'))
