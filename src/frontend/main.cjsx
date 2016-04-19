_ = require 'lodash'
React = require 'react'
ReactDOM = require 'react-dom'
window.remote = require 'remote'
_events = remote.getGlobal 'Events'
window.emit = _events.emit
window.Events = {on: _events.frontendOn}
{ Provider } = require 'react-redux'
Main = require './containers/Main'
window.store = require './store'

subscribeToRemoteActions = ->
  Events.on 'packageCreated', store.actions.createPackage
  Events.on 'commandCreated', store.actions.createCommand
  Events.on 'commandEnabled', store.actions.enableCommand
  Events.on 'commandDisabled', store.actions.disableCommand
  Events.on 'implementationCreated', store.actions.createImplementation
subscribeToRemoteActions()

ReactDOM.render(
  <Provider store={ store }>
    <Main/>
  </Provider>
, document.getElementById('root'))
