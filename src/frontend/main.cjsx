(
  () ->
    React = require 'react'
    ReactDOM = require 'react-dom'
    window._ = require 'lodash'
    window.remote = window.require 'remote'
    _Events = remote.getGlobal 'Events'
    window.Events = {}
    Events.on = _Events.frontendOn
    window.emit = remote.getGlobal 'emit'

    Main = require './windows/Main.cjsx'
    renderMain = -> ReactDOM.render <Main />, document.getElementById 'mount-point'
    if remote.getGlobal('startedUp')?
      renderMain()
    else
      Events.on 'startupFlowComplete', => renderMain()

)()
