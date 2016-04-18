_ = require 'lodash'
React = require 'react'
ReactDOM = require 'react-dom'
window.remote = require 'remote'
_events = remote.getGlobal 'Events'
window.emit = remote.getGlobal 'emit'
window.Events = {on: _events.frontendOn}
{ Provider } = require 'react-redux'
Main = require './containers/Main'
store = require './store'

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
