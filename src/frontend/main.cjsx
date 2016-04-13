React = require 'react'
{ render } = require 'react-dom'
window._ = require 'lodash'
window.remote = window.require 'remote'
window.Events = {}
_Events = remote.getGlobal 'Events'
Events.on = _Events.frontendOn
window.emit = remote.getGlobal 'emit'
{ Provider } = require 'react-redux'
window.nativeRequire = require

{ combineReducers, applyMiddleware, createStore, bindActionCreators } = require 'redux'
thunk = require('redux-thunk').default
logger = require('redux-logger')()
{ schema } = require './models.coffee'

rootReducer = combineReducers
  orm: schema.reducer()
  whatever: (state = {}) -> state # custom reducers go here

bootstrap = (schema) ->
  state = schema.getDefaultState()
  session = schema.withMutations state
  {Package, Command} = session

  pack = Package.create
    name: 'bootstrap:package'
    description: 'just a test'

  command = Command.create
      id: 'dummy:command'
      spoken: 'dummy'
      enabled: false
      packageId: 'bootstrap:package'
  return {
    orm: state
  }
createStoreWithMiddleware = applyMiddleware(thunk, logger)(createStore)
window.store = createStoreWithMiddleware(rootReducer, bootstrap(schema))

ducks =
  commands: require './ducks/command.coffee'
  packages: require './ducks/package.coffee'
actionCreators = _.reduce ducks, (actionCreators, duck, id) ->
  _.extend actionCreators, duck.actionCreators
, {}

store.actions = bindActionCreators actionCreators, store.dispatch
console.error 'SHOULD BE BOOTSTRAPPED'
Main = require './containers/Main.cjsx'

subscribeToRemoteActions = ->
  Events.on 'packageCreated', store.actions.createPackage
  Events.on 'commandCreated', store.actions.createCommand
  Events.on 'enableCommand', store.actions.enableCommand
  Events.on 'disableCommand', store.actions.disableCommand

renderMain = ->
  render <Provider store={ window.store }><Main /></Provider>, document.getElementById 'mount-point'


subscribeToRemoteActions()
renderMain()
