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

subscribeToRemoteEvents = ->
  events = {
    'packageCreated': 'createPackage'
    'commandCreated': 'createCommand'
    'commandEnabled': 'enableCommand'
    'commandDisabled': 'disableCommand'
    # 'implementationCreated'
  }
  _.every events, (handler, event) ->
    Events.on event, _.partial _.invoke, store, "actions.#{handler}"

subscribeToRemoteEvents()

ReactDOM.render(
  <Provider store={ store }>
    <Main/>
  </Provider>
, document.getElementById('root'))
