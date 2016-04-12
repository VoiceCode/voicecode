React = require 'react'
{ render } = require 'react-dom'
window._ = require 'lodash'
window.remote = window.require 'remote'
window.Events = {}
_Events = remote.getGlobal 'Events'
Events.on = _Events.frontendOn
window.emit = remote.getGlobal 'emit'
{ Provider, connect } = require 'react-redux'
Main = require './containers/Main.cjsx'
immutable = require 'immutable'

subscribeToRemoteActions = ->
  Events.on 'packageCreated', store.actions.createPackage
  Events.on 'commandCreated', store.actions.createCommand
  Events.on 'enableCommand', store.actions.enableCommand
  Events.on 'disableCommand', store.actions.disableCommand

renderMain = ->
  render <Provider store={ window.store }><Main /></Provider>, document.getElementById 'mount-point'

# if remote.getGlobal('startedUp')?
#   renderMain()
# else
#   Events.on 'startupFlow:complete', => renderMain()


initialState = {
  commands: immutable.fromJS({})
  packages: immutable.fromJS({})
}
window.store = require('./store/main_store.coffee')(initialState)

subscribeToRemoteActions()
renderMain()
