_ = require 'lodash'
React = require 'react'
ReactDOM = require 'react-dom'
window.remote = require 'remote'
_events = remote.getGlobal 'Events'
window.emit = _events.emit
window.Events = {on: _events.frontendOn}
{ Provider } = require 'react-redux'
History = require './containers/History'
window.store = require './stores/history'


subscribeToRemoteEvents = ->
  events = {
    'historicChainCreated': 'createChain'
    'historicChainLinkCreated': 'createChainLink'
    'currentApplicationChanged': 'setCurrentApplication'
  }
  _.each events, (handler, event) ->
    Events.on event, _.partial _.invoke, store, "actions.#{handler}"

subscribeToRemoteEvents()

ReactDOM.render(
  <Provider store={ store }>
    <History/>
  </Provider>
, document.getElementById('root'))
