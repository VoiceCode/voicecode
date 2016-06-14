_ = require 'lodash'
React = require 'react'
ReactDOM = require 'react-dom'
window.remote = require 'remote'
_events = remote.getGlobal 'Events'
window.emit = _events.emit
window.Events = {on: _events.frontendOn}
{ Provider } = require 'react-redux'
Main = require './containers/Main'
window.store = require './stores/main'

subscribeToRemoteEvents = ->
  events = {
    'apiCreated': 'createApi'
    'packageCreated': 'createPackage'
    'commandCreated': 'createCommand'
    'commandEnabled': 'enableCommand'
    'commandDisabled': 'disableCommand'
    'implementationCreated': 'implementationCreated'
    'startupFlow:complete': 'appStart'
  }
  _.each events, (handler, event) ->
    Events.on event, _.partial _.invoke, store, "actions.#{handler}"

subscribeToRemoteEvents()

ReactDOM.render(
  <Provider store={ store }>
    <Main/>
  </Provider>
, document.getElementById('root'))


emit 'applicationShouldStart'
